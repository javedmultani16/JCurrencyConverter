//
//  ViewController.swift
//  ExchangeRates
//
//  Created by Javed Multani on 2021/06/19.
//  Copyright © 2021  javedmultani16. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var currencyTitleLabel: UILabel!
    @IBOutlet private weak var topSourceCurrencyDescriptionContainer:UIView!
    @IBOutlet private weak var topSourceCurrencyCode:UILabel!
    @IBOutlet private weak var topSourceCurrencyStaticLabel:UILabel!
    @IBOutlet private weak var topSourceCurrencyPickerContainer:UIView!
    @IBOutlet private weak var currencyRateCollectionView:UICollectionView!
    @IBOutlet weak var currenctListTableView: UITableView!
    
    private var viewModel:HomeViewModel!
    var selectedValue:Double = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldAmount.text = "1"
        viewModel = HomeViewModel(clientApi: APIManager.shared)
        viewModel.delegate = self
        
        if let root = APIManager.shared.config{
            if let refreshRate = root.value(forKey: "refresh_rate") as? String {
                Timer.scheduledTimer(
                    timeInterval: Double(refreshRate)!,
                    target: self,
                    selector: #selector(timerRefresh), userInfo: nil, repeats: true)
            }
        }
        
       
        currencyRateCollectionView.configure {
            $0.delegate = self
            $0.dataSource = self
            $0.showsVerticalScrollIndicator = false
            $0.register(CurrencyRateCellCollectionViewCell.self)
        }
        currenctListTableView.configure {
            $0.delegate = self
            $0.dataSource = self
            $0.isHidden = true
            $0.register(CurrencyCodePickerCell.self)
            $0.clipsToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black.cgColor
        }
        topSourceCurrencyStaticLabel.configure{
            $0.text = "\u{25BC}"
        }
        topSourceCurrencyPickerContainer.configure{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black.cgColor
        }
        topSourceCurrencyDescriptionContainer.configure{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBAction func tapToPickSourceCurrencyCode(_ v:UITapGestureRecognizer) {
        currenctListTableView.isHidden = !currenctListTableView.isHidden
    }
    
    @objc private func timerRefresh(){
        _ = APIManager.shared.refresh()
    }
    
    @IBAction func ConverButtonHandler(_ sender: Any) {
        self.currencyRateCollectionView.reloadData()
        self.view.endEditing(true)
    }
    
}

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currencyRateItems[section].items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.currencyRateItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell  = collectionView.dequeue(CurrencyRateCellCollectionViewCell.self, for: indexPath)
        
        let amount = Double(self.textFieldAmount.text!)!/selectedValue
        let value  = amount * (viewModel.currencyRateItems[indexPath.section].items[indexPath.row].rate ?? 0)
        
        
        _cell?.populate((name: viewModel.currencyRateItems[indexPath.section].items[indexPath.row].code, rate:"\(value.rounded(toPlaces: 3) )"))
        
        return _cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width / 4, height: 60)
    }
}

extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencyCodeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell: CurrencyCodePickerCell = tableView.dequeue(CurrencyCodePickerCell.self)!
        _cell.populate(viewModel.currencyCodeItems[indexPath.row].code)
        return _cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currenctListTableView.isHidden = true
        topSourceCurrencyCode.text = viewModel.currencyCodeItems[indexPath.row].code
        self.selectedValue = (viewModel.currencyCodeItems[indexPath.row].rate ?? 0)
        self.currencyTitleLabel.text = viewModel.currencyCodeItems[indexPath.row].description
        self.currencyRateCollectionView.reloadData()
        
    }
    
    
}

extension HomeViewController:HomeViewModelDelegate {
    func fetchStatus(_ v: HomeViewModel.FetchStatus) {
        currenctListTableView.reloadData()
        currencyRateCollectionView.reloadData()
    }
}

