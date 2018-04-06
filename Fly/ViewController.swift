
import Foundation
import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var flyButton: UIButton!

    var origin: Airport = Airport("DUB")
    var stations: [Station] = []
    var destinations: [Airport] = []
    var watchlist: [Airport] = []
    
    var fares: [Cheapest] = []
    var mapAnnotations: [MapAnnotiation] = []
    
    var holiday = Holiday(on: .nextThreeMonths, duration: .afew, budget: 100)
    var best: [Trip] = []

    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        activityIndicatorView.stopAnimating()
        addGestureRecognisers()
        
        print(x)
    }
    
    func addGestureRecognisers() {
        if(traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: mapView)
        } else {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.showPreferences))
            mapView.addGestureRecognizer(longPress)
        }
    }
    
    //MARK: - search
    @IBAction func didTapSearch(_ sender: Any) {
        activityIndicatorView.startAnimating()
        search()
    }
    
    func search() {
        flyButton.isHidden = true
        title = "🤔"
        getStations {
            self.findFares {
                self.findBest()
                let destinations = self.fares.flatMap { $0.destination }.unique()
                print(destinations)
                let annotations: [MapAnnotiation] = destinations.flatMap { station in
                    guard let station = (self.stations.filter { $0.airport == station && $0.airport != self.origin }).first else { return nil }
                    return MapAnnotiation(station: station)
                }
                print(annotations)
                self.mapAnnotations = annotations
                self.updateMapAnimated(annotations: self.mapAnnotations)
            }
        }
    }
    
    //MARK: - update map
    func updateMapAnimated(annotations: [MKAnnotation]) {
        OperationQueue.main.addOperation {
            self.title = ""
            self.activityIndicatorView.stopAnimating()
            self.flyButton.isHidden = false
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView?.showAnnotations(annotations, animated: true)
        }
    }
    
    //MARK: - get stations
    func getStations(completion: @escaping Callback) {
        Scraper.scrape(resource: .stations) { results in
            let allStations = results.reduce([], { (partial, dictionary) -> [Station] in
                guard let results = dictionary["results"] as? Labels,
                let stations = results["stations"] as? [Labels] else { return partial }
                let u = stations.flatMap { Station($0) }
                
                return partial + u
            })
            
            let servingStations = Array(Set(allStations.filter { $0.markets.contains(self.origin.code) }))
            self.stations = servingStations
            self.destinations = servingStations.map { $0.airport }
            self.watchlist = Array((self.destinations.filter { !(self.fares.map{ $0.destination.code }).contains($0.code)}).shuffled().prefix(5))
            
            completion()
        }
    }
    
    //MARK: - find fares
    func findFares(_ completion: @escaping Callback) {
      let searchOptions = TripPreferences(holiday: holiday, origin: origin, destinations: watchlist)
    
      Scraper.scrape(resource: .cheapest(preferences: searchOptions)) { results in
        results.forEach { dictionary in
            guard let url = dictionary["url"] as? URL,
                let dict = dictionary["results"] as? Labels,
                let outbound = dict["outbound"] as? Labels,
                let allFares = outbound["fares"] as? [Labels]
                else { print(dictionary) ; return  }
            
            
            let from = Airport(url.path.components(separatedBy: "/")[4])
            let to = Airport(url.path.components(separatedBy: "/")[5])
            let fares = allFares.flatMap { Fare(labelled: $0) }.filter { !$0.unavailable && !$0.soldOut }
            
            if fares.count > 0 {
                //print(from.code, to.code, fares.count, fares.byPrice().map { $0.price.description })
                self.fares += [Cheapest(origin: from, destination: to, fares: fares.byPrice())]
            }
        }

        completion()
      }
    }
    
    func findBest() {
        let outbound = fares.filter { $0.origin.code == origin.code }.byPrice()
        let inbound = fares.filter { $0.destination.code == origin.code }.byPrice()
        
        let trips = outbound.reduce([], { (partial, departing) -> [Trip] in
            let returnFares = inbound.filter { returning in
                 returning.origin.code == departing.destination.code
            }.flatMap { $0.fares.byDate() }
            let outboundFares = departing.fares.byDate()
            
            let mm = outboundFares.reduce([], { (fares, next) -> [Trip] in
                return fares + returnFares.filter { $0.day.compare(next.day) == .orderedDescending }.map {Trip(origin: departing.origin, destination: departing.destination, outbound: next, inbound: $0)}
            })
            return partial + mm
        })
        
        best = trips.filter { $0.sameCurrency && Int($0.totalPrice) <= holiday.budget && $0.duration <= holiday.duration.span.upperBound }.sorted { $0.totalPrice < $1.totalPrice }
        best = best.sorted { $0.points(holiday.budget) > $1.points(holiday.budget) }
        //print(best.forEach { print($0.points(holiday.budget), $0.catchPhrase) })
    }
    
    //MARK: - show preferencess
    @objc func showPreferences() {
        guard let preferencesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreferencesViewController") as? PreferencesViewController
            else { return }
        
        preferencesViewController.delegate = self
        navigationController?.pushViewController(preferencesViewController, animated: true)
    }
    
    //MARK: - show flights
    func showFlights(forAirport: Airport) {
        guard let fligtsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FlightsTableViewController") as? FlightsTableViewController
            else { return }
        
        let flights = fares.filter { $0.destination == forAirport || $0.origin == forAirport }
        fligtsViewController.flights = flights
        fligtsViewController.best = best.filter { $0.destination == forAirport}
        fligtsViewController.airport = forAirport
        
        navigationController?.pushViewController(fligtsViewController, animated: true)
    }
}

//MARK:- PreferencesViewControllerDelegate
extension ViewController: PreferencesViewControllerDelegate {
    func didUpdatePreferences(holiday: Holiday) {
        self.holiday = holiday
        
        didTapSearch(self)
    }
}

//MARK:- UIPreviewInteractionDelegate
extension ViewController: UIViewControllerPreviewingDelegate {
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let preferencesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreferencesViewController") as? PreferencesViewController
            else { return nil }
        return preferencesViewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let preferencesViewController = viewControllerToCommit as? PreferencesViewController else { return }
        preferencesViewController.delegate = self
         navigationController?.pushViewController(preferencesViewController, animated: true)
    }
}

//MARK:- MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation)  { return nil }
        
        guard let priceAnnotation = annotation as?  MapAnnotiation else { return nil }
        
        let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "MainAnnotationView") as? MapAnnotationView ?? Bundle.main.loadNibNamed("MainAnnotationView", owner: self, options: nil)?.last as? MapAnnotationView
        
        pinView?.annotation = priceAnnotation
        pinView?.canShowCallout = true
        pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure);
        
        pinView?.calloutLabel.text = "✈️"
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let tripAnnotation = view.annotation as? MapAnnotiation else { return }
        
        showFlights(forAirport: tripAnnotation.airport)
    }
}
