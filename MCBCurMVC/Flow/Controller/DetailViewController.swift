//
//  DetailViewController.swift
//  MCBCurMVC
//
//  Created by Grigory Stolyarov on 29.05.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var exchangeRate = ExchangeRate()
    
    // MARK: - Outlets
    
    @IBOutlet var rateLabels: [UILabel]!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        showRate()
    }
    
    // MARK: - Program Logic
    
    private func showRate() {
        
        title = exchangeRate.name
        rateLabels.forEach {
            switch $0.tag {
            case 0: $0.text = "tp: \(exchangeRate.tp)"
            case 1: $0.text = "name: \(exchangeRate.name)"
            case 2: $0.text = "from: \(exchangeRate.from)"
            case 3: $0.text = "currMnemFrom: \(exchangeRate.currMnemFrom)"
            case 4: $0.text = "to: \(exchangeRate.to)"
            case 5: $0.text = "currMnemTo: \(exchangeRate.currMnemTo)"
            case 6: $0.text = "basic: \(exchangeRate.basic)"
            case 7: $0.text = "buy: \(exchangeRate.buy)"
            case 8: $0.text = "sale: \(exchangeRate.sale)"
            case 9: $0.text = "deltaBuy: \(exchangeRate.deltaBuy)"
            case 10: $0.text = "deltaSale: \(exchangeRate.deltaSale)"
            default:
                $0.text = ""
            }
        }
    }
}
