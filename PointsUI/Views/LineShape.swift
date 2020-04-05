//
//  LineShape.swift
//  PointsUI
//
//  Created by Alexander Völz on 04.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct LineShape: Shape {
    
    /// values bigger than number are ignored
    static var maximumLinesIndex = Self.lines.count - 1
    
    var from: Int
    var to: Int
    
    var animatingLastLine: Bool

    var lastLineLength : Double
//    var length : Double
//
//    var animatableData : Double {
//        get { return length }
//        set { length = newValue }
//    }
    var animatableData : Double {
        get { return lastLineLength }
        set { lastLineLength = newValue }
    }
    
    init(from: Int, to: Int = Self.maximumLinesIndex, animatingLastLine: Bool = false) {
        self.from = from
        self.to = to
        self.animatingLastLine = animatingLastLine
        self.lastLineLength = animatingLastLine ? 1.0 : 0.0
    }
    
    static private let lines : [(start: (CGFloat,CGFloat), end: (CGFloat,CGFloat))] = [
        (start: (0.0, 1.0), end: (0.0, 0.0)),
        (start: (0.0, 0.0), end: (1.0, 0.0)),
        (start: (0.0, 1.0), end: (1.0, 1.0)),
        (start: (1.0, 1.0), end: (1.0, 0.0)),
        (start: (0.0, 0.0), end: (1.0, 1.0)),
        (start: (0.0, 1.0), end: (1.0, 0.0))
    ]
    
    
    func path(in rect: CGRect) -> Path {
        
        /// translate a relative Point from our corners to a CGPoint in our View
        func cornerPoint(point: (CGFloat,CGFloat)) -> CGPoint {
            return CGPoint(
                x: rect.maxX + (1.0 - point.0) * (rect.minX - rect.maxX),
                y: rect.maxY + (1.0 - point.1) * (rect.minY - rect.maxY)
            )
        }

        let startPoint = max(min(self.from, Self.maximumLinesIndex), 0) // first and last of the points
        let endPoint = min(max(self.to, 0),Self.maximumLinesIndex)      // within valid limits
                
        var path = Path()
        
        // draw lines from start to end - 1
        for index in startPoint ..< endPoint - 1{
            
            let start = cornerPoint(point: Self.lines[index].start)
            let end = cornerPoint(point: Self.lines[index].end)
            
            path.move(to: start)
            path.addLine(to: end)
            
        }

        // draw last line, eventually animated
//        let start = cornerPoint(point: Self.lines[endPoint].start)
//        let end = cornerPoint(point: Self.lines[endPoint].end)
//
//        path.move(to: start)
//
//        let x = start.x + (end.x-start.x)*CGFloat(lastLineLength)
//        let y = start.y + (end.y-start.y)*CGFloat(lastLineLength)
//        let toPoint = CGPoint(x: x, y: y)
//
//        path.addLine(to: toPoint)
        
        path.move(to: cornerPoint(point: Self.lines[endPoint].start))

        if (animatingLastLine) {
            path.addLine(to: cornerPoint(point: Self.lines[endPoint].end))
        } else {
            path.addLine(to: cornerPoint(point: Self.lines[endPoint].end))
        }
        
        return path
    }
}

struct TestLineShapeAnimation: View {
    
    @State var animating = true
    @State var score = 0
    
    var body: some View {
        
        VStack {
            LineShape(from: 0, to: score, animatingLastLine: animating)
                .stroke(Color.solid)
                .padding()
                .background(Color.gray)
                .onTapGesture {
                    self.score += 1
                    if self.score > 5 {
                        self.score = 0
                    }
            }
        }
    }
}

struct LineShape_Previews: PreviewProvider {
    static var previews: some View {
        TestLineShapeAnimation()
    }
}
