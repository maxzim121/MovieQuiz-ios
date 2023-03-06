import UIKit

final class MovieQuizViewController: UIViewController {
    
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    private let questions: [QuizQuestion] = [
        QuizQuestion(
                    image: "The Godfather",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
        QuizQuestion(
                    image: "The Dark Knight",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
        QuizQuestion(
                    image: "Kill Bill",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
        QuizQuestion(
                    image: "The Avengers",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
        QuizQuestion(
                    image: "Deadpool",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
        QuizQuestion(
                    image: "The Green Knight",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: true),
        QuizQuestion(
                    image: "Old",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false),
        QuizQuestion(
                    image: "The Ice Age Adventures of Buck Wild",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false),
        QuizQuestion(
                    image: "Tesla",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false),
        QuizQuestion(
                    image: "Vivarium",
                    text: "Рейтинг этого фильма больше чем 6?",
                    correctAnswer: false)
    ]
    

    @IBAction private func noButtonTapped(_ sender: UIButton) {

        if questions[currentQuestionIndex].correctAnswer == false {
            showAnswerResult(isCorrect: true)
            correctAnswersCount += 1
        } else {
            showAnswerResult(isCorrect: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
        
    }
    
    @IBAction private func yesButtonTapped(_ sender: UIButton) {

        if questions[currentQuestionIndex].correctAnswer == true {
            showAnswerResult(isCorrect: true)
            correctAnswersCount += 1
        } else {
            showAnswerResult(isCorrect: false)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
        
    }
    
    private var correctAnswersCount: Int = 0
    
    private var currentQuestionIndex: Int = 0
    
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var indexLabel: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[currentQuestionIndex])) // Показываем на экране конвертированый вопроc
        
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
            let alert = UIAlertController(title: result.title,
                                          message: result.text,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: result.buttonText, style: .cancel) { [self] _ in
                self.currentQuestionIndex = 0
                self.show(quiz: self.convert(model: questions[currentQuestionIndex]))
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            self.correctAnswersCount = 0
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")

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
        
        if currentQuestionIndex == questions.count - 1 {
            show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат \(correctAnswersCount)/10",
                buttonText: "Сыграть ещё раз"))
        } else {
            currentQuestionIndex += 1
            print(currentQuestionIndex)
            show(quiz: convert(model: questions[currentQuestionIndex]))
            
            }
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
