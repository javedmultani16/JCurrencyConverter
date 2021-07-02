//
//  CurrencyResponseModel.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021/06/19.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import Foundation

struct CurrencyResponseModel:Codable {
  var successFlag: Bool
  var termsLink: String
  var privacyLink: String
  var lastDate:  Double?
  var currentDateHistory: String?
  var historicalFlag: Bool?
  var sourceCurrency: String?
  var currencyQuotes: [String : Double]?
  var currencyCodeList: [String : String]?
  
  enum CodingKeys: String, CodingKey {
    case successFlag = "success"
    case termsLink = "terms"
    case privacyLink = "privacy"
    case lastDate = "timestamp"
    case currentDateHistory = "date"
    case historicalFlag = "historical"
    case sourceCurrency = "source"
    case currencyQuotes = "quotes"
    case currencyCodeList = "currencies"
  }
}

extension CurrencyResponseModel {
  var getQuotesForCoreData:[String : Double] {
    return currencyQuotes == nil ? [:] : currencyQuotes!.reduce([:], { (result, current) -> [String : Double] in
      var _result = result
      let indexStartOfText = current.key.index(current.key.startIndex, offsetBy: 3)
      let keyString:String = String(current.key[indexStartOfText...])
      _result[keyString] = current.value
      return _result
    })
  }
  var getCurrencyTimeStampForUI:String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    let date = Date.init(timeIntervalSince1970: lastDate ?? 0)
    return "\(dateFormatter.string(from: date))"
  }
}
