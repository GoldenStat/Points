//
//  BufferSpaceDebugView.swift
//  PointsUI
//
//  Created by Alexander Völz on 04.12.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BufferSpaceDebugView: View {
    var bufferSpace: BufferSpace?
    
    var body: some View {
        VStack {
            Spacer()
            if let buffer = bufferSpace {
                Text("Buffer value: \(buffer.points)")
                    .foregroundColor(.blue)
                Text("Position: ".appendingFormat("<%3.0f/%3.0f>", buffer.position.x, buffer.position.y))
                    .foregroundColor(.green)
            } else {
                Text("Buffer not active")
                    .foregroundColor(.red)
            }
        }
    }
}

struct BufferSpaceDebugView_Previews: PreviewProvider {
    static var previews: some View {
        BufferSpaceDebugView(bufferSpace: BufferSpace(position: .zero, points: 0))
    }
}
