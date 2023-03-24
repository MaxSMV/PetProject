//
//  WheatherViewModel.swift
//  Weather
//
//  Created by Max Stefankiv on 14.01.2023.
//

import Foundation
import Combine

final class WheatherViewModel: ObservableObject {
    // TODO: create dict of code - SF symbol info
    let icons = [
        "802": "cloud.fill"
    ]

    @Published var wheatherInformation: Wheather = Wheather()

    var cancellables = Set<AnyCancellable>()
    private let repository = WheatherRepository()

    let onViewAppeared = PassthroughSubject<Void, Never>()

    init() {
        setupBindings()
    }

    func setupBindings() {
        onViewAppeared.sink { [weak self] _ in
            var request: AnyCancellable?
            request = self?.repository.fetchWheatherInfo()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let failure):
                        print("Failure on fetching wheather info: \(failure)")
                    }
                    request?.cancel()
                } receiveValue: { [weak self] dto in
                    self?.wheatherInformation = Wheather(wheatherDTO: dto)
                }

        }
        .store(in: &cancellables)
    }
}
