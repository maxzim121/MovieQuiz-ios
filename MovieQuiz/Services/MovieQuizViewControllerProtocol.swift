//
//  MovieQuizControllerProtocol.swift
//  MovieQuiz
//
//  Created by Maksim Zimens on 22.04.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showFinalResult()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    func showImageLoadingError(message: String)
    
    func somethingIsLoading()
    
    func disableButtons()
    func enableButtons()
    
    func hideBorder()
}
