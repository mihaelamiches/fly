

import Foundation

extension Resource {
    var endpoint: String? {
        switch self {
        case .stations: return "https://tripstest.ryanair.com/static/stations.json"
        case .cheapestPerDay(let from, let to, let monthOf): return "https://api.ryanair.com/farefinder/3/oneWayFares/\(from)/\(to)/cheapestPerDay?outboundMonthOfDate=\(monthOf.queryString)"
        default: fatalError("nope \(self)")
        }
    }
    
    var requests: [URL] {
        switch self {
        case .cheapest(let tripPreferences): return tripPreferences.searchQueries.flatMap { URL(string: $0) }
        default:
            guard let endpoint = URL(string: self.endpoint ?? "") else { fatalError("invalid resorce \(self)") }
            return [endpoint]
        }
    }
}
