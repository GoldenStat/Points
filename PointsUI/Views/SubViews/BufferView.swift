//
//  BufferView.swift
//  PointsUI
//
//  Created by Alexander Völz on 08.10.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BufferView: View {
    
    var score: Score
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Text(score.buffer.description)
            .font(.system(size: scoreSize, weight: .semibold, design: .rounded))
            .opacity(scoreOpacity)
            .scaleEffect(scale)
            .animation(.easeIn(duration: 0.5))
            .onAppear() {
                withAnimation {
                    scale = 2.0
                }
            }
    }
    
    private let scoreSize: CGFloat = 144/2
    private var scoreOpacity: Double { score.buffer != 0 ? 0.3 : 0.0 }
}

struct BufferView_Previews: PreviewProvider {
    static var previews: some View {
        BufferView(score: Score(10, buffer: -8))
    }
}
