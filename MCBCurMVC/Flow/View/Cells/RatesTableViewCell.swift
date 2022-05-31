//
//  RatesTableViewCell.swift
//  MCBCurMVC
//
//  Created by Grigory Stolyarov on 29.05.2022.
//

import UIKit

class RatesTableViewCell: UITableViewCell {
    
    var exchangeRate: ExchangeRate? {
        didSet {
            guard let nameLabel = nameLabel,
                  let mnemLabel = mnemLabel,
                  let buySaleLabel = buySaleLabel,
                  let exchangeRate = exchangeRate
            else { return }
            
            nameLabel.text = "\(exchangeRate.name) (\(exchangeRate.tp))"
            mnemLabel.text = "\(exchangeRate.basic) \(exchangeRate.currMnemTo) to \(exchangeRate.currMnemFrom)"
            buySaleLabel.text = exchangeRate.tp == 100
                ? "Buy: \(exchangeRate.buy), Sale: \(exchangeRate.sale)"
                : "Buy: \(exchangeRate.basic * exchangeRate.buy), Sale: \(exchangeRate.basic * exchangeRate.sale)"
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mnemLabel: UILabel!
    @IBOutlet weak var buySaleLabel: UILabel!
    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.layer.cornerRadius = 8
            mainView.layer.borderWidth = 0.5
            mainView.layer.borderColor = UIColor.systemGray5.cgColor
        }
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
}
