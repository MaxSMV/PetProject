//
//  ArticlesView.swift
//  NewsExplorer
//
//  Created by Max Stefankiv on 13.07.2023.
//

import SwiftUI

struct ArticlesView: View {
    private enum Constants {
        static let textFieldLabel = "Search"
        static let textFieldSearchButton = "Search"

        enum Article {
            static let bottomPadding = 20.0
        }
    }

    @ObservedObject var viewModel: ArticlesViewModel

    var body: some View {
        VStack {
            HStack {
                TextField(Constants.textFieldLabel, text: $viewModel.searchQuery)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray3), lineWidth: 1)
                    )
                    .padding(.leading, 0)
                
                Button(action: {
                    viewModel.onSearch.send((viewModel.searchQuery, nil))
                }) {
                    Text(Constants.textFieldSearchButton)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .controlSize(.large)
                .padding(.trailing, 0)
            }

            HStack {
                Menu {
                    Picker(SearchIn.name, selection: $viewModel.searchInSelection) {
                        ForEach(SearchIn.allCases, id: \.self) { filterCase in
                            Button {
                                viewModel.onSearch.send((viewModel.searchQuery, filterCase))
                            } label: {
                                Text(filterCase.rawValue)
                            }
                        }
                    }
                } label: {
                    Text(SearchIn.name)
                }
                .buttonStyle(.bordered)

                Menu {
                    ForEach(SearchLanguage.allCases, id: \.self) { filterCase in
                        Button {
                            viewModel.onSearch.send((viewModel.searchQuery, filterCase))
                        } label: {
                            Text(filterCase.rawValue)
                        }
                    }
                } label: {
                    Text(SearchLanguage.name)
                }
                .buttonStyle(.bordered)

                Menu {
                    ForEach(SortBy.allCases, id: \.self) { filterCase in
                        Button {
                            viewModel.onSearch.send((viewModel.searchQuery, filterCase))
                        } label: {
                            Text(filterCase.rawValue)
                        }
                    }
                } label: {
                    Text(SortBy.name)
                }
                .buttonStyle(.bordered)
            }

            ScrollView {
                ForEach(viewModel.articles) { article in
                    makeArticle(article)
                }
            }
        }
        .padding()
        .sheet(isPresented: $viewModel.isDescriptionPresented) {
            ArticleDescriptionView(article: viewModel.selectedArticle)
        }
        .onAppear {
            viewModel.onSearch.send((viewModel.searchQuery, nil))
        }
    }

    private func makeArticle(_ article: Article) -> some View {
        VStack {
            Text(article.title)
                .font(.system(size: 16))
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            Text(article.description)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
        }
        .padding(.bottom, Constants.Article.bottomPadding)
        .onTapGesture {
            viewModel.onArticleSelected.send(article)
        }
    }
}
