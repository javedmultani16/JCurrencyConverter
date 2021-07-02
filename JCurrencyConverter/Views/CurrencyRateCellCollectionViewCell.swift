//
//  CurrencyRateCellCollectionViewCell.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021 /06/28.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import UIKit

class CurrencyRateCellCollectionViewCell: UICollectionViewCell {
  @IBOutlet private weak var nameLabel:UILabel!
  @IBOutlet private weak var rateLabel:UILabel!
  @IBOutlet private weak var container:UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    container.configure{
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 0
      $0.layer.borderColor = UIColor.black.cgColor
      $0.layer.borderWidth = 1
    }
  }
  
  func populate(_ data: (name: String, rate: String)){
    nameLabel.text = "\("Name:".localized) \(data.name)"
    rateLabel.text = "\("Rate:".localized) \(data.rate)"
  }
  
}

