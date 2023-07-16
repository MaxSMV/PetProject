//
//  NewsExplorerApp.swift
//  NewsExplorer
//
//  Created by Max Stefankiv on 13.07.2023.
//

import SwiftUI

@main
struct NewsExplorerApp: App {
    let articlesDomainModel: ArticlesDomainModel
    let articlesViewModel: ArticlesViewModel

    init() {
        articlesDomainModel = ArticlesDomainModel(apiRouter: ArticlesAPIRouter())
        articlesViewModel = ArticlesViewModel(model: articlesDomainModel)
    }

    var body: some Scene {
        WindowGroup {
            ArticlesView(viewModel: articlesViewModel)
        }
    }
}
