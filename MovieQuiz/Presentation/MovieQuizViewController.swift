import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private var currentQuestion: QuizQuestion?
    
    private var correctAnswersCount: Int = 0
    
    public var currentQuestionIndex: Int = 0
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        
        disabelButtons()
        guard let currentQuestion = currentQuestion else {return}
        if currentQuestion.correctAnswer == false {
            showAnswerResult(isCorrect: true)
            correctAnswersCount += 1
        } else {
            showAnswerResult(isCorrect: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.enableButtons()
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
        
    }
    
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        
        disabelButtons()
        guard let currentQuestion = currentQuestion else {return}
        if currentQuestion.correctAnswer == true {
            showAnswerResult(isCorrect: true)
            correctAnswersCount += 1
        } else {
            showAnswerResult(isCorrect: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.enableButtons()
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
        
    }
    
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var indexLabel: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
        
        alertPresenter = AlertPresenter(delegate: self)// Показываем на экране конвертированый вопроc
        
    }
    // MARK: - AlertPresenterDelegate
    
    func presentAlert(alert: UIAlertController?) {
        guard let alert = alert else {return}
        self.presentAlert(alert: alert)
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
    }


    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
    }
    
    private func show(quiz result: AlertModel) {
        
        let alertModel = AlertModel(title: "Этот раунд окночен!",
                                    message: "Ваш результат \(correctAnswersCount) из 10",
                                    buttonText:"Сыграть еще раз!") { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswersCount = 0
            self.questionFactory?.requestNextQuestion()
            
        }
        
        alertPresenter?.showAlert(model: alertModel)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")

    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        imageView.layer.masksToBounds = true
        if isCorrect == true {
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
    }
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1 {
            let viewModel = AlertModel(
                            title: "Этот раунд закончен",
                            message: "Ваш результат \(correctAnswersCount) из 10",
                            buttonText: "Сыграть еще раз!",
                            completion:{ [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswersCount = 0 } )
            show(quiz: viewModel) } else {
                            
            currentQuestionIndex += 1
            print(currentQuestionIndex)
            questionFactory?.requestNextQuestion()
            
            }
        }
    
    private func disabelButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    }


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
