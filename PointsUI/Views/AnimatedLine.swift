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
    var length: Double { extended ? 1.0 : 0.0 }
    var animation: Bool
    @State var extended: Bool = false
    
    func changeLength() {
        extended.toggle()
    }
    
    var body: some View {
        VStack {
            Text(extended ? "Extended" : "Contracted")
            if animation {
                Line(length: length)
                    .frame(width: 200, height: 30)
                    .background(Color.gray)
                    .clipShape(Capsule(style: .circular))
                    .animation(.easeInOut(duration: 1.0))
                    .onTapGesture {
                        self.changeLength()
                }
            } else {
                Line(length: length)
                    .frame(width: 200, height: 30)
                    .background(Color.gray)
                    .clipShape(Capsule(style: .circular))
                    .onTapGesture {
                        self.changeLength()
                }
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
