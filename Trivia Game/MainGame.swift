//
//  MainGame.swift
//  Trivia Game
//
//  Created by David Thurman on 6/3/17.
//  Copyright © 2017 David Thurman. All rights reserved.
//


import UIKit
import Alamofire
import AVFoundation

class MainGame: UIViewController {
    
    @IBOutlet var previousResultLabel: UILabel!
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
    
    var player: AVAudioPlayer?
    
    @IBOutlet var soundImage: UIImageView!
    var sound: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        soundImage.isUserInteractionEnabled = true
        soundImage.addGestureRecognizer(tapGestureRecognizer)
        
        buttons.append(answer1Button)
        buttons.append(answer2Button)
        buttons.append(answer3Button)
        buttons.append(answer4Button)
        fetchQuestions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mainMenuSegue") {
            
            if let startScreenVC: StartScreen = segue.destination as? StartScreen {
                startScreenVC.numOfQuestions = amount
                startScreenVC.category = category
                startScreenVC.difficulty = difficulty
            }
            
        }
    }
    
    func fetchQuestions(){
        for x in 0...3 {
            buttons[x].isHidden = true
        }
        SwiftSpinner.show("Fetching Questions...")
        print("https://opentdb.com/api.php?" + amount +  category + difficulty)
        var success = false
        Alamofire.request("https://opentdb.com/api.php?" + amount +  category + difficulty).responseJSON { response in
            if response.response == nil {
                SwiftSpinner.hide()
                self.noInternet()
            }
            else if let results = response.result.value {
                success = true
                let json = JSON(results)
                for result in json["results"] {
                    let question = Question(question: result.1.rawDictionary["question"] as! String, correctAnswer: result.1.rawDictionary["correct_answer"] as! String, incorrectAnswers: result.1.rawDictionary["incorrect_answers"] as! [String], type: result.1.rawDictionary["type"] as! String)
                    self.questions.append(question)
                }
                self.populateQuestion()
            }
            SwiftSpinner.hide()
        }
        
    }
    
    func noInternet(){
        let alertController = UIAlertController(title: title, message: "No internet connection", preferredStyle: .alert)
        let returnAction = UIAlertAction(title: "Return", style: .default) {
            (result : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "mainMenuSegue", sender: nil)
        }
        let playAgainAction = UIAlertAction(title: "Try Again", style: .default) {
            (result : UIAlertAction) -> Void in
            self.reset()
            self.fetchQuestions()
        }
        alertController.addAction(returnAction)
        alertController.addAction(playAgainAction)
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func populateQuestion(){
        for x in 0...3 {
            buttons[x].isHidden = false
        }
        if index < questions.count {
            questions[index].question = formatStrings(myString: questions[index].question)
            questionLabel.text = questions[index].question
            
            
            if (questions[index].type == "multiple"){
                
                buttons[2].isHidden = false
                buttons[3].isHidden = false
                
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
                buttons[2].isHidden = true
                buttons[3].isHidden = true
                
                var randomInt: Int = Int(arc4random_uniform(2))
                questions[index].correctAnswer = formatStrings(myString: questions[index].correctAnswer)
                buttons[randomInt].setTitle(questions[index].correctAnswer, for: .normal)
                correctButton = randomInt
                
                var incorrectAnswersIndex = 0
                for count in 0...1 {
                    if count != randomInt {
                        questions[index].incorrectAnswers[incorrectAnswersIndex] = formatStrings(myString: questions[index].incorrectAnswers[incorrectAnswersIndex])
                        buttons[count].setTitle(questions[index].incorrectAnswers[incorrectAnswersIndex], for: .normal)
                        incorrectAnswersIndex = incorrectAnswersIndex + 1
                    }
                }
                
            }
        }
        else {
            let alertController = UIAlertController(title: title, message: "Final Score: " + "Score: " + String(Int((Double(score)/Double(index + 1)) * 100)) + "%", preferredStyle: .alert)
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
            correctSound()
            score = score + 1
            previousResultLabel.text = "Correct! Answer was " + questions[index].correctAnswer
            previousResultLabel.textColor = UIColor.init(colorLiteralRed: 0, green: 0.600, blue: 0.200, alpha: 1.0)
            print(index)
            print(questions.count)
            print(Double(score)/Double(questions.count))
            print("Score: " + String((score/questions.count) * 100))
            scoreLabel.text = "Score: " + String(Int((Double(score)/Double(index + 1)) * 100)) + "%"
        }
        else {
            incorrectSound()
            previousResultLabel.text = "Incorrect! Answer was " + questions[index].correctAnswer
            previousResultLabel.textColor = UIColor.init(colorLiteralRed: 0.737, green: 0.255, blue: 0.157, alpha: 1.0)
            print(index)
            scoreLabel.text = "Score: " + String(Int((Double(score)/Double(index + 1)) * 100)) + "%"
        }
        index = index + 1
        populateQuestion()
    }
    
    func reset() {
        index = 0
        score = 0
        questions = []
        previousResultLabel.text = ""
    }
    
    func formatStrings(myString: String) -> String{
        var newString = myString.replacingOccurrences(of: "&#039;", with: "'")
        newString = newString.replacingOccurrences(of: "&amp;", with: "&")
        newString = newString.replacingOccurrences(of: "&quot;", with: "\"")
        newString = newString.replacingOccurrences(of: "&rsquo;", with: "'")
        newString = newString.replacingOccurrences(of: "&ldquo;", with: "\"")
        newString = newString.replacingOccurrences(of: "&ouml;", with: "ö")
        newString = newString.replacingOccurrences(of: "&Ouml;", with: "Ö")
        newString = newString.replacingOccurrences(of: "&auml;", with: "ä")
        newString = newString.replacingOccurrences(of: "&Auml;", with: "Ä")
        newString = newString.replacingOccurrences(of: "&eacute;", with: "é")
        newString = newString.replacingOccurrences(of: "&Eacute;", with: "É")
        newString = newString.replacingOccurrences(of: "&rdquo;", with: "\"")
        return newString
    }
    
    func correctSound() {
        if sound {
            let url = Bundle.main.url(forResource: "correct_sound", withExtension: "mp3")!
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                guard let player = player else { return }
                
                player.prepareToPlay()
                player.play()
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    func incorrectSound() {
        if sound {
            let url = Bundle.main.url(forResource: "incorrect_sound", withExtension: "mp3")!
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                guard let player = player else { return }
                
                player.prepareToPlay()
                player.play()
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if sound {
            soundImage.image = UIImage(named:"muted.png")
            sound = false
        }
        else {
            soundImage.image = UIImage(named:"sound.png")
            sound = true
        }
    }
    
}

