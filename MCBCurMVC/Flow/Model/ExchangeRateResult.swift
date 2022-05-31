//
//  ExchangeRateResult.swift
//  MCBCurMVC
//
//  Created by Grigory Stolyarov on 29.05.2022.
//

import Foundation

struct ExchangeRateResult: Decodable {
    
    let code: Int
    let messageTitle: String
    let message: String
    let rid: String
    let downloadDate: String?
    var rates: [ExchangeRate] = []
    let productState: Int?
    let ratesDate: String?
    
    enum MainCodingKeys: String, CodingKey {
        case code
        case messageTitle
        case message
        case rid
        case downloadDate
        case rates
        case productState
        case ratesDate
    }
    
    enum ExchangeRateCodingKeys: String, CodingKey {
        case tp
        case name
        case from
        case currMnemFrom
        case to
        case currMnemTo
        case basic
        case buy
        case sale
        case deltaBuy
        case deltaSale
    }
    
    init(from decoder: Decoder) throws {
     
        let mainContainer = try decoder.container(keyedBy: MainCodingKeys.self)
        code = try mainContainer.decode(Int.self, forKey: .code)
        messageTitle = try mainContainer.decode(String.self, forKey: .messageTitle)
        message = try mainContainer.decode(String.self, forKey: .message)
        rid = try mainContainer.decode(String.self, forKey: .rid)
        
        if code == 0 {
            downloadDate = try mainContainer.decodeIfPresent(String.self, forKey: .downloadDate)
            productState = try mainContainer.decode(Int.self, forKey: .productState)
            ratesDate = try mainContainer.decodeIfPresent(String.self, forKey: .ratesDate)
            
            var ratesArrayContainer = try mainContainer.nestedUnkeyedContainer(forKey: .rates)
            let count = ratesArrayContainer.count ?? 0
            if count > 0 {
                for index in (0...count - 1) {
                    let rateContainer = try ratesArrayContainer.nestedContainer(keyedBy: ExchangeRateCodingKeys.self)
                    rates.append(ExchangeRate())
                    rates[index].tp = try rateContainer.decodeIfPresent(Int.self, forKey: .tp) ?? 0
                    rates[index].name = try rateContainer.decodeIfPresent(String.self, forKey: .name) ?? ""
                    rates[index].from = try rateContainer.decodeIfPresent(Decimal.self, forKey: .from) ?? 0
                    rates[index].currMnemFrom = try rateContainer.decodeIfPresent(String.self, forKey: .currMnemFrom) ?? ""
                    rates[index].to = try rateContainer.decodeIfPresent(Decimal.self, forKey: .to) ?? 0
                    rates[index].currMnemTo = try rateContainer.decodeIfPresent(String.self, forKey: .currMnemTo) ?? ""
                    let basicString = try rateContainer.decodeIfPresent(String.self, forKey: .basic) ?? ""
                    rates[index].basic = Decimal(string: basicString) ?? 1
                    let buyString = try rateContainer.decodeIfPresent(String.self, forKey: .buy) ?? ""
                    rates[index].buy = Decimal(string: buyString) ?? 0
                    let saleString = try rateContainer.decodeIfPresent(String.self, forKey: .sale) ?? ""
                    rates[index].sale = Decimal(string: saleString) ?? 0
                    let deltaBuyString = try rateContainer.decodeIfPresent(String.self, forKey: .deltaBuy) ?? ""
                    rates[index].deltaBuy = Decimal(string: deltaBuyString) ?? 0
                    let deltaSaleString = try rateContainer.decodeIfPresent(String.self, forKey: .deltaSale) ?? ""
                    rates[index].deltaSale = Decimal(string: deltaSaleString) ?? 0
                }
            }
        } else {
            downloadDate = nil
            productState = nil
            ratesDate = nil
        }
    }
}
