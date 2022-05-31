//
//  ExchangeRate.swift
//  MCBCurMVC
//
//  Created by Grigory Stolyarov on 29.05.2022.
//

import Foundation

struct ExchangeRate {
    
    var tp: Int = 0
    var name: String = ""
    var from: Decimal = 0
    var currMnemFrom: String = ""
    var to: Decimal = 0
    var currMnemTo: String = ""
    var basic: Decimal = 0
    var buy: Decimal = 0
    var sale: Decimal = 0
    var deltaBuy: Decimal = 0
    var deltaSale: Decimal = 0
}
