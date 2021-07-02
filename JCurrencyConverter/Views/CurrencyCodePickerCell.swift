//
//  CurrencyCodePickerCell.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021/06/19.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import UIKit

class CurrencyCodePickerCell: UITableViewCell {
  
  @IBOutlet private weak var currencyCodeNameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func populate(_ data: String){
    currencyCodeNameLabel.text = data
  }
}

