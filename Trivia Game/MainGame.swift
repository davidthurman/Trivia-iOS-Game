//
//  MainGame.swift
//  Trivia Game
//
//  Created by David Thurman on 6/3/17.
//  Copyright © 2017 David Thurman. All rights reserved.
//


import UIKit
import Alamofire

class MainGame: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    
    var score: Int = 0
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var answer1Button: UIButton!
    @IBOutlet var answer2Button: UIButton!
    @IBOutlet var answer3Button: UIButton!
    @IBOutlet var answer4Button: UIButton!
    
    var correctButton: Int = 0
    
    var buttons: [UIButton] = []
    
    var difficulty: String = ""
    var amount: String = ""
    var category: String = ""
    
    var questions: [Question] = []
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons.append(answer1Button)
        buttons.append(answer2Button)
        buttons.append(answer3Button)
        buttons.append(answer4Button)
        fetchQuestions()
        answer1Button.setTitle("Test", for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func fetchQuestions(){
        SwiftSpinner.show("Fetching Questions...")
        print("https://opentdb.com/api.php?" + amount +  category + difficulty)
        Alamofire.request("https://opentdb.com/api.php?" + amount +  category + difficulty).responseJSON { response in
            if let results = response.result.value {
                let json = JSON(results)
                for result in json["results"] {
                    let question = Question(question: result.1.rawDictionary["question"] as! String, correctAnswer: result.1.rawDictionary["correct_answer"] as! String, incorrectAnswers: result.1.rawDictionary["incorrect_answers"] as! [String], type: result.1.rawDictionary["type"] as! String)
                    self.questions.append(question)
                }
                self.populateQuestion()
            }
        }
        SwiftSpinner.hide()
    }
    
    func populateQuestion(){
        if index < questions.count {
            questions[index].question = formatStrings(myString: questions[index].question)
            questionLabel.text = questions[index].question
            
            
            if (questions[index].type == "multiple"){
                
                var randomInt: Int = Int(arc4random_uniform(4))
                questions[index].correctAnswer = formatStrings(myString: questions[index].correctAnswer)
                buttons[randomInt].setTitle(questions[index].correctAnswer, for: .normal)
                correctButton = randomInt
                var incorrectAnswersIndex = 0
                
                for count in 0...3 {
                    if count != randomInt {
                        questions[index].incorrectAnswers[incorrectAnswersIndex] = formatStrings(myString: questions[index].incorrectAnswers[incorrectAnswersIndex])
                        buttons[count].setTitle(questions[index].incorrectAnswers[incorrectAnswersIndex], for: .normal)
                        incorrectAnswersIndex = incorrectAnswersIndex + 1
                    }
                }
            }
            else if (questions[index].type == "boolean"){
                
            }
            
            index = index + 1
        }
        else {
            let alertController = UIAlertController(title: title, message: "Final Score: " + String(score), preferredStyle: .alert)
            let returnAction = UIAlertAction(title: "Return", style: .default) {
                (result : UIAlertAction) -> Void in
                self.performSegue(withIdentifier: "mainMenuSegue", sender: nil)
            }
            let playAgainAction = UIAlertAction(title: "Play Again", style: .default) {
                (result : UIAlertAction) -> Void in
                self.reset()
                self.fetchQuestions()
            }
            alertController.addAction(returnAction)
            alertController.addAction(playAgainAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func answer1Action(_ sender: Any) {
        checkAnswer(buttonSender: 0)
    }
    
    @IBAction func answer2Action(_ sender: Any) {
        checkAnswer(buttonSender: 1)
    }
    
    @IBAction func answer3Action(_ sender: Any) {
        checkAnswer(buttonSender: 2)
    }
    
    @IBAction func answer4Action(_ sender: Any) {
        checkAnswer(buttonSender: 3)
    }
    
    func checkAnswer(buttonSender: Int){
        if buttonSender == correctButton {
            score = score + 1
            scoreLabel.text = "Score: " + String(score)
            scoreLabel.textColor = UIColor.green
        }
        else {
            scoreLabel.textColor = UIColor.red
        }
        populateQuestion()
    }
    
    func reset() {
        index = 0
        score = 0
        questions = []
    }
    
    func formatStrings(myString: String) -> String{
        var newString = myString.replacingOccurrences(of: "&#039;", with: "'")
        newString = myString.replacingOccurrences(of: "&amp;", with: "&")
        newString = myString.replacingOccurrences(of: "&quot;", with: "\"")
        newString = myString.replacingOccurrences(of: "&rsquo;", with: "'")
        return newString
    }
    
}

