
import CoreLocation

struct Station {
    let airport: Airport
    let country: Country
    let markets: [String]
    let mobileBoardingPass: Bool
    let notices: String?
    let location: CLLocationCoordinate2D
    
    init?(_ labelled: Labels) {
        guard let code = labelled["code"] as? String,
            let name = labelled["name"] as? String,
            let country = Country(labelled),
            let mobileBoardingPass = labelled["mobileBoardingPass"] as? Bool,
            let latitude = labelled["latitude"] as? String,
            let longitude = labelled["longitude"] as? String,
            let markets = labelled["markets"] as? [Labels]
            else { return nil }

        self.airport = Airport(code: code, name: name)
        self.country = country
        self.mobileBoardingPass = mobileBoardingPass
        self.markets = markets.flatMap { $0["code"] as? String }
        self.notices = labelled["notices"] as? String

        self.location = CLLocationCoordinate2D(latitude: latitude.degrees, longitude: longitude.degrees)
    }
}


extension Station: Hashable, Equatable {
    static func ==(lhs: Station, rhs: Station) -> Bool {
        return lhs.airport == rhs.airport
    }
    
    var hashValue: Int {
        return airport.hashValue
    }
}


