//
//  MatchesScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 29.09.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct MatchesScoreView: View {
    var score: Score = Score(2, buffer: 2)
    var body: some View {
        HStack {
            ForEach (0 ..< score.value) { _ in
                MatchView()
            }
            ForEach (0 ..< score.buffer) { _ in
                MatchView()
                    .opacity(0.3)
            }
        }
        .frame(width: 400, height: 400)
    }
}

let matchRatio : CGSize = CGSize(width: 0.2,
                                 height: 0.8)

struct MatchView: View {
    let bodyColor = Color.yellow
    let headColor = Color.red

    var body: some View {
        ZStack {
            MatchBodyShape()
                .fill(bodyColor)
            MatchHeadShape()
                .fill(headColor)
        }
    }
}

struct MatchHeadShape: Shape {
    
    func path(in rect: CGRect) -> Path {

        var path = Path()
   
        let centerX = rect.minX + rect.width / 2
        let size = CGSize(width: rect.width * matchRatio.width,
                          height: rect.height * matchRatio.height)

        let circleRadius : CGFloat = size.width
        
        let circleCenter = CGPoint(x: centerX,
                                   y: circleRadius)
        
        let flatSide = Angle(degrees: 90)
        let flatWidthHalf = Angle(degrees: 30)

        path.addArc(center: circleCenter, radius: circleRadius,
               startAngle: flatSide - flatWidthHalf,
               endAngle: flatSide + flatWidthHalf,
               clockwise: true)
        path.closeSubpath()

        return path
    }
    
}

struct MatchBodyShape: Shape {
        
    func path(in rect: CGRect) -> Path {

        var path = Path()
   
        let centerX = rect.minX + rect.width / 2
        let size = CGSize(width: rect.width * matchRatio.width,
                          height: rect.height * matchRatio.height)
        
        let matchBodyRect = CGRect(x: centerX - size.width/2,
                                   y: rect.minY + size.width * 1.8,
                                   width: size.width,
                                   height: size.height)
        
        path.addRect(matchBodyRect)
        
        return path
    }
    
}


struct MatchesScoreView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesScoreView()
    }
}
