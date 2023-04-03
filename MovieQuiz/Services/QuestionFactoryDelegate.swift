//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Maksim Zimens on 22.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)     // 2
} 
