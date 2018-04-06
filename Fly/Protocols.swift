import CoreLocation

typealias Labels = [AnyHashable: Any]

typealias LabelsCallback = ((Labels) -> Void)

typealias Callback = (() -> Void)

typealias Holiday = (on: Departure, duration: TripType, budget: Int)

enum Resource {
    case stations, cheapest(preferences: TripPreferences), cheapestPerDay(from: String, to: String, monthOf: Date)
}

enum ApplicationError {
    case invalidUrlString(_: String)
    case invalidResponse(_: URLResponse?)
    case rogue(_: Error?)
}

enum Departure {
    case monthOf(date: Date), thisWeekend, nextWeekend, nextMonth, nextThreeMonths, soon, anytime
    
    var searchDates: [Date] {
        switch self {
        case .thisWeekend:
            return [Calendar.current.nextWeekend(startingAfter: .now)?.start ?? .now]
        case .nextWeekend:
            return [Calendar.current.nextWeekend(startingAfter: Departure.thisWeekend.searchDates.first ?? .now)?.start ?? .now]
        case .nextMonth:
            return [Calendar.current.date(byAdding: .month, value: 1, to: .now) ?? .now]
        case .nextThreeMonths:
            return (0...2).map { Calendar.current.date(byAdding: .month, value: $0, to: .now) ?? .now }
        case .soon: return Departure.nextWeekend.searchDates + Departure.nextThreeMonths.searchDates
        case .anytime:
            return (0...6).map { Calendar.current.date(byAdding: .month, value: $0, to: .now) ?? .now }
        case .monthOf(let date):
            return [date]
        }
    }
}

enum TripType {
    case hop, short, afew, abreak, aweek, long, exact(Int)
    
    var span: CountableClosedRange<Int> {
        switch self {
        case .hop: return 1...1
        case .short: return 2...2
        case .abreak: return 3...3
        case .afew: return 4...5
        case .aweek: return 6...8
        case .long: return 9...14
        case .exact(let duration):
            return duration...duration
        }
    }
    
    var description: String {
        switch self {
        case .hop: return "in and out"
        case .short: return "short"
        case .abreak: return "a break"
        case .afew: return "a few"
        case .aweek: return "a week"
        case .long: return "a while"
        case .exact(let duration): return "for \(duration) days"
        }
    }
    
    static func from(trip: Trip) -> TripType {
        return TripType.all.filter { $0.span.contains(trip.duration) }.first ?? TripType.exact(trip.duration)
    }
    
    static var all: [TripType] {
        return [hop, short, abreak, afew, aweek, long]
    }
}
