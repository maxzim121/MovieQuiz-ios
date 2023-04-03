import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
/*
    private struct MovieInfo: Codable {
        let id: String
        let rank: Int
        let title: String
        let fullTitle: String
        let year: Int
        let crew: String
        let imDbRating: Double
        let imDbRatingCount: Int
        
        enum CodingKeys: CodingKey {
            case id, rank, title, fullTitle, year, crew, imDbRating, imDbRatingCount
        }
        
        enum ParseError: Error {
            case rankFailure
            case yearFailure
            case imDbRatingFailure
            case imDbRatingCountFailure
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(String.self, forKey: .id)
            
            let rank = try container.decode(String.self, forKey: .rank)
            guard let rankValue = Int(rank) else {
                throw ParseError.rankFailure
            }
            self.rank = rankValue
            
            title = try container.decode(String.self, forKey: .title)
            fullTitle = try container.decode(String.self, forKey: .fullTitle)
            
            let year = try container.decode(String.self, forKey: .year)
            guard let yearValue = Int(year) else {
                throw ParseError.yearFailure
            }
            self.year = yearValue
            
            crew = try container.decode(String.self, forKey: .crew)
            
            let imDbRating = try container.decode(String.self, forKey: .imDbRating)
            guard let imDbRatingValue = Double(imDbRating) else {
                throw ParseError.imDbRatingFailure
            }
            self.imDbRating = imDbRatingValue
            
            let imDbRatingCount = try container.decode(String.self, forKey: .imDbRatingCount)
            guard let imDbRatingCountValue = Int(imDbRatingCount) else {
                throw ParseError.imDbRatingCountFailure
            }
            self.imDbRatingCount = imDbRatingCountValue
        }
    }
    
    private struct Movies: Decodable {
        let items: [MovieInfo]
        
        enum CodingKeys: CodingKey {
            case items
        }
        
        enum ParseError: Error {
            case yearFailure
            case runtimeMinsFailure
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            items = try container.decode([MovieInfo].self, forKey: .items)
        }
        
    }
*/
    
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var currentQuestion: QuizQuestion?
    
    private let questionsAmount: Int = 10
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
/*
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "top250MoviesIMDB.json"
        documentsURL.appendPathComponent(fileName)
        let jsonString = try? String(contentsOf: documentsURL)
        let data = jsonString!.data(using: .utf8)!
        do {
            let movies = try JSONDecoder().decode(Movies.self, from: data)
            print(movies)
        } catch {
            print("Failed to parse: \(error.localizedDescription)")
        }
*/
        
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        statisticService = StatisticServiceImplementation()
        alertPresenter = AlertPresenter(viewController: self)
        
        questionFactory?.requestNextQuestion()
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
    
    
    private func showFinalResult() {
        statisticService?.store(correct: correctAnswersCount, total: questionsAmount)
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: "\(makeResultMessage())",
            buttonText: "Cыграть ещё раз",
            completion: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswersCount = 0
                self?.questionFactory?.requestNextQuestion()}
        )
        alertPresenter?.show(alertModel: alertModel)
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
            showFinalResult()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    
    private func makeResultMessage() -> String {
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
    
    // MARK: ButtonsControl
    
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
