
import Foundation

extension Array {
    func shuffled() -> Array {
        return sorted { _,_ in arc4random() < arc4random() }
    }
}

extension Array where Element == Cheapest {
    func byPrice() -> [Cheapest] {
        return sorted { $0.fares.first?.price.value ?? 0 < $1.fares.first?.price.value ?? 0 }
    }
    
    func byDate() -> [Cheapest] {
        return sorted { $0.fares.first?.day.compare($1.fares.first?.day ?? .distantPast) == .orderedAscending }
    }
}

extension Array where Element == Fare {
    func byPrice() -> [Fare] {
        return sorted { $0.price.value < $1.price.value }
    }
    
    func byDate() -> [Fare] {
        return sorted { $0.day.compare($1.day) == .orderedAscending }
    }
}

extension Sequence where Iterator.Element: Hashable {
    //https://stackoverflow.com/questions/27624331/unique-values-of-array-in-swift
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
