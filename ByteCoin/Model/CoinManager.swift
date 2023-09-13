//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
protocol  CoinManagerDelegate {
    func didUpadtePrice(price : String ,currency : String)
    func didFailWithError(error : Error)
}
struct CoinManager {
    var delegate :CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/?apikey=D176BB92-7FE9-4C61-A805-832F8D9683AF"
    let apiKey = "YOUR_API_KEY_HERE"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    func getCoinPrice(for currency : String) {
        let urlString = "https://rest.coinapi.io/v1/exchangerate/BTC/\(currency)?apikey=D176BB92-7FE9-4C61-A805-832F8D9683AF"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("Eror :\(error!)")
                    return
                }
                if let safeData = data {
                    let bicoinPrice = self.parseJSON(safeData)
                    let priceString = String(format: "%.1f", bicoinPrice)
                    self.delegate?.didUpadtePrice(price: priceString, currency: currency)
                }
            }
            task.resume()
        }
    
    }
    func parseJSON (_ data : Data) -> Double {
        let decoder = JSONDecoder()
        do {
           let decodedData =  try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            print(rate)
            return rate
        }
        catch {
            print(error)
            return 0.0
        }
    }
    
}
