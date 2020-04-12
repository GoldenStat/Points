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
/// - Parameter points: the current points the box has saved (drawn in Color.solid)
/// - Parameter tmpPoints: the points that are not yet added, but marked to add (drawn in Color.tmp)
/// - Parameter maxLength: the maximum Edges that will be used from EdgeShape
struct Box: View {

    var points : Int
    var tmpPoints : Int

    var cappedPoints : Double { min(Self.maxLength, Double(points)) }
    var cappedTotal : Double { min(Self.maxLength, Double(points+tmpPoints)) }
    
//    static var maxLength : Double { Double(EdgeShape.numberOfEdges) }
    static var maxLength : Double { Double(EdgeShape.numberOfEdges) - 1}
    
    var body: some View {
        ZStack {
            EdgeShape(totalLength: Self.maxLength)
                .stroke(Color.unchecked)
            EdgeShape(totalLength: cappedPoints)
                .stroke(Color.solid)
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

    @State static var tmpPoints = 2
    static let points = 2
    
    static var previews: some View {
        Box(points: Self.points, tmpPoints: Self.tmpPoints)
            .frame(width: 300, height: 300)
            .padding()
            .onTapGesture {
                if tmpPoints > 5 - Self.points {
                    tmpPoints = Self.points
                } else {
                    tmpPoints += 1
                }
        }
    }
}
