//
//  Line.swift
//  Points
//
//  Created by Alexander Völz on 19.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Color {
    static let unchecked = Color(red: 235.0 / 255, green: 235.0 / 255, blue: 235.0 / 255).opacity(0.75)
    static let tmp = Color(red: 250.0 / 255, green: 50.0 / 255, blue: 50.0 / 255)
    static let solid = Color(red: 30.0 / 255, green: 30.0 / 255, blue: 30.0 / 255)
}

struct Lines : View {
    
    let from : Int
    let count : Int
    var color: Color = .solid
    
    @State private var length : Double = 0
    
    static let lines = [
        (start: (0.0, 1.0), end: (0.0, 0.0)),
        (start: (0.0, 1.0), end: (1.0, 1.0)),
        (start: (1.0, 1.0), end: (1.0, 0.0)),
        (start: (0.0, 0.0), end: (1.0, 0.0)),
        (start: (0.0, 0.0), end: (1.0, 1.0)),
        (start: (0.0, 1.0), end: (1.0, 0.0))
    ]
    
    static var maximumNumberOfLines : Int { get {
        return Self.lines.count - 1
        }
    }
    
    var animatableData : Double {
        get { return self.length }
        set { self.length = newValue }
    }
    
    var body: some View {
        
        let upperBound = Self.maximumNumberOfLines
        let from = max(0, min(upperBound, self.from))
        let count = max(0, min(upperBound - from, self.count))
        let to = min(upperBound, from + count)
        
        return
            GeometryReader { geometry in
                Path { path in
                    
                    let width = Double(min(geometry.size.width, geometry.size.height))
                    let height = width
                    
                    if to < from { return }
                    
                    for index in from ..< to {
                        let start = Self.lines[index].start
                        let end = Self.lines[index].end
                        path.move(to: CGPoint(
                            x: start.0 * width,
                            y: start.1 * height))
                        path.addLine(to: CGPoint(
                            x: end.0 * width,
                            y: end.1 * height))
                    }
                }
                .stroke(self.color, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .frame(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height))
        }
        
    }
}


struct Line_Previews: PreviewProvider {
    static var previews: some View {
        Lines(from: 0, count: 2, color: .black)
    }
}
