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
    var overrideMaxScore : Int?
    
    var numberOfBoxes : Int {
        let remainder = maxScore % maxItems
        let full = maxScore / maxItems
        return full + (remainder > 0 ? 1 : 0)
        }
    
    var vGrid: [GridItem] { [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ] }
        
    var body: some View {
        LazyVGrid(columns: vGrid) {
            ForEach(0 ..< numberOfBoxes) { index in
                matchBox(at: index)
                    .animation(.easeInOut(duration: .lineAnimationSpeed))
                    .aspectRatio(ratio, contentMode: .fit)
            }
        }
    }
    
    // MARK: -- constants
    var maxScore : Int { min(Self.MAXScore, overrideMaxScore ?? settings.maxPoints) } // depends on game settings
    static let MAXScore = 30
    
    private let ratio : CGFloat = 1.0
    private let columns = 2 // make variable?

    // MARK: -- calculate points for each box
    private func matchBox(at index: Int) -> some View {
        // count points and buffer points to what should be in this box
        func adjustedScore(from score: Score, at index: Int) -> Score {
            let thisBoxStartsAt = index * MatchBox.maxItems
            let boxValue = max(0, score.value - thisBoxStartsAt)
            let boxBuffer = score.sum - thisBoxStartsAt - boxValue
                                
            return Score(boxValue, buffer: boxBuffer)
        }

        return MatchBox(score: adjustedScore(from: score, at: index))
    }
}

struct MatchBox: View {
    
    var score: Score
    
    static let maxItems = 5 // maximum matches are 5
        
    var body: some View {
        ZStack {
            GeometryReader { geo in

                /// vertical matches
                HStack(spacing: 0) {
                    ForEach(1 ..< MatchBox.maxItems) { count in
                        MatchView()
                            .opacity(opacity(forMatch: count))
                            .frame(width: geo.size.width / CGFloat(MatchBox.maxItems-1))
                    }
                }
                
                
                /// horizontal match (last one)
                HStack() {
                    Spacer()
                    MatchView()
                        .opacity(opacity(forMatch: MatchBox.maxItems))
                        .frame(width: geo.size.width / CGFloat(MatchBox.maxItems-1),
                               height: geo.size.height * 1.3)
                        .rotationEffect(.degrees(degrees), anchor: UnitPoint(x: 0.5, y: 0.3))
                        .offset(x: -geo.size.width * CGFloat(0.25))
                        .onAppear() {
                            degrees = -80
                        }
                        .animation(Animation.spring(response: 0.8, dampingFraction: 0.2, blendDuration: 0.4))
                    Spacer()
                }
            }
            .padding()
            .padding()
        }
    }

    @State var degrees : Double = 0

    func opacity(forMatch match: Int) -> Double {
        return score.value >= match ? 1.0 :
            score.sum >= match ? 0.3 : 0.0
    }
    
    func offset(forMatch match: Int, with size: CGSize) -> CGSize {
        let deltaX = size.width / CGFloat(MatchBox.maxItems*2)
        return CGSize(width: -size.width / CGFloat(2) + deltaX * CGFloat(match),
                      height: 0)
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
        MatchesScoreView(score: Score(8, buffer: 8), overrideMaxScore: 24)
            .environmentObject(GameSettings())
    }
}
