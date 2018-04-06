
import Foundation

struct Fare {
    let day: Date
    let price: Price
    let soldOut: Bool
    let unavailable: Bool

    init?(labelled: Labels) {
        let day = Date(short: (labelled["day"] as? String ?? ""))
        
        guard let soldOut = labelled["soldOut"] as? Bool,
            let unavailable = labelled["unavailable"] as? Bool,
            let price = Price(labelled: labelled["price"] as? Labels ?? [:]) else { return nil }
        
        self.day = day
        self.soldOut = soldOut
        self.unavailable = unavailable
        self.price = price
    }
    
}
