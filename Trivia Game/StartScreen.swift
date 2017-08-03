//
//  ViewController.swift
//  Trivia Game
//
//  Created by David Thurman on 6/3/17.
//  Copyright © 2017 David Thurman. All rights reserved.
//

import UIKit

class StartScreen: UIViewController {
    
    @IBOutlet var difficultyPicker: UISegmentedControl!

    var difficulty: String = ""
    var category: String = ""
    var numOfQuestions: String = "&amount=10"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        difficultyPicker.addTarget(self, action: #selector(difficultyChanged), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startGameSegue") {
            
            if let mainGameVC: MainGame = segue.destination as? MainGame {
                mainGameVC.amount = numOfQuestions
                mainGameVC.category = category
                mainGameVC.difficulty = difficulty
            }
            
        }
        
        else if segue.identifier == "changeCategorySegue" {
            if let catergoryVS: CategoryController = segue.destination as? CategoryController {
                if category.characters.count > 2 {
                    if let chosenCategory = Int(category.substring(from: category.index(category.endIndex, offsetBy: -2))) {
                        print("SUCCESS")
                        catergoryVS.chosenCategory = chosenCategory - 8
                    }
                    else if let chosenCategory = Int(category.substring(from: category.index(category.endIndex, offsetBy: -1))) {
                        print("SUCCESS2")
                        catergoryVS.chosenCategory = chosenCategory - 8
                    }
                }
            }
        }
        else if segue.identifier == "changeNumberOfQuestionsSegue" {
            if let numQuestionsVS: NumberOfQuestionsController = segue.destination as? NumberOfQuestionsController {
                print(numOfQuestions.characters.count)
                if numOfQuestions.characters.count > 2 {
                    print(numOfQuestions)
                    if let numOfQuestionsIndex = Int(numOfQuestions.substring(from: numOfQuestions.index(numOfQuestions.endIndex, offsetBy: -2))) {
                        numQuestionsVS.numOfQuestions = numOfQuestionsIndex - 1
                    }
                    else if let numOfQuestionsIndex = Int(numOfQuestions.substring(from: numOfQuestions.index(numOfQuestions.endIndex, offsetBy: -1))) {
                        numQuestionsVS.numOfQuestions = numOfQuestionsIndex - 1
                    }
                }
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
    
}

