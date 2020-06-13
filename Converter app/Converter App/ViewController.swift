//
//  ViewController.swift
//  Converter App
//
//  Created by Рафаэль Сайфутдинов on 07.06.2020.
//  Copyright © 2020 Рафаэль Сайфутдинов. All rights reserved.
//

import UIKit

struct parsStruct: Decodable {
    var rates: [String: Double]
}

class ViewController: UIViewController {
    
    @IBOutlet weak var label_1: UILabel!
    @IBOutlet weak var label_2: UILabel!
    @IBOutlet weak var label_3: UILabel!
    @IBOutlet weak var label_4: UILabel!
    @IBOutlet weak var segment_1: UISegmentedControl!
    @IBOutlet weak var segment_2: UISegmentedControl!
    
    var numberField_1: Double = 0
    var numberField_2: Double = 0
    var selectedSegment_1: Int = 0
    var selectedSegment_2: Int = 1
    var ifisDot: Bool = false
    var multiplier: Double = 0
    var exchangeRates: [String: Double] = [:]
    var currencyValues: String = ""
    var additional = ""
    var courses: [String: Double] = ["RUBUSD": 0.014,
                                     "RUBEUR": 0.013,
                                     "RUBGBP": 0.011,
                                     "USDRUB": 69.78,
                                     "USDEUR": 0.88,
                                     "USDGBP": 0.79,
                                     "EURRUB": 78.86,
                                     "EURUSD": 1.13,
                                     "EURGBP": 0.9,
                                     "GBPRUB": 87.96,
                                     "GBPUSD": 1.26,
                                     "GBPEUR": 1.12
    ]
    
    func getRates(){ //Получить значения курсов валют с exchangeratesapi
        guard var url = URL( string: "https://api.exchangeratesapi.io/latest?base=RUB") else { return } //Для рубля
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            do {
                let values = try JSONDecoder().decode(parsStruct.self, from: data)
                self.exchangeRates = values.rates
                self.courses["RUBUSD"] = Double(round(10000*self.exchangeRates["USD"]!)/10000)
                self.courses["RUBEUR"] = Double(round(10000*self.exchangeRates["EUR"]!)/10000)
                self.courses["RUBGBP"] = Double(round(10000*self.exchangeRates["GBP"]!)/10000)
            } catch let error {
                print(error)
            }
        }.resume()
        
        url = URL( string: "https://api.exchangeratesapi.io/latest?base=USD")! // Для доллара
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            do {
                let values = try JSONDecoder().decode(parsStruct.self, from: data)
                self.exchangeRates = values.rates
                self.courses["USDRUB"] = Double(round(10000*self.exchangeRates["RUB"]!)/10000)
                self.courses["USDEUR"] = Double(round(10000*self.exchangeRates["EUR"]!)/10000)
                self.courses["USDGBP"] = Double(round(10000*self.exchangeRates["GBP"]!)/10000)
            } catch let error {
                print(error)
            }
        }.resume()
        
        url = URL( string: "https://api.exchangeratesapi.io/latest?base=EUR")! // Для евро
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            do {
                let values = try JSONDecoder().decode(parsStruct.self, from: data)
                self.exchangeRates = values.rates
                self.courses["EURRUB"] = Double(round(10000*self.exchangeRates["RUB"]!)/10000)
                self.courses["EURUSD"] = Double(round(10000*self.exchangeRates["USD"]!)/10000)
                self.courses["EURGBP"] = Double(round(10000*self.exchangeRates["GBP"]!)/10000)
            } catch let error {
                print(error)
            }
        }.resume()
        
        url = URL( string: "https://api.exchangeratesapi.io/latest?base=GBP")! // Для фунтов
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            do {
                let values = try JSONDecoder().decode(parsStruct.self, from: data)
                self.exchangeRates = values.rates
                self.courses["GBPRUB"] = Double(round(10000*self.exchangeRates["RUB"]!)/10000)
                self.courses["GBPUSD"] = Double(round(10000*self.exchangeRates["USD"]!)/10000)
                self.courses["GBPEUR"] = Double(round(10000*self.exchangeRates["EUR"]!)/10000)
            } catch let error {
                print(error)
            }
        }.resume()
        multiplier = courses["RUBUSD"]!
    }
    
    func convertation() { // Перевод из одной валюты в другую
        currencyValues = ""
        switch selectedSegment_1 {
        case 0:
            currencyValues += "RUB"
            label_3.text = "RUB"
        case 1:
            currencyValues += "USD"
            label_3.text = "USD"
        case 2:
            currencyValues += "EUR"
            label_3.text = "EUR"
        case 3:
            currencyValues += "GBP"
            label_3.text = "GBP"
        default:
            currencyValues = ""
        }
        switch selectedSegment_2 {
        case 0:
            currencyValues += "RUB"
            additional = "RUB"
        case 1:
            currencyValues += "USD"
            additional = "USD"
        case 2:
            currencyValues += "EUR"
            additional = "EUR"
        case 3:
            currencyValues += "GBP"
            additional = "GBP"
        default:
            currencyValues = ""
        }
        if currencyValues != "USDUSD" && currencyValues != "RUBRUB" && currencyValues != "EUREUR" && currencyValues != "GBPGBP" {
            multiplier = courses[currencyValues]!
        }
        numberField_2 = Double(round(1000000 * numberField_1 * multiplier)/1000000)
        label_2.text = String(numberField_2)
        label_4.text = "\(multiplier) \(additional) "
    }
    
    @IBAction func numbers(_ sender: UIButton) { //Реализация кнопок
        if sender.tag != 100 {
            label_1.text = label_1.text! + String(sender.tag)
            numberField_1 = Double(label_1.text!)!
            convertation()
        }
        if ifisDot == false && sender.tag == 100 {
            ifisDot = true
            if label_1.text == ""{
                label_1.text = "0."
                numberField_1 = Double(label_1.text!)!
                convertation()
            }
            else {
                label_1.text = label_1.text! + "."
                numberField_1 = Double(label_1.text!)!
                convertation()
            }
        }
    }
    
    @IBAction func trash(_ sender: UIButton) { //Реализация кнопки удаления всех символов
        label_1.text = ""
        label_2.text = ""
        ifisDot = false
        numberField_1 = 0
    }
    
    @IBAction func Delete(_ sender: UIButton) { //Реализация кнопки удаления последнего символа
        if label_1.text!.last != "." {
            label_1.text = String(label_1.text!.dropLast())
            if label_1.text != ""{
            numberField_1 = Double(label_1.text!)!
            convertation()
            }
            else {
                numberField_1 = 0
                convertation()
            }
        }
        else {
            ifisDot = false
            label_1.text = String(label_1.text!.dropLast())
            numberField_1 = Double(label_1.text!)!
            convertation()
        }
    }
    
    @IBAction func changeSegment_1(_ sender: UISegmentedControl) { //Реализацияп первой кнопки выбора валюты
        segment_2.setEnabled( true , forSegmentAt: 0)
        segment_2.setEnabled( true , forSegmentAt: 1)
        segment_2.setEnabled( true , forSegmentAt: 2)
        segment_2.setEnabled( true , forSegmentAt: 3)
        selectedSegment_1 = sender.selectedSegmentIndex
        print("segment_1 selected index: \(selectedSegment_1)")
        segment_2.setEnabled( false, forSegmentAt: selectedSegment_1)
        convertation()
    }
    
    @IBAction func changeSegment_2(_ sender: UISegmentedControl) { //Реализация второй кнопки выбора валюты
        segment_1.setEnabled( true , forSegmentAt: 0)
        segment_1.setEnabled( true , forSegmentAt: 1)
        segment_1.setEnabled( true , forSegmentAt: 2)
        segment_1.setEnabled( true , forSegmentAt: 3)
        selectedSegment_2 = sender.selectedSegmentIndex
        print("segment_2 selected index: \(selectedSegment_2)")
        segment_1.setEnabled( false , forSegmentAt: selectedSegment_2)
        convertation()
    }
    
    @IBAction func Switch(_ sender: UIButton) { //Реализация кнопки "переключения" валют
        segment_1.selectedSegmentIndex = selectedSegment_2
        segment_2.selectedSegmentIndex = selectedSegment_1
        changeSegment_1(segment_1)
        changeSegment_2(segment_2)
    }

    //Отключение переворота экрана
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRates()
        segment_1.setEnabled( false , forSegmentAt: 1)
        segment_2.setEnabled( false , forSegmentAt: 0)
        label_4.text = "\(multiplier) USD"
    }

}
