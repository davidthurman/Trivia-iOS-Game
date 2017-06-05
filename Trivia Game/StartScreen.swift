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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                mainGameVC.category = ""
                mainGameVC.difficulty = ""
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

