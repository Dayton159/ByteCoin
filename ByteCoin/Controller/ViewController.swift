//
//  ViewController.swift
//  ByteCoin
//
//  Created by Dayton on 11/12/20.
//

import UIKit

class ViewController: UIViewController{
    
    
   
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
    
   
}
//MARK: - UIPickerViewDataSource

extension ViewController:UIPickerViewDataSource{
    //number of component every one row
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //how many of row the picker should have(currency option)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}
//MARK: - UIPickerViewDelegate

extension ViewController:UIPickerViewDelegate{
    //what should be displayed for each component in a row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    //triggered when a row is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.fetchCurrency(for: selectedCurrency)
        
    }
}
//MARK: - didUpdateCoin
extension ViewController:didUpdateCoin{
    func updateCoinValue(_ coinManager: CoinManager, value: CoinData, currency:String) {
        DispatchQueue.main.async {
            let formattedString = String(format: "%.2f", value.moneyRate)
            
            self.bitcoinLabel.text = formattedString
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
