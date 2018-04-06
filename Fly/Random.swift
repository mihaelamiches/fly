//
//  Random.swift
//  Fly
//
//  Created by Miha on 9/17/17.
//  Copyright © 2017 me. All rights reserved.
//

import Foundation

func golden(_ n: Int) -> Double {
    guard n > 1 else { return 1 }
    return 1 + 1/golden(n - 1)
}

func spoof(_ n: Double) -> (long: Double, short: Double) {
    let a = n/phi
    let b = pow(a, 2.0)/n
    return (a,b)
}

let x = 42
let phi = golden(x)
