//
//  Title.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.06.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Color {
    static let boardbgColor = Color(red: 200 / 255.0, green: 200 / 255.0, blue: 255 / 255.0)
}

struct Title: View {

    @State var degrees : Double = 0.0
    @State var zoom : CGFloat = 0.0
    @State var opacity : Double = 0.3
    let fadeDuration : Double = 5
    
    var body: some View {
        Text(GameSettings.name)
            .font(.system(size: 144))
            .opacity(opacity)
            .animation(
                .linear(duration: fadeDuration))
            .rotationEffect(.degrees(degrees),
                            anchor: .center)
            .animation(.spring(response: 0.6,
                               dampingFraction: 0.3,
                               blendDuration: 1.0))
            .scaleEffect(zoom)
            .animation(.easeOut)
            .onAppear {
                degrees = 45.0
                zoom = 1.0
            }
    }
}

struct Background: View {
    var body: some View {
        Color.boardbgColor
            .edgesIgnoringSafeArea(.all)
    }
}

struct Background_Previews: PreviewProvider {
    @State static var opacity = 0.1
    static var previews: some View {
        ZStack {
            Background()
            Title(opacity: 0.1)
        }
    }
}
