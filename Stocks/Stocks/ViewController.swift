//
//  ViewController.swift
//  Stocks
//
//  Created by Владимир Моторкин on 13.12.2020.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    
    // Добавлять все акции не стал, так как нужно менять весь интерфейс, чтобы было удобно их изучать.
    private let companies: [String: String] = ["Apple": "AAPL",
                                              "Microsoft": "MSFT",
                                              "Google": "GOOG",
                                              "Amazon": "AMZN",
                                              "Facebook": "FB"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }
    
    private func requestQuote(for symbol: String) {
        let urlData = URL(string: "https://cloud.iexapis.com/v1/stock/\(symbol)/quote?token=pk_8897992d812a4014b3211d1340a48fa2")!
        
        let urlLogo = URL(string: "https://cloud.iexapis.com/v1/stock/\(symbol)/logo?token=pk_8897992d812a4014b3211d1340a48fa2")!
        
        let dataTask = URLSession.shared.dataTask(with: urlData) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                print("Network error!")
                return
            }
            
            self.parseQuote(data: data)
        }
        
        let urlTask = URLSession.shared.dataTask(with: urlLogo) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                print("Network error!")
                return
            }
            
            self.parseLogo(data: data)
        }
        
        dataTask.resume()
        urlTask.resume()
    }
    
    private func parseLogo(data: Data){
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyLogoUrl = json["url"] as? String
            else {
                print("Invalid JSON format!")
                return
            }
            DispatchQueue.main.async {
                self.setImage(from: companyLogoUrl)
            }
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func parseQuote(data: Data){
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double
            else {
                print("Invalid JSON format!")
                return
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName,
                                      symbol: companySymbol,
                                      price: price,
                                      priceChange: priceChange)
            }
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.companyLogo.image = image
                self.companyLogo.isHidden = false
            }
        }
    }
    
    private func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double) {
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
        self.companySymbolLabel.text = symbol
        self.priceLabel.text = "\(price)"
        self.priceChangeLabel.text = "\(priceChange)"
        if priceChange > 0 {
            self.priceChangeLabel.textColor = UIColor.green
        } else if priceChange < 0 {
            self.priceChangeLabel.textColor = UIColor.red
        }
            
        
            
    }

    private func requestQuoteUpdate() {
        self.companyLogo.isHidden = true
        self.activityIndicator.startAnimating()
        self.companyNameLabel.text = "-"
        self.companySymbolLabel.text = "-"
        self.priceLabel.text = "-"
        self.priceChangeLabel.text = "-"
        self.priceChangeLabel.textColor = UIColor.black
        
        let selectedRow = self.companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(self.companies.values)[selectedRow]
        self.requestQuote(for: selectedSymbol)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.requestQuoteUpdate()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.companyPickerView.dataSource = self
        self.companyPickerView.delegate = self
        
        self.activityIndicator.hidesWhenStopped = true
        
        self.requestQuoteUpdate()
    }


}

