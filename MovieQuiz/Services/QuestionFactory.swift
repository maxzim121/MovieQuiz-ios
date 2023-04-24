
import Foundation


class QuestionFactory: QuestionFactoryProtocol {
    
    private var movies: [MostPopularMovie] = []
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [ weak self ] result in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case.success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDadaFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadDataFromServer(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [ weak self ] in
            guard let self = self else {return}
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else {return}
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadImage(with: error)
                    print("Failed to load image")
                }
                return
            }
            
            let rating = Float(movie.imDbRating) ?? 0
            guard let ratingQuestion = (7...9).randomElement() else {return}
            
            let text = "Рейтинг фильма больше чем \(String(describing: ratingQuestion))?"
            let correctAnswer = rating > Float(ratingQuestion)
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            DispatchQueue.main.async { [ weak self ] in
                guard let self = self else {return}
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    } 
}
