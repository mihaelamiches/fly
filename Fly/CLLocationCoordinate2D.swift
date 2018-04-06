import CoreLocation

extension CLLocationCoordinate2D {
    var description: String {
        return "((\(latitude),\(longitude)))"
    }
}
