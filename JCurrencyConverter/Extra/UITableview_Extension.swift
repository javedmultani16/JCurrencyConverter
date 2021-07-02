//
//  UITableview_Extension.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021/06/19.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  
  func register<T: NibLoadableViewProtocol & ReusableViewProtocol>(_ : T.Type) {
    register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
  func dequeue<T: ReusableViewProtocol>(_ : T.Type) -> T? {
    return dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T
  }
  
}

extension UITableViewCell : NibLoadableViewProtocol {}
extension UITableViewCell : ReusableViewProtocol {}
