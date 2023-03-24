//
//  WheatherView.swift
//  Weather
//
//  Created by Max Stefankiv on 07.01.2023.
//

import SwiftUI

struct WheatherView: View {
    @StateObject var viewModel = WheatherViewModel()
    @State private var isNight = false
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)
            VStack {
                CityTextView(cityName: viewModel.wheatherInformation.cityName)
                
                MainWeatherStatusView(
                    imageName: isNight ? "moon.stars.fill" : "cloud.sleet.fill",
                    temperature: viewModel.wheatherInformation.currentData.temperature
                )
                
                HStack(spacing: 30) {
                    ForEach(viewModel.wheatherInformation.data) { info in
                        WeatherDayView(
                            dayOFWeek: info.day,
                            imageName: "cloud.sleet.fill",
                            temperature: info.temperature
                        )
                    }
                }
                
                Spacer()
                
                Button {
                    isNight.toggle()
                } label: {
                    WeatherButton(title: "Change Day Time",
                                  backgroundColor: .white,
                                  textColor: .blue)
                }
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.onViewAppeared.send()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WheatherView()
    }
}
