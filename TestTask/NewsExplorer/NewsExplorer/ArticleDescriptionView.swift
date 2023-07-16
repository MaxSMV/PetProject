//
//  ArticleDescriptionView.swift
//  NewsExplorer
//
//  Created by Max Stefankiv on 13.07.2023.
//

import SwiftUI

extension Image {
    func imageModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
    }
    func iconModifier() -> some View {
        self
            .imageModifier()
            .frame(maxWidth: 128)
            .foregroundColor(.gray)
            .opacity(0.5)
    }
}

struct ArticleDescriptionView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
        ZStack {
                VStack(alignment: .leading) {
                    GeometryReader { geometry in
                        Text(article.source)
                            .font(.system(size: 16))
                            .lineLimit(nil)
                            .padding(10)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1))
                    }.padding(.bottom, 40)
                    Text(article.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(article.description)
                        .font(.body)
                        .padding(.bottom)
                        .frame(maxWidth: .infinity)
                    
                    if let imageURL = article.image {
                        AsyncImage(url: imageURL)
                        { phase in
                            switch phase {
                            case.success(let image):
                                image
                                    .imageModifier()
                                    .transition(.move(edge: .bottom))
                            case.failure(_):
                                Image(systemName: "ant.circle.fill").iconModifier()
                            case.empty:
                                Image(systemName: "photo.circle.fill").iconModifier()
                            @unknown default:
                                ProgressView()
                            }
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    HStack {
                        Text("By \(article.author)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Published \(article.publishedAt)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(article.content)
                        .font(.body)
                        .padding(.bottom)
                        .lineLimit(nil)
                }
                .padding()
            }
        }
    }
}
