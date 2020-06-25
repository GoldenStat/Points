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
/// - Parameter score: the current score the box has saved (drawn in Color.solid and Color.tmp)
/// - Parameter maxLength: the maximum Edges that will be used from EdgeShape
struct Box: View {

    var score : Score

    var cappedPoints : Double { min(Self.maxLength, Double(score.value)) }
    var cappedTotal : Double { min(Self.maxLength, Double(score.sum)) }
    
    static var maxLength : Double { Double(EdgeShape.numberOfEdges) - 1 }
    
    var body: some View {
        ZStack {
            EdgeShape(totalLength: Self.maxLength)
                .stroke(Color.unchecked)
                .animation(nil)
            EdgeShape(totalLength: cappedPoints)
                .stroke(Color.solid)
                .animation(nil)
            EdgeShape(totalLength: cappedTotal, starting: cappedPoints)
                .stroke(Color.tmp)
        }
    }
}

struct SampleBox: View {
    @State var points : Int = 0
    
    var body: some View {
        ZStack {
            EdgeShape(totalLength: Double(points))
                .stroke(Color.solid)
                .animation(.easeInOut(duration: 1.0))
        }
        .background(Color.green)
        .onTapGesture {
            self.points = self.points == 5 ? 0 :
                self.points + 1
        }
    }
    
}

struct Box_Previews: PreviewProvider {
    
    @State static var score = Score(2,tmp: 2)
    
    static var previews: some View {
        Box(score: score)
            .frame(width: 300, height: 300)
            .padding()
            .onTapGesture {
                if score.sum <= EdgeShape.numberOfEdges {
                    score.add()
                }
            }
    }
}
