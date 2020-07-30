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
                .zIndex(1)
                .animation(nil)
            
            EdgeShape(totalLength: cappedTotal,
                      starting: cappedPoints)
                .stroke(Color.white,
                        style: strokeStyle)
                .colorMultiply(bufferColor)
        }
    }
    
    
    @State var bufferColor: Color = Color.pointbuffer
    
    let strokeStyle: StrokeStyle = .init(lineWidth: GlobalSettings.pointsLineWidth, lineCap: .round, lineJoin: .round)
    
}

// MARK: - sample Views
struct AnimatedBox: View {
    @State var points : Score = Score(0)
    
    var body: some View {
        ZStack {
            Background()
            Box(score: points)
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 1.5)) {
                points.add(points: 1)
            }
            if points.buffer > 5 {
                points.save()
            }
            if points.value > 5 {
                points = Score(0)
            }
        }
    }
}

struct Box_Previews: PreviewProvider {
    
    @State static var score = Score(2,buffer: 2)
    
    static var previews: some View {
        
        VStack {
            ZStack {
                Background()
                
                Box(score: score)
                    .frame(width: 300, height: 300)
                    .padding()
            }
            
            AnimatedBox()
                .padding()
        }
        .onTapGesture {
            if score.sum <= EdgeShape.numberOfEdges {
                score.add()
            }
        }        
    }
}
