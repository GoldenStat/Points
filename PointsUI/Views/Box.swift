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

/// a box that counts part of a score
/// - Parameters
/// - Parameter score: the current score the box has saved (drawn in Color.solid and Color.buffer)
/// - Parameter maxLength: the maximum Edges that will be used from EdgeShape
struct Box: View {
    var score : Score
    
    var cappedPoints : Double { min(Self.maxLength, Double(score.value)) }
    var cappedTotal : Double { min(Self.maxLength, Double(score.sum)) }
    
    static var maxLength : Double { Double(EdgeShape.numberOfEdges) - 1.0 }
    
    var body: some View {
        ZStack {
            EdgeShape(totalLength: Self.maxLength)
                .stroke(
                    Color.inactive,
                    style: strokeStyle)
                .zIndex(-1)
                .animation(nil)
            
            EdgeShape(totalLength: cappedPoints)
                .stroke(
                    Color.points,
                    style: strokeStyle)
                .animation(nil)
                .zIndex(1)
            
            EdgeShape(totalLength: cappedTotal,
                      starting: cappedPoints)
                .stroke(bufferColor,
                        style: strokeStyle)
        }
    }
    
    
    @State var bufferColor: Color = Color.pointbuffer
    
    let strokeStyle: StrokeStyle =
        .init(lineWidth: 5.0,
              lineCap: .round, lineJoin: .round)
    
}

// MARK: - sample Views
struct AnimatedBox: View {
    @State var score : Score = Score(0)
    @State var animatedColor = Color.pointbuffer
    
    var body: some View {
        ZStack {
            Color.background
            Box(score: score, bufferColor: animatedColor)
        }
        .onTapGesture {
            animatedColor = Color.pointbuffer
            withAnimation(.easeOut(duration: 1.0)) {
                score.add(points: 1)
                animatedColor = Color.points
            }
            if score.buffer > 5 {
                score.save()
            }
            if score.value > 5 {
                score = Score(0)
            }
        }
    }
}


struct Box_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBox()
            .frame(width: 200, height: 200)
    }
}
