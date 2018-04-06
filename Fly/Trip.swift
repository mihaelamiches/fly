//
//  Trip.swift
//  Fly
//
//  Created by Miha on 9/23/17.
//  Copyright © 2017 me. All rights reserved.
//

import Foundation

struct Trip {
    let origin: Airport
    let destination: Airport
    
    let outbound: Fare
    let inbound: Fare
    
    var kind: TripType {
        return TripType.from(trip: self)
    }
    
    var totalPrice: Double {
        return sameCurrency ? (inbound.price.value + outbound.price.value) : (outbound.price.value * 2)
    }
    
    var sameCurrency: Bool {
        return outbound.price.currencyCode.lowercased()  == inbound.price.currencyCode.lowercased()
    }
    
    var priceTag: String {
        return "\(sameCurrency ? "\(totalPrice)" + " " + outbound.price.currencyCode  : "\(outbound.price.description) + \(inbound.price.description)")"
    }
    
    var duration: Int {
        return Calendar.current.dateComponents([.day], from: outbound.day, to: inbound.day).day ?? 0
    }
    
    var catchPhrase: String {
        return "\(!sameCurrency ? "🎩" : "\(priceTag)") \(kind.description) in \(destination.name) * \(description) *"
    }
    
    var description: String {
        return "\(outbound.day.shortString)[\(outbound.price.description)] - \(inbound.day.shortString)[\(inbound.price.description)]"
    }
}

extension Trip {
    func points(_ budget: Int? = nil) -> Int {
        let departureScorebyDay = [3,2,2,2,3,4,5]
        let arrivalDailyScore = [5,3,3,2,2,3,4]
        let fav = max(departureScorebyDay.max() ?? Int.min, arrivalDailyScore.max() ?? Int.min)
        
        var pts = departureScorebyDay[outbound.day.weekDay-1] + arrivalDailyScore[inbound.day.weekDay-1]
        if pts == fav * 2  {
            pts += fav
            if duration <= 2 { pts += fav/2 }
        }
    
        if duration <= TripType.abreak.span.upperBound { pts += fav/2 }
        if duration > TripType.aweek.span.upperBound { pts -= fav/2 }
        if duration >  TripType.long.span.upperBound { pts -= fav/2 }
        
        if let budget = budget {
            let priceDev = (Double(budget) - totalPrice)/10
            pts += Int(priceDev)
        }
        
        return pts
    }
    
}
