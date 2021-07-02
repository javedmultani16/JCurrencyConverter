//
//  NibLoadableViewProtocol.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021/06/19.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import UIKit

protocol NibLoadableViewProtocol {
  static var nib:UINib { get }
}

extension NibLoadableViewProtocol where Self: UIView {
  static var nib: UINib {
    let className = String(describing: self)
    return UINib(nibName: className, bundle: Bundle(for: self))
  }
  
  static func view() -> Self? {
    return nib.instantiate(withOwner: self, options: nil).first as? Self
  }
}
