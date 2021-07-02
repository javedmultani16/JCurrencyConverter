//
//  HomeViewModel.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021/06/19.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CurrencyItemCode {
  var code: String
  var description: String
  var rate: Double?
}

struct CurrencyItemRate {
  var items:[CurrencyItemCode]
}

protocol HomeViewModelDelegate:class {
  func fetchStatus(_ v: HomeViewModel.FetchStatus)
}

class HomeViewModel {
  
  enum FetchStatus {
    case onProgressListFetch
    case onProgressRateFetch
    case completed
    case readyToShowCodeList(_ source:String, description:String)
    case readyToShowRateList
    case error(statusCode: Int)
    case errorConfig
  }
  
  private(set) var currencyCodeItems:[CurrencyItemCode] = []{
    didSet{
      delegate?.fetchStatus(.readyToShowCodeList(source, description: description))
    }
  }
  private(set) var currencyRateItems:[CurrencyItemRate] = []{
    didSet{
      delegate?.fetchStatus(.readyToShowRateList)
    }
  }
  weak var delegate:HomeViewModelDelegate?
  private var loadingCombos:Int = 0 {
    didSet{
      guard loadingCombos == 0 else { return }
      DispatchQueue.main.async {
        [weak self] in
        guard let _self = self else { return }
        _self.delegate?.fetchStatus(.completed)
      }
    }
  }
  private var source:String = ""
  private var description:String = ""
  
  init(clientApi: APIManager) {
    loadingCombos = 2
    delegate?.fetchStatus(.onProgressListFetch)
    delegate?.fetchStatus(.onProgressRateFetch)
    source = clientApi.apiParam.value(forKey: "source") as? String ?? ""
    contextDidSave(Notification(name: Notification.Name.NSManagedObjectContextDidSave))
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(contextDidSave(_:)),
                                           name: Notification.Name.NSManagedObjectContextDidSave,
                                           object: nil)
    
    clientApi.getListApi(completion: {
      [weak self] result in
      guard let _self = self else { return }
      _self.loadingCombos -= 1
      switch result {
      case .failure(let statusCode):
        _self.delegate?.fetchStatus(.error(statusCode: statusCode))
      case .successful, .none:
        break
      }
    })
    
    if let _sourceRate = clientApi.apiParam.value(forKey: "source") as? String {
      clientApi.getRateApi(selectedCurrencyCode: _sourceRate,
                           completion: {
                            [weak self] result in
                            guard let _self = self else { return }
                            _self.loadingCombos -= 1
                            switch result {
                            case .failure(let statusCode):
                              _self.delegate?.fetchStatus(.error(statusCode: statusCode))
                            case .successful, .none:
                              break
                            }
      })
    }else{
      delegate?.fetchStatus(.errorConfig)
    }
    
    
  }
  
  func refresh(clientApi: APIManager, selectedSource: String){
    if let _apiParam = clientApi.apiParam {
      let data:NSMutableDictionary = NSMutableDictionary(dictionary: _apiParam)
      data.setValue(selectedSource, forKey: "source")
      do {
        try data.write(to: clientApi.documentAPIParamsDirectory())
      }catch {
        print("error write \(error)")
      }
      _ = clientApi.refresh()
    }
    if let _sourceRate = clientApi.apiParam.value(forKey: "source") as? String {
      loadingCombos = 1
      source = _sourceRate
      delegate?.fetchStatus(.onProgressRateFetch)
      clientApi.getRateApi(selectedCurrencyCode: _sourceRate,
                           completion: {
                            [weak self] result in
                            guard let _self = self else { return }
                            _self.loadingCombos -= 1
                            switch result {
                            case .failure(let statusCode):
                              _self.delegate?.fetchStatus(.error(statusCode: statusCode))
                            case .successful(_), .none:
                              break
                            }
      })
    }else{
      delegate?.fetchStatus(.errorConfig)
    }
  }
  
  @objc func contextDidSave(_ notification:Notification) {
    DispatchQueue.main.async {
      [weak self] in
      guard let _self = self else { return }
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Currency.entity().name!)
      let fetchSourceRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Currency.entity().name!)
      fetchSourceRequest.predicate = NSPredicate(format: "currency_id = %@", _self.source)
      do {
        let getUpdatedCore = try context.fetch(fetchRequest) as! [Currency]
        if let getSourceCore = try context.fetch(fetchSourceRequest) as? [Currency] {
          if getSourceCore.count > 0 {
            _self.description = "\(getSourceCore[0].currency_description ?? "") \n\(String(describing: getSourceCore[0].currency_timestamp ?? ""))"
          }
        }
        _self.currencyCodeItems = []
        _self.currencyRateItems = []
        var tempCodeItems: [CurrencyItemCode] = []
        for item in getUpdatedCore {
          let item = CurrencyItemCode(code: item.currency_id!,
                                      description: item.currency_description ?? "",
                                      rate: item.currency_rate)
          tempCodeItems.append(item)
        }
        _self.currencyCodeItems = tempCodeItems
        let currencyRateItems = _self.currencyCodeItems.reduce([]) { (result, current) -> [CurrencyItemRate] in
          var _result = result
          if let _last = _result.last {
            if _last.items.count == 0 || _last.items.count == 3  {
              let itemRate = CurrencyItemRate(items: [current])
              _result.append(itemRate)
            }else if _last.items.count < 3 {
              var items = _last.items
              items.append(current)
              let itemRate = CurrencyItemRate(items: items)
              _result[_result.count - 1] = itemRate
            }
          }else {
            let itemRate = CurrencyItemRate(items: [current])
            _result.append(itemRate)
          }
          return _result
        }
        _self.currencyRateItems = currencyRateItems
        print("code \(String(describing: _self.currencyCodeItems.count))")
        print("rate \(String(describing: _self.currencyRateItems.count))")
      }catch{
        
      }
    }
    
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
  }
}


