
import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showFinalResult()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    func showImageLoadingError(message: String)
    
    func loadingStarted()
    
    func buttonsController(isEnable: Bool)
    
    func hideBorder()
}
