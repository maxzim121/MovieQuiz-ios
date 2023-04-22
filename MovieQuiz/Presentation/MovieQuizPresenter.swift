//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Maksim Zimens on 22.04.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {

    var correctAnswersCount: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.somethingIsLoading()
    }
    
    //MARK: CurrentQuestionIndex
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func restartGame() {
        correctAnswersCount = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    //MARK: ConvertQuestion
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // MARK: Actions
    
    func yesButtonTapped() {
        viewController?.disabelButtons()
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = true
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func noButtonTapped() {
        viewController?.disabelButtons()
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = false
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if (isCorrectAnswer) {
            correctAnswersCount += 1
        }
    }
    
    //MARK: QuestionRecieving
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
        self.viewController?.hideLoadingIndicator()
    }
    
    func didLoadDadaFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadDataFromServer(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didFailToLoadImage(with error: Error) {
        viewController?.showImageLoadingError(message: error.localizedDescription)
    }
    
    //MARK: ShowNextQuestionOrResult
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() == true {
            viewController?.showFinalResult()
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }


    
}
