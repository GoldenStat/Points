//
//  ActivePlayerMarkerView.swift
//  PointsUI
//
//  Created by Alexander Völz on 24.03.21.
//  Copyright © 2021 Alexander Völz. All rights reserved.
//

import SwiftUI


/// the marker shows who is "active", e.g. the dealer and puts a frame around the active one
struct ActivePlayerMarkerView: View {
    
    @ObservedObject var token: Token
    var size : CGFloat { token.size }

    var animate : Bool = false
    var zoomFactor: CGFloat { animate ? 1.3 : 1.0 }
    
    struct ShadowModifier {
        var color: Color
        var radius: CGFloat
        var x: CGFloat
        var y: CGFloat

        static let up = ShadowModifier(color: .black, radius: 10, x: 8, y: 8)
        static let down = ShadowModifier(color: .black, radius: 4, x: 2, y: 2)
    }
    
    var shadow : ShadowModifier { animate ? .up : .down }
    var shadowColor: Color { animate ? .black : .clear }
    var rotationAngle: Angle { animate ? .degrees(30) : .zero }
    var tokenAnimation: Animation {
        animate ? .spring(response: 1, dampingFraction: 0.1, blendDuration: 0.3) : .default
    }
    var body: some View {
        Circle()
            .frame(width: size, height: size)
            .overlay(
                Text ("T")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            )
            .animation(nil)
            .rotation3DEffect(
                rotationAngle,
                axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            .animation(tokenAnimation)
            .scaleEffect(zoomFactor)
            .shadow(color: shadow.color,
                    radius: shadow.radius,
                    x: shadow.x, y: shadow.y)
            .animation(.default)
            .position(token.location)

    }        
}


struct AnchorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivePlayerMarkerView(token: Token(),
                               animate: true
        )
    }
}
