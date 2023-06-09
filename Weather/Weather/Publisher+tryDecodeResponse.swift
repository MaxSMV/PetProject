//
//  Publisher+tryDecodeResponse.swift
//  Weather
//
//  Created by Max Stefankiv on 14.01.2023.
//

import Combine
import Foundation

extension Publisher {
  func tryDecodeResponse<Item, Coder>(type: Item.Type, decoder: Coder) -> Publishers.Decode<Publishers.TryMap<Self, Data>, Item, Coder> where Item: Decodable, Coder: TopLevelDecoder, Self.Output == (data: Data, response: URLResponse) {
    return self
      .tryMap { output in
        guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
          throw URLError(.badServerResponse)
        }
        return output.data
      }
      .decode(type: type, decoder: decoder)
  }
}
