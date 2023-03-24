//
//  CityTextView.swift
//  Weather
//
//  Created by Max Stefankiv on 14.01.2023.
//

import SwiftUI

struct CityTextView: View {
    var cityName: String

    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct CityTextView_Previews: PreviewProvider {
    static var previews: some View {
        CityTextView(cityName: "Las Vegas")
    }
}
