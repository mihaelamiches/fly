
import Foundation

struct TripPreferences {
    let holiday: Holiday
    let origin: Airport
    let destinations: [Airport]
    let returning = true
    let flexi = false
    
    var searchQueries: [String] {
        let departingFlights = destinations.map { (origin, $0) }
        let returningFlights = destinations.map { ($0, origin) }
        var queries = departingFlights.flatMap { flight in
            return holiday.on.searchDates.flatMap { Resource.cheapestPerDay(from: flight.0.code, to: flight.1.code, monthOf: $0).endpoint}
        }

        if returning {
            queries += returningFlights.flatMap { flight in
                return returnDates.flatMap { Resource.cheapestPerDay(from: flight.0.code, to: flight.1.code, monthOf: $0).endpoint}
            }
        }
        
        return queries
    }
    
    var returnDates: [Date] {
        guard returning else { return [] }
        return holiday.on.searchDates.flatMap { Calendar.current.date(byAdding: .day, value: holiday.duration.span.upperBound, to: $0) }
    }
}
