//
//  MatchesScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 29.09.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI

struct MatchesScoreView: View {
    var score: Score = Score(0)
    var body: some View {
        MatchBox(score: score)
    }
}

struct MatchBox: View {
    
    var score: Score
    
    let maxMatches = 5 // maximum matches is 5
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(1 ..< maxMatches) { count in
                    MatchView()
                        .opacity(opacity(for: score, matchNumber: count))
                }
            }
            
            HStack {
                ForEach(1 ..< maxMatches - 1) { count in
                    MatchView()
                        .opacity(0)
                }
                MatchView()
                    .opacity(opacity(for: score, matchNumber: 5))
                    .position()
                    .rotationEffect(.degrees(-70))
            }
        }
        .padding()
        
        Text("\(score.value) + \(score.buffer)")
            .fontWeight(.bold)
            .font(.system(size: 144))
            .opacity(0.2)
    }
    
    func opacity(for score: Score, matchNumber count: Int) -> Double {

        let fullOpacity : Double = 1.0
        let minOpacity : Double = 0.3

        if score.value >= count {
            return fullOpacity
        } else if score.sum >= count {
            return minOpacity
        }
        return 0
    }
}

let matchRatio : CGSize = CGSize(width: 0.2,
                                 height: 1.0)

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
        
        let circleRadius : CGFloat = rect.width * matchRatio.width
        
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
                          height: rect.height // * matchRatio.height)
        )
        
        let matchBodyRect = CGRect(x: centerX - size.width/2,
                                   y: rect.minY, //+ size.width * 1.8,
                                   width: size.width,
                                   height: size.height) // * 0.8)
        
        path.addRect(matchBodyRect)
        
        return path
    }
    
}

// MARK: - sample Views
struct AnimatedMatchBox: View {
    @State var score : Score = Score(0)
    
    var body: some View {
        ZStack {
            Color.background
            MatchBox(score: score)
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 1.0)) {
                score.add(points: 1)
            }
            if score.buffer > 3 {
                score.save()
            }
            if score.sum > 5 {
                score = Score(0)
            }
        }
    }
}


struct MatchesScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedMatchBox(score: Score(5))
            .frame(width: 400, height: 400)
    }
}
