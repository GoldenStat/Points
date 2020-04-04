//
//  Line.swift
//  Points
//
//  Created by Alexander Völz on 19.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
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
    
    func changeLength() {
        if length > 0.0 {
            length = 0.0
        } else {
            length = 1.0
        }
    }
    
    var body: some View {
        VStack {
            Line(length: length)
                .frame(width: 100, height: 50)
                .background(Color.blue)
            .animation(.easeInOut(duration: 5.0))
            .onTapGesture {
                self.changeLength()
            }
        }
    }
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedLine()
    }
}
