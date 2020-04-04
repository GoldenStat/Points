//
//  AnimatedLine.swift
//  PointsUI
//
//  Created by Alexander Völz on 04.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct Line: Shape {
    
    var length : Double
    
    var animatableData : Double {
        get { return length }
        set { length = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        
        let width : CGFloat = 5.0
        
        let a = rect.minX
        let b = rect.maxX
        let y = rect.midY
        
        var path = Path()
        path.move(to: CGPoint(x: a, y: y))
        path.addLine(to: CGPoint(x: a + (b-a)*CGFloat(length), y: y))
        path.addLine(to: CGPoint(x: a + (b-a)*CGFloat(length), y: y+width))
        path.addLine(to: CGPoint(x: a, y: y+width))
        
        path.closeSubpath()
        
        return path
    }
}

struct AnimatedLine: View {
    @State var length = 0.0
    var animation: Bool
    func changeLength() {
        if length > 0.0 {
            length = 0.0
        } else {
            length = 1.0
        }
    }
    
    var body: some View {
        VStack {
            if animation {
                Line(length: length)
                    .frame(width: 100, height: 10)
                    .background(Color.gray)
                    .clipShape(Capsule(style: .circular))
                    .animation(.easeInOut(duration: 1.0))
                    .onTapGesture {
                        self.changeLength()
                }
            } else {
                Line(length: 1.0)
                    .frame(width: 100, height: 10)
                    .background(Color.gray)
                    .clipShape(Capsule(style: .circular))
            }
        }
    }
}


struct AnimatedLine_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AnimatedLine(animation: true)
            AnimatedLine(animation: false)
        }
    }
}
