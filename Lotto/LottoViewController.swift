//
//  ViewController.swift
//  Lotto
//
//  Created by SUCHAN CHANG on 1/16/24.
//

import UIKit
import Alamofire

struct Lotto: Codable {
    let drwNo: Int
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
}

class LottoViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

    var lottoPickerView = UIPickerView()
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.tintColor = .clear
        textField.inputView = lottoPickerView
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
    }

    func getLottoNumbers(with drwNo: Int, completionHandler: @escaping (String) -> Void) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Lotto.self) { response in
                switch response.result {
                case .success(let success):
                    completionHandler("\(success.drwtNo1) \(success.drwtNo2) \(success.drwtNo3) \(success.drwtNo4) \(success.drwtNo5) \(success.drwtNo6)")
                case .failure(let failure):
                    completionHandler(failure.localizedDescription)
                }
            }
    }
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = "\(numberList[row])회차"
        
        getLottoNumbers(with: numberList[row]) { lottNumbers in
            self.resultLabel.text = lottNumbers
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
}

