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

struct TitleView: View {

    @State var degrees : Double = 0.0
    @State var zoom : CGFloat = 0.0
    @State var opacity : Double = 0.3
    
    var body: some View {
        Text(GameSettings.name)
            .font(.system(size: fontSize))
            .opacity(opacity)
            .animation(
                .linear(duration: fadeDuration))
            .rotationEffect(.degrees(degrees),
                            anchor: .center)
            .animation(.spring(response: spring.response,
                               dampingFraction: spring.dampingFraction,
                               blendDuration: spring.blendDuration))
            .scaleEffect(zoom)
            .animation(.easeOut)
            .onAppear {
                degrees = finalDegrees
                zoom = finalZoom
            }
    }
    
//    MARK: local variables
    let fontSize : CGFloat = 144
    let fadeDuration : Double = 5
    let finalDegrees : Double = 45
    let finalZoom: CGFloat = 1.0
    
    let spring = ( response: 0.6, dampingFraction: 0.3, blendDuration: 1.0)

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
            TitleView(opacity: 0.1)
        }
    }
}
