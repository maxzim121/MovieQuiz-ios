import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        
        alertPresenter = AlertPresenter(viewController: self)
        
    }
    
    //MARK: - Actions
    
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        presenter.yesButtonTapped()
    }
    
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        presenter.noButtonTapped()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func hideBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func showFinalResult() {
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: "\(presenter.makeResultMessage())",
            buttonText: "Cыграть ещё раз",
            completion: { [weak self] in
                self?.presenter.restartGame()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    // MARK: - Indicator
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let networkAlert = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                self?.presenter.restartGame()
                self?.presenter.questionFactory?.loadData()}
        )
        alertPresenter?.show(alertModel: networkAlert)
    }

    func showImageLoadingError(message: String) {
        hideLoadingIndicator()
        let networkAlert = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                self?.presenter.questionFactory?.requestNextQuestion()}
        )
        alertPresenter?.show(alertModel: networkAlert)
    }
    
    // MARK: - LoadingScreen
    func loadingStarted() {
        imageView.image = nil
        questionLabel.text = "Загрузка вопроса...\n"
        showLoadingIndicator()
    }
    
    //MARK: ButtonsControls
    
    func buttonsController(isEnable: Bool) {
        yesButton.isEnabled = isEnable
        noButton.isEnabled = isEnable
    }
    
}
