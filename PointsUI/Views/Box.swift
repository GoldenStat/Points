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

struct Box: View {
    var points : Int = 5
    var tmpPoints : Int
    static var maxCount = LineShape.maximumLinesIndex

    var body: some View {
        ZStack {
            LineShape(from: 0, to: Self.maxCount)
                .stroke(Color.unchecked)
            LineShape(from: 0, to: points)
                .stroke(Color.solid)
            LineShape(from: points, to: points + tmpPoints)
                .stroke(Color.tmp)
        }
    }
}

struct SampleBox: View {
    @State var points : Int = 0
    static var maxCount = LineShape.maximumLinesIndex

    var body: some View {
        ZStack {
            LineShape(from: 0, to: points)
                .stroke(Color.solid)
                .animation(.easeInOut(duration: 2.0))
        }
        .background(Color.green)
        .onTapGesture {
            self.points = self.points == 5 ? 0 :
                self.points + 1
        }
    }

}

struct Box_Previews: PreviewProvider {
    static var previews: some View {
        SampleBox()
            .frame(width: 300, height: 300)
            .padding()
    }
}
