
import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDadaFromServer()
    func didFailToLoadDataFromServer(with error: Error)
    func didFailToLoadImage(with error: Error)
}

