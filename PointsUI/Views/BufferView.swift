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
    @State var scoreSize: CGFloat = 8
    var scoreOpacity: Double { score.buffer > 0 ? 0.3 : 0.0 }
    var body: some View {
        Text(score.buffer.description)
            .font(.system(size: scoreSize, weight: .semibold, design: .rounded))
            .opacity(scoreOpacity)
            .onAppear() {
                scoreSize = 144
            }
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
    }
}

struct BufferView_Previews: PreviewProvider {
    static var previews: some View {
        BufferView(score: Score(10, buffer: 8))
    }
}
