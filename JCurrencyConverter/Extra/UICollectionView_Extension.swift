//
//  UICollectionView_Extension.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021 /06/28.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import UIKit

extension UICollectionView {
  func register<T: NibLoadableViewProtocol & ReusableViewProtocol>(_ c: T.Type) {
    register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
  }
  func dequeue<T: NibLoadableViewProtocol & ReusableViewProtocol>(_ T:T.Type, for indexPath: IndexPath) -> T? {
    return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
  }
}

extension UICollectionViewCell: NibLoadableViewProtocol {}
extension UICollectionViewCell: ReusableViewProtocol {}
