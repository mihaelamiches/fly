//
//  Price.swift
//  Fly
//
//  Created by Mihaela Miches on 6/11/17.
//  Copyright © 2017 me. All rights reserved.
//

import Foundation

struct Price {
    let currencyCode: String
    let currencySymbol: String
    let value: Double
    let valueFractionalUnit: String
    let valueMainUnit: String
    
    init?(labelled: Labels) {
        guard let currencyCode = labelled["currencyCode"] as? String,
            let currencySymbol = labelled["currencySymbol"] as? String,
            let value = labelled["value"] as? Double,
            let valueFractionalUnit = labelled["valueFractionalUnit"] as? String,
            let valueMainUnit = labelled["valueMainUnit"] as? String else { return nil }
        
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
        self.value = value
        self.valueFractionalUnit = valueFractionalUnit
        self.valueMainUnit = valueMainUnit
    }
    
    var description: String {
        return "\(valueMainUnit).\(valueFractionalUnit)\(currencySymbol)"
    }
}
