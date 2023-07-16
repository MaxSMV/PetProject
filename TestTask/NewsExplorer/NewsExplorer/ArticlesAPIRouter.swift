//
//  ArticlesAPIRouter.swift
//  NewsExplorer
//
//  Created by Max Stefankiv on 13.07.2023.
//

import Foundation
import Combine

enum ArticlesAPIRouterError: Error {
    case genericError
}

protocol ArticlesAPIRouterProtocol {
    func getEverything(
        query: String?,
        filter: (any Filter)?,
        from: Date?,
        to: Date?
    ) -> AnyPublisher<ArticlesDTO, ArticlesAPIRouterError>
}

struct ArticlesAPIRouter: ArticlesAPIRouterProtocol {
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    func getEverything(
        query: String? = nil,
        filter: (any Filter)? = nil,
        from: Date? = nil,
        to: Date? = nil
    ) -> AnyPublisher<ArticlesDTO, ArticlesAPIRouterError> {

        var url = "https://newsapi.org/v2/everything?apiKey=a66decac03cf4288a47ef89b4ce3ac33"
        
        // тут треба зібрати URL з параметрів, які сюди будемо передавати
        if let query = query {
            url.append("&q=" + query)
        }

        if let searchIn = filter as? SearchIn {
            url.append("&searchIn=" + searchIn.rawValue)
        }
        
        if let from = from {
            url.append("&from=" + from.ISO8601Format())
        }
        
        if let to = to {
            url.append("&to=" + to.ISO8601Format())
        }
        
        if let language = filter as? SearchLanguage {
            url.append("&language=" + language.rawValue)
        }
        
        if let sortBy = filter as? SortBy {
            url.append("&sortBy=" + sortBy.rawValue)
        }

        print("url: \(url)")
        return session
            .dataTaskPublisher(for: URL(string: url)!)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: ArticlesDTO.self, decoder: JSONDecoder())
            .mapError { error in
                print("Error: \(error)")
                return ArticlesAPIRouterError.genericError
            }
            .eraseToAnyPublisher()
    }
}
