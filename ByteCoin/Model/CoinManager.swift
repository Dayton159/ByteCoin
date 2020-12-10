//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Dayton on 11/12/20.
//

import Foundation

protocol didUpdateCoin {
    func updateCoinValue(_ coinManager:CoinManager, value: CoinData, currency:String)
    func didFailWithError(error:Error)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "4513276C-8B9B-4F52-A0F1-6261D22C8265"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    var delegate:didUpdateCoin?
    
    
    func fetchCurrency(for currency:String){
        let apiURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //if there is a real url inputted
        if let url = URL(string: apiURL){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let currencyInfo = self.parseJSON(safeData){
                        self.delegate?.updateCoinValue(self, value: currencyInfo, currency: currency)
                    }
                }
            })
            
            task.resume()
        }
    }
    
    func parseJSON(_ currencyData:Data)->CoinData?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(CurrencyData.self, from: currencyData)
            
            let rate = decodedData.rate
            
            let coinData = CoinData(moneyRate: rate)
            
            return coinData
            
        }catch{
            return nil
            
        }
    }
}

