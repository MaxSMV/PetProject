//
//  ArticlesDomainModel.swift
//  NewsExplorer
//
//  Created by Max Stefankiv on 13.07.2023.
//

import Foundation
import Combine

// source of truth
final class ArticlesDomainModel {
    @Published var selectedArticle: Article?
    @Published var articlesDTO: ArticlesDTO?

    private let apiRouter: ArticlesAPIRouter

    private var cancellables = Set<AnyCancellable>()
    lazy var onArticleSelected = PassthroughSubject<Article, Never>()
    lazy var onSearch = PassthroughSubject<(String?, (any Filter)?), Never>()

    init(apiRouter: ArticlesAPIRouter) {
        self.apiRouter = apiRouter

        onArticleSelected.sink { [weak self] article in
            self?.selectedArticle = article
        }
        .store(in: &cancellables)

        onSearch.sink { [weak self] query, filter in
            self?.search(query: query, filter: filter)
        }
        .store(in: &cancellables)
        
        
    }

    private func search(query: String?, filter: (any Filter)? = nil) {
        var request: AnyCancellable?
        request = self.apiRouter.getEverything(query: query, filter: filter)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                request?.cancel()
            } receiveValue: { [weak self] articlesDTO in
                self?.articlesDTO = articlesDTO
            }
    }
}
