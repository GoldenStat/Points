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
    static var maximumLines = Self.lines.count - 1

    var from: Int
    var to: Int
    
    var animatingLastLine: Bool
    private var lastLineLength : Double
    
    var animatableData : Double {
        get { return self.lastLineLength }
        set { self.lastLineLength = newValue }
    }
    
    init(from: Int, to: Int = Self.maximumLines, animatingLastLine: Bool = false) {
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

        let from = max(min(self.from, Self.maximumLines), 0) // restrict to valid values
        let to = min(max(self.to, 0),Self.maximumLines) // restrict to valid values

        func pointInRect(point: (CGFloat,CGFloat), length: Double = 1.0) -> CGPoint {
            return CGPoint(
            x: rect.maxX + (1.0 - point.0) * (rect.minX - rect.maxX) * CGFloat(length),
            y: rect.maxY + (1.0 - point.1) * (rect.minY - rect.maxY) * CGFloat(length)
            )
        }

        var path = Path()

        for index in from ..< to {
            let start = Self.lines[index].start
            let end = Self.lines[index].end
            path.move(to: pointInRect(point: start))
            if index < to - 1 {
                path.addLine(to: pointInRect(point: end))
            } else {
                if (animatingLastLine) {
                    path.addLine(to: pointInRect(point: end, length: self.lastLineLength))
                } else {
                    path.addLine(to: pointInRect(point: end))
                }
            }
        }
        return path
    }

}
struct TestLineShapeAnimation: View {

    @State var length = 1.0
    
    var body: some View {
//        LineShape(lastLineLength: length)
        LineShape(from: 0, to: 4, animatingLastLine: true)
            .stroke(Color.solid)
        .padding()
    }
}

struct LineShape_Previews: PreviewProvider {
    static var previews: some View {
        TestLineShapeAnimation()
    }
}
