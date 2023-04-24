
import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

class MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - URL
    private var mostPopularMoviesURL: URL {
        
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_yvjfbw6w") else {
            preconditionFailure("Unable to construct mostPopularMoviesURL")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesURL) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
                
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

