//
//  EdgeView.swift
//  PointsUI
//
//  Created by Alexander Völz on 12.04.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

/// connect points as edges
///
///
/// *struct lines*
/// - TODO: the connetion point in Unit Points
/// start and endpoints scaled to a UnitRect
///
struct EdgeShape: Shape {
    
    /// where is the last point
    var totalLength: Double
    
    /// which is the first step
    var starting: Double = 0.0
    
    /// start
    private var index: Int { min(max(Int(totalLength), 0), Self.numberOfEdges - 1) }
    
    var animatableData: Double {
        get { totalLength }
        set { totalLength = newValue }
    }
    
    private static let edges : [(start: (CGFloat,CGFloat), end: (CGFloat,CGFloat))] = [
        (start: (0.0, 1.0), end: (0.0, 0.0)),
        (start: (0.0, 0.0), end: (1.0, 0.0)),
        (start: (0.0, 1.0), end: (1.0, 1.0)),
        (start: (1.0, 1.0), end: (1.0, 0.0)),
        (start: (0.0, 0.0), end: (1.0, 1.0)),
        (start: (0.0, 1.0), end: (1.0, 0.0)),
    ]
    
//    private static let HouseEdges : [(start: (CGFloat,CGFloat), end: (CGFloat,CGFloat))] = [
//        (start: (0.0, 0.3), end: (0.0, 1.0)),
//        (start: (0.0, 0.3), end: (1.0, 0.3)),
//        (start: (0.0, 1.0), end: (1.0, 1.0)),
//        (start: (1.0, 1.0), end: (1.0, 0.3)),
//        (start: (0.0, 0.3), end: (1.0, 1.0)),
//        (start: (0.0, 1.0), end: (1.0, 0.3)),
//        (start: (0.0, 0.3), end: (0.5, 0.0)),
//        (start: (0.5, 0.0), end: (1.0, 0.3))
//    ]

    static var numberOfEdges : Int { edges.count }
    
    /// translate a relative Point from our corners to a CGPoint in our View
    private func cornerPoint(point: (CGFloat,CGFloat), in rect: CGRect) -> CGPoint {
        return CGPoint(
            x: rect.maxX + (1.0 - point.0) * (rect.minX - rect.maxX),
            y: rect.maxY + (1.0 - point.1) * (rect.minY - rect.maxY)
        )
    }
    
    /// calculate one edge to be drawn animated
    private func edge(_ edge: Int, in rect: CGRect, length: Double = 1.0) -> Path {
        
        let start = cornerPoint(point: Self.edges[edge].start, in: rect)
        let end = cornerPoint(point: Self.edges[edge].end, in: rect)
        
        let x = start.x + ( end.x - start.x ) * CGFloat(length)
        let y = start.y + ( end.y - start.y ) * CGFloat(length)
        
        let toPoint = CGPoint(x: x, y: y)
        var path = Path()
        
        path.move(to: start)
        path.addLine(to: toPoint)
        
        return path
    }
    
    /// combine edges from the startpoint to the last edge
    private func edges(length: Double, in rect: CGRect) -> Path {
        let remainingLength = totalLength - Double(index)
        
        var path = Path()
        let start = min(max(0,Int(starting)),index)

        for edgeIndex in start ..< index {
            path.addPath(edge(edgeIndex, in: rect))
        }

        path.addPath(edge(index, in: rect, length: remainingLength))
        return path
    }
    
    func path(in rect: CGRect) -> Path {
        if totalLength > 0 {
        return edges(length: totalLength, in: rect)
        } else {
            return Path()
        }
    }
    
}

// MARK: - sample views
struct EdgeSampleView: View {
    
    @State var index : Double = 6
    
    var body: some View {
        ZStack {
            Color.background
            
            EdgeShape(totalLength: index)
                .stroke(Color.points,
                        style: StrokeStyle(
                            lineWidth: edgeWidth,
                            lineCap:  .round,
                            lineJoin: .round))
                .padding()
            
//            Text(index.description)
        }
        .onTapGesture {
            if Int(self.index) + 1 > maxEdges {
                index = 0
            } else {
                withAnimation(.easeOut(duration: 1.0)) {
                    index += 1
                }
            }
        }
    }
    
    private let maxEdges = 8
    private let edgeWidth : CGFloat = 5.0
}

struct EdgeView_Previews: PreviewProvider {
    static var previews: some View {
        EdgeSampleView()
    }
}
