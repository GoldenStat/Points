//
//  Box.swift
//  Points
//
//  Created by Alexander Völz on 19.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

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
