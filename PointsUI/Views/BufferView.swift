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
    let scoreSize: CGFloat = 144/2
    var scoreOpacity: Double { score.buffer > 0 ? 0.3 : 0.0 }
    @State var scaling: CGFloat = 2.0
    
    var body: some View {
        Text(score.buffer.description)
            .font(.system(size: scoreSize, weight: .semibold, design: .rounded))
            .opacity(scoreOpacity)
            .scaleEffect(scaling)
            .animation(.easeIn(duration: 1))
            .onAppear() {
                withAnimation {
                    scaling = 2.0
                }
            }
    }
}

struct BufferView_Previews: PreviewProvider {
    static var previews: some View {
        BufferView(score: Score(10, buffer: 8))
    }
}
