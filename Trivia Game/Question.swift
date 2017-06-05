//
//  Question.swift
//  Trivia Game
//
//  Created by David Thurman on 6/3/17.
//  Copyright © 2017 David Thurman. All rights reserved.
//

import Foundation

class Question {
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    var type: String
    
    init(question: String, correctAnswer: String, incorrectAnswers: [String], type: String){
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
        self.type = type
    }
}
