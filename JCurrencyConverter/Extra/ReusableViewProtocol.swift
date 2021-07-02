//
//  ReusableViewProtocol.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021/06/19.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import UIKit
import Foundation
protocol ReusableViewProtocol {
  static var reuseIdentifier:String { get }
}

extension ReusableViewProtocol {
  static var reuseIdentifier:String {
    let className = String(describing: self)
    return "\(className)"
  }
}
extension String  {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
