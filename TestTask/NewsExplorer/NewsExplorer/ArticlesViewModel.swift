//
//  ArticlesViewModel.swift
//  NewsExplorer
//
//  Created by Max Stefankiv on 13.07.2023.
//

import Foundation
import Combine

struct Article: Identifiable {
    var id: String { title }

    let image: URL?
    let title: String
    let description: String
    let author: String
    let source: String
    let publishedAt: String
    let content: String

}

final class ArticlesViewModel: ObservableObject {
    @Published var searchQuery: String = "Bitcoin"
    @Published var articles: [Article] = []
    @Published var selectedArticle: Article = Article(image: URL(string: "google.com")!, title: "", description: "", author: "", source: "", publishedAt: "", content: "")
    @Published var isDescriptionPresented = false

    @Published var searchInSelection = 0
    
    let onArticleSelected: PassthroughSubject<Article, Never>
    let onSearch: PassthroughSubject<(String?, (any Filter)?), Never>

    init(model: ArticlesDomainModel) {
        onArticleSelected = model.onArticleSelected
        onSearch = model.onSearch

        model.$selectedArticle
            .compactMap { [weak self] article in
                self?.isDescriptionPresented = article != nil
                return article
            }
            .assign(to: &$selectedArticle)

        model.$articlesDTO
            .compactMap { dto in
                dto?.articles
                    .map { article in
                        Article(
                            image: article.urlToImage,
                            title: article.title,
                            description: article.description,
                            author: article.author ?? "Unknown",
                            source: article.source.name,
                            publishedAt: article.publishedAt.ISO8601Format(),
                            content: article.content.removeHTMLTags()
                        )
                    }
            }
            .assign(to: &$articles)
    }
}

extension String {
    func ISO8601Format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: self) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMMM d, yyyy"
            return displayFormatter.string(from: date)
        }
        
        return self
    }
}

extension String {
    func removeHTMLTags() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString.string
        }
        
        return self
    }
}
