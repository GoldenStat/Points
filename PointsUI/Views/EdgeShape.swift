//
//  EdgeView.swift
//  PointsUI
//
//  Created by Alexander Völz on 12.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// Color extensions for EdgeShape colors
extension Color {
    static let unchecked =
        Color.inactive
//    Color(red: 235.0 / 255, green: 235.0 / 255, blue: 235.0 / 255).opacity(0.75)
////    static let buffer = Color(red: 250.0 / 255, green: 50.0 / 255, blue: 50.0 / 255)
    static let solid = Color.text // Color(red: 30.0 / 255, green: 30.0 / 255, blue: 30.0 / 255)
}

struct EdgeShape: Shape {
    
    var totalLength: Double
    var starting: Double = 0.0
    
    private var index: Int { min(max(Int(totalLength), 0), Self.lines.count - 1) }
    
    var animatableData: Double {
        get { totalLength }
        set { totalLength = newValue }
    }
    
    private static let lines : [(start: (CGFloat,CGFloat), end: (CGFloat,CGFloat))] = [
        (start: (0.0, 1.0), end: (0.0, 0.0)),
        (start: (0.0, 0.0), end: (1.0, 0.0)),
        (start: (0.0, 1.0), end: (1.0, 1.0)),
        (start: (1.0, 1.0), end: (1.0, 0.0)),
        (start: (0.0, 0.0), end: (1.0, 1.0)),
        (start: (0.0, 1.0), end: (1.0, 0.0))
    ]
    
    static var numberOfEdges : Int { lines.count }
    
    /// translate a relative Point from our corners to a CGPoint in our View
    private func cornerPoint(point: (CGFloat,CGFloat), in rect: CGRect) -> CGPoint {
        return CGPoint(
            x: rect.maxX + (1.0 - point.0) * (rect.minX - rect.maxX),
            y: rect.maxY + (1.0 - point.1) * (rect.minY - rect.maxY)
        )
    }
    
    private func edge(_ edge: Int, in rect: CGRect, length: Double = 1.0) -> Path {
        
        let start = cornerPoint(point: Self.lines[edge].start, in: rect)
        let end = cornerPoint(point: Self.lines[edge].end, in: rect)
        
        let x = start.x + ( end.x - start.x ) * CGFloat(length)
        let y = start.y + ( end.y - start.y ) * CGFloat(length)
        
        let toPoint = CGPoint(x: x, y: y)
        var path = Path()
        
        path.move(to: start)
        path.addLine(to: toPoint)
        
        return path
    }
    
    private func edges(length: Double, in rect: CGRect) -> Path {
        let remainingLength = totalLength - Double(index)
        
        var path = Path()
        let start = max(0,Int(starting))
        guard (index > start) else { return Path() }
        for counter in start ..< index {
            path.addPath(edge(counter, in: rect))
        }
        path.addPath(edge(index, in: rect, length: remainingLength))
        return path
    }
    
    func path(in rect: CGRect) -> Path {
        return edges(length: totalLength, in: rect)
    }
    
}

// MARK: - sample views
struct EdgeView: View {
    
    @State var index = 0
    var length : Double { Double(index) }
    
    var body: some View {
        EdgeShape(totalLength: length, starting: 1.0)
            .stroke(Color.solid, style: StrokeStyle(lineCap: .round,lineJoin: .round))
            .padding()
            .background(Color.gray)
            .animation(.default)
            .onTapGesture {
                self.index += 1
                if self.index > 5 {
                    self.index = 0
                }
        }
    }
}

struct EdgeView_Previews: PreviewProvider {
    static var previews: some View {
        EdgeView()
    }
}
