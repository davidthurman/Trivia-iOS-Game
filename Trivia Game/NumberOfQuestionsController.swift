//
//  NumberOfQuestionsController.swift
//  Trivia Game
//
//  Created by David Thurman on 6/7/17.
//  Copyright © 2017 David Thurman. All rights reserved.
//

import UIKit

class NumberOfQuestionsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var numbersPicker: UIPickerView!
    
    var numbers: [String] = []
    
    var numOfQuestions: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for x in 1...50 {
            numbers.append(String(x))
        }
        numbersPicker.delegate = self
        numbersPicker.dataSource = self
        
        numbersPicker.selectRow(numOfQuestions, inComponent: 0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numbers[row]
    }
    */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = numbers[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "returnFromNumberOfQuestions") {
            if let startScreenVC: StartScreen = segue.destination as? StartScreen {
                startScreenVC.numOfQuestions = "&amount=" + String(numbersPicker.selectedRow(inComponent: 0) + 1)
            }
            
        }
    }
}
