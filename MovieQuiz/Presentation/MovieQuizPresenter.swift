//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Maksim Zimens on 22.04.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {

    var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewController?
    private var statisticService: StatisticService?
    
    private var correctAnswersCount: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
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
        self.disabelButtons()
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = true
        self.proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func noButtonTapped() {
        self.disabelButtons()
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = false
        self.proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
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
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() == true {
            viewController?.showFinalResult()
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewController?.somethingIsLoading()
            self.proceedToNextQuestionOrResults()
            self.enableButtons()
            self.viewController?.imageView.layer.borderWidth = 0
        }
        
    }
    
    //MARK: AlertMessage
    func makeResultMessage() -> String {
        statisticService?.store(correct: correctAnswersCount, total: questionsAmount)
        
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error")
            return ""
        }
        let totalPlaysCountLine = "Колличество сыграных квизов: \(statisticService.gamesCount)"
        let currentGameResult = "Ваш результат: \(correctAnswersCount)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        let resultMessage = [totalPlaysCountLine, currentGameResult, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
        return resultMessage
    }

    //MARK: ButtonsControls
    
    func disabelButtons() {
        viewController?.yesButton.isEnabled = false
        viewController?.noButton.isEnabled = false
    }
    
    func enableButtons() {
        viewController?.yesButton.isEnabled = true
        viewController?.noButton.isEnabled = true
    }


    
}
