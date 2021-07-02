//
//  RequestHandler.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021 /06/28.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import Foundation

typealias ErrorModel = Decodable

class RequestHandler {
  private lazy var decoder = JSONDecoder()
  private var urlSession:URLSession
  
  init(config: URLSessionConfiguration) {
    urlSession = URLSession(configuration: config)
  }
  
  convenience init() {
    self.init(config: URLSessionConfiguration.default)
  }
  
  func fetch<ItemModel: Decodable, Int>(_ request: URLRequest,
                                        completion: @escaping ((ResultFetch<ItemModel, Int>) -> Void)) {
    let task = urlSession.dataTask(with: request, completionHandler: {
      [weak self] (data, response, error) in
      guard let _self  = self else { return }
      if let httpResponse = response as? HTTPURLResponse {
        let statusCode = httpResponse.statusCode
        do {
          let _data = data ?? Data()
          if (200...399).contains(statusCode) {
            let objs = try _self.decoder.decode(ItemModel.self, from: _data)
            completion(ResultFetch.successful(objs))
          }else {
            completion(ResultFetch.failure(statusCode))
          }
        } catch {
          completion(ResultFetch.failure(1))
        }
      }
    })
    task.resume()
  }
}

enum ResultFetch<ValueObject, ErrorCode> {
  case none
  case successful(ValueObject)
  case failure(Int)
  
  var value: ValueObject? {
    switch self {
    case .successful(let obj):
      return obj
    default:
      return nil
    }
  }
  
  var error: ErrorCode? {
    switch self {
    case .failure(let errorCode):
      return errorCode as? ErrorCode
    default:
      return nil
    }
  }
}
