//
//  RequestModel.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021/06/19.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import Foundation

struct RequestModel {
  enum HttpMethod:String {
    case get = "GET"
    case post = "POST"
  }
  
  var baseUrl: String
  var httpMethod:HttpMethod
  var path:String
  var query:[String:Any]?
  var payload:[String:Any?]?
  var headers:[String:String]?
  
  init(baseUrl:String,
       httpMethod:HttpMethod,
       path:String,
       query:[String:Any]? = nil,
       payload:[String:Any?]? = nil,
       headers:[String:String]? = nil) {
    self.baseUrl = baseUrl
    self.httpMethod = httpMethod
    self.path = path
    self.query = query
    self.payload = payload
    self.headers = headers
  }
  
}

extension RequestModel {
  
  func asURLRequest() -> URLRequest {
    let url = "\(baseUrl)/\(path)"
    var components = URLComponents(string: url)
    
    if let items = query {
      let _items:[URLQueryItem] = items.reduce([], {
        (result, current) -> [URLQueryItem] in
        var _result = result
        _result.append(URLQueryItem(name: current.key, value: "\(current.value)"))
        return _result
      })
      components?.queryItems = _items
    }
    
    var request = URLRequest(url: (components?.url!)!)
    request.httpMethod = httpMethod.rawValue
    
    if payload != nil,
      let payloadData = try? JSONSerialization.data(withJSONObject: payload!, options: []) {
      request.httpBody = payloadData
    }
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    headers?.enumerated().forEach{
      request.addValue($0.element.value,
                       forHTTPHeaderField: $0.element.key)
    }
    return request
  }
}
