//
//  UpdateCountdownView.swift
//  PointsUI
//
//  Created by Alexander Völz on 16.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct CountDownArc: Shape {
    let length : Double // number between 1.0 and 0.0
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

struct UpdateCountdownView: View {
    let totalTimeInterval: Double
    @State private var length: Double = 1.0
    var body: some View {
        CountDownArc(length: length)
            .onAppear {
                withAnimation(.linear(duration: totalTimeInterval)) {
                    length = 1.0
                }
            }
    }
}

struct UpdateCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateCountdownView(totalTimeInterval: 5.0)
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
//        CountDownArc(length: 5.0)
    }
}
