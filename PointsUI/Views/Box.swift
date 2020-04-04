//
//  Box.swift
//  Points
//
//  Created by Alexander Völz on 19.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

extension CGPoint {
    init(_ point: (Double,Double)) {
        self.init(x: point.0, y: point.1)
    }
    
    static func * (origin: CGPoint, multiplier: CGFloat) -> CGPoint {
        return CGPoint(x: origin.x * multiplier, y: origin.y * multiplier)
    }
}

struct LineShape: Shape {
    
    /// values bigger than number are ignored
    static var maximumLines = Self.lines.count - 1

    var from: Int = 0
    var to: Int = Self.maximumLines
    var animatingLastLine = false
    
    @State private var lastLineLength : CGFloat = 1.0
    
    var animatableData : CGFloat {
        get { return self.lastLineLength }
        set { self.lastLineLength = newValue }
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

        let from = max(min(self.from, Self.maximumLines), 0)
        let to = min(max(self.to, 0),Self.maximumLines)
        
        func pointInRect(point: (CGFloat,CGFloat), length: CGFloat = 1.0) -> CGPoint {
            return CGPoint(
            x: rect.maxX + (1.0 - point.0) * (rect.minX - rect.maxX) * length,
            y: rect.maxY + (1.0 - point.1) * (rect.minY - rect.maxY) * length
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

struct Box: View {
    
    var points : Int = 5
    var tmpPoints : Int
    static var maxCount = LineShape.maximumLines

    var body: some View {
        ZStack {
            LineShape(from: 0, to: Self.maxCount)
                .stroke(Color.unchecked)
            LineShape(from: 0, to: points)
                .stroke(Color.solid)
            LineShape(from: points, to: points + tmpPoints, animatingLastLine: true)
                .stroke(Color.tmp)
        }
    }
}

struct Box_Previews: PreviewProvider {
    static var previews: some View {
        Box(points: 3, tmpPoints: 2)
            .frame(width: 300, height: 300)
            .padding()
    }
}
