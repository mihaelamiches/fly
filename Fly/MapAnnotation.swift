
import CoreLocation
import MapKit

class MapAnnotiation: NSObject, NSCoding {
    let coordinate: CLLocationCoordinate2D
    let airport: Airport
    var placemark: CLPlacemark?
    
    init(coordinate: CLLocationCoordinate2D, airport: Airport) {
        self.coordinate = coordinate
        self.airport = airport
    }
    
//    func setPlacemark(completion: @escaping (() -> Void)) {
//        let geo = CLGeocoder()
////        geo.geocodeAddressString("\(airport.name) Airport") { (placemark, error) in
////            guard let placemark = placemark?.first, error == nil else { return completion() }
////            self.placemark = placemark
////            completion()
////        }
//
//        geo.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: { (placemark, error) in
//            guard let placemark = placemark?.first, error == nil else { return completion() }
//            self.placemark = placemark
//            completion()
//        })
//    }
    
    required init?(coder aDecoder: NSCoder) {
        let long = aDecoder.decodeDouble(forKey: "long")
        let lat = aDecoder.decodeDouble(forKey: "lat")
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        guard let airport = aDecoder.decodeObject(forKey: "airport") as? Airport
            else { return nil }
        
        self.coordinate = coordinate
        self.airport = airport
        self.placemark = aDecoder.decodeObject(forKey: "placemark") as? CLPlacemark
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(coordinate.longitude, forKey: "long")
        aCoder.encode(coordinate.latitude, forKey: "lat")
        aCoder.encode(airport, forKey: "airport")
        aCoder.encode(placemark, forKey: "placemark")
    }
}

extension MapAnnotiation {
    convenience init(station: Station) {
        self.init(coordinate: station.location, airport: station.airport)
    }
}


extension MapAnnotiation: MKAnnotation {
    var title: String? {
        return "🛫 \(airport.name)"
    }
}
