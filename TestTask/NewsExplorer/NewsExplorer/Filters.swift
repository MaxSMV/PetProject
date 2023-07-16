//
//  Filters.swift
//  NewsExplorer
//
//  Created by Max Stefankiv on 13.07.2023.
//

import Foundation

protocol Filter: CaseIterable { }

enum SearchIn: String, Filter {
    static let name = "Search In"

    case title
    case description
    case content
}

enum SearchLanguage: String, Filter {
    static let name = "Search Language"

    case ar, de, en, es, fr, he, it, nl, no, pt, ru, sv, ud, zh
}


enum SortBy: String, Filter {
    static let name = "Sort By"

    /// articles more closely related to q come first.
    case relevancy

    /// articles from popular sources and publishers come first.
    case popularity

    /// newest articles come first.
    case publishedAt
}

enum SearchPeriod: Filter {
    static let name = "Search Period"

    case day
    case week
    case month
}


