//
//  ViewController.swift
//  Trivia Game
//
//  Created by David Thurman on 6/3/17.
//  Copyright © 2017 David Thurman. All rights reserved.
//

import UIKit

class StartScreen: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let categories = ["Any Category","General Knowledge", "Books", "Film", "Music", "Musicals and Theatres", "Television", "Video Games", "Board Games", "Science and Nature", "Computers", "Mathematics", "Mythology", "Sports", "Geography", "History", "Politics", "Art", "Celebrities", "Animals", "Vehicles", "Comics", "Gadgets", "Japanese Anime and Manga", "Cartoon and Animations"]
    
    @IBOutlet var categoriesPicker: UIPickerView!

    @IBOutlet var difficultyPicker: UISegmentedControl!

    var difficulty: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesPicker.delegate = self
        categoriesPicker.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        difficultyPicker.addTarget(self, action: #selector(difficultyChanged), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startGameSegue") {
            
            if let mainGameVC: MainGame = segue.destination as? MainGame {
                mainGameVC.amount = "&amount=10"
                print(categoriesPicker.selectedRow(inComponent: 0))
                if categoriesPicker.selectedRow(inComponent: 0) == 0 {
                    mainGameVC.category = ""
                }
                else {
                    mainGameVC.category = "&category=" + String(categoriesPicker.selectedRow(inComponent: 0) + 8)
                }
                
                mainGameVC.difficulty = difficulty
            }
            
        }
    }

    func difficultyChanged(){
        switch difficultyPicker.selectedSegmentIndex {
        case 0:
            difficulty = "&difficulty=easy"
        case 1:
            difficulty = "&difficulty=medium"
        case 2:
            difficulty = "&difficulty=hard"
        default:
            difficulty = ""
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

}

