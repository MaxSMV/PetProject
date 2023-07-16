//
//  ArticlesDTO.swift
//  NewsExplorer
//
//  Created by Max Stefankiv on 13.07.2023.
//

import Foundation

struct ArticlesDTO: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]
}

extension ArticlesDTO {
    struct ArticleDTO: Decodable {
        let source: Source
        let author: String?
        let title: String
        let description: String
        let url: URL
        let urlToImage: URL?
        let publishedAt: String
        let content: String

        struct Source: Decodable {
            let name: String
        }
    }
}
