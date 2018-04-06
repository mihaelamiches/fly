//
//  Double.swift
//  Fly
//
//  Created by Miha on 9/2/17.
//  Copyright © 2017 me. All rights reserved.
//

import Foundation

extension Double {
    func round(_ n: Int = 2) ->  Double {
        let p = pow(10.0, Double(n))
        return Double((p*self)/p)
    }
}
