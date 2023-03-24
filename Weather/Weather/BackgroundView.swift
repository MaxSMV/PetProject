//
//  BackgroundView.swift
//  Weather
//
//  Created by Max Stefankiv on 14.01.2023.
//

import SwiftUI

struct BackgroundView: View {
    @Binding var isNight: Bool

    var body: some View {
        LinearGradient(gradient:Gradient(colors: [isNight ? .black : .blue, isNight ? .gray : Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(isNight: .constant(false))
    }
}
