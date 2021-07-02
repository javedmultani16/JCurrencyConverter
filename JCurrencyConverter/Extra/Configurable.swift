//
//  Configurable.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021/06/19.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

protocol Configurable {}

extension Configurable {
  @discardableResult func configure ( block : (inout Self) -> Void ) -> Self {
    var m = self
    block(&m)
    return m
  }
}
