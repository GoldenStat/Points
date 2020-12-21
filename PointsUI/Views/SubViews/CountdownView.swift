//
//  UpdateCountdownView.swift
//  PointsUI
//
//  Created by Alexander Völz on 16.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct CountDownArc: Shape {
    
    var length : Double
    
    // needed to actually have an animation
    var animatableData: Double {
        get { length }
        set { length = newValue }
    }

    // number between 1.0 and 0.0
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.height, rect.width) / 2.0
        let center = CGPoint(
            x: rect.origin.x + rect.width / 2.0,
            y: rect.origin.y + rect.height / 2.0)
        
        var path = Path()
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360 * length), clockwise: false)
        return path
    }
}

struct CountdownView: View {
    let totalTimeInterval: Double
    var color: Color = .black
    
    @State private var length: Double = 1.0
    var body: some View {
        CountDownArc(length: length)
            .rotation(Angle(degrees: -90))
            .fill(color)
            .onAppear {
                withAnimation(.linear(duration: totalTimeInterval)) {
                    length = 0.0
                }
            }
    }
}

struct ActiveCircleView: View {
    var color: Color = .orange
    @State private var scaleFactor : CGFloat = 0.5
    @State private var opacity = 1.0
    var body: some View {
        Circle()
            .fill(color)
            .scaleEffect(scaleFactor)
            .opacity(opacity)
            .onAppear() {
                withAnimation(
                    Animation.easeInOut(duration: 0.8)
                        .repeatForever(autoreverses: true)) {
                    scaleFactor = 0.4
                    opacity = 0.8
                }
            }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
//        CountdownView(totalTimeInterval: 5.0)
            ActiveCircleView()
                .frame(width: 40, height: 40)
            .previewLayout(.fixed(width: 60, height: 60))
    }
}
