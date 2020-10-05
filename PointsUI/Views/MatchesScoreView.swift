//
//  MatchesScoreView.swift
//  PointsUI
//
//  Created by Alexander Völz on 29.09.20.
//  Copyright © 2020 Alexander Völz. All rights reserved.
//

import SwiftUI


/// the UI with a collection of Boxes and maximum score
struct MatchesScoreView: View {
    @EnvironmentObject var settings: GameSettings
    
    let id = UUID()
    var score: Score
    let maxItems = MatchBox.maxItems
    
    var numberOfBoxes : Int {
        let remainder = maxScore % maxItems
        let full = maxScore / maxItems
        return full + (remainder > 0 ? 1 : 0)
        }
    
    var body: some View {
        FlowStack(columns: columns,
                  numItems: numberOfBoxes) { index, colWidth in
            matchBox(at: index)
                .padding()
                .frame(width: colWidth)
                .animation(.easeInOut(duration: .lineAnimationSpeed))
                .aspectRatio(ratio, contentMode: .fit)
        }
    }
    
    // MARK: -- constants
    var maxScore : Int { settings.maxPoints } // depends on game settings
    
    private let ratio : CGFloat = 1.0
    private let columns = 2 // make variable?

    // MARK: -- calculate points for each box
    private func matchBox(at index: Int) -> MatchBox {
        // count points and buffer points to what should be in this box
        
        let start = index * MatchBox.maxItems
        let end = start + MatchBox.maxItems
        var thisBoxScore = Score()
        
        for point in start ... end {
            if point < score.value {
                thisBoxScore.value += 1
            } else if point < score.sum {
                thisBoxScore.add()
            }
        }
        
        return MatchBox(score: thisBoxScore)
    }
}

struct MatchBox: View {
    
    var score: Score
    
    static let maxItems = 5 // maximum matches are 5
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(1 ..< MatchBox.maxItems) { count in
                    MatchView()
                        .opacity(opacity(for: score, matchNumber: count))
                }
            }
            .padding()

            
            GeometryReader { geo in
                HStack() {
                    Spacer()
                    MatchView()
                        .opacity(opacity(for: score, matchNumber: MatchBox.maxItems))
                        .frame(width: geo.size.width / CGFloat(MatchBox.maxItems))
                        .rotationEffect(.degrees(degrees))
                        .onAppear() {
                            degrees = -80
                        }
                        .animation(.spring(response: 0.6, dampingFraction: 0.3, blendDuration: 0.4))

                    Spacer()
                }
            }
        }
    }

    @State var degrees : Double = 0
    
    func opacity(for score: Score, matchNumber count: Int) -> Double {

        let fullOpacity : Double = 1.0
        let bufferOpacity : Double = 0.3

        if score.value >= count {
            return fullOpacity
        } else if score.sum >= count {
            return bufferOpacity
        }
        return 0 // invisible
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
        MatchesScoreView(score: Score(14))
            .environmentObject(GameSettings())
//        AnimatedMatchBox(score: Score(5))
//            .frame(width: 300, height: 300)
    }
}
