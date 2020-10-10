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
    var maxScore : Int { overrideMaxScore ?? settings.maxPoints } // depends on game settings
    
    private let ratio : CGFloat = 1.0
    private let columns = 2 // make variable?

    // MARK: -- calculate points for each box
    private func matchBox(at index: Int) -> MatchBox {
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
            /// vertical matches
            HStack {
                ForEach(1 ..< MatchBox.maxItems) { count in
                    MatchView()
                        .opacity(opacity(matches: count))
                }
            }
            .padding()
            
            /// horizontal match (last one)
            GeometryReader { geo in
                HStack() {
                        Spacer()
                        MatchView()
                            .opacity(opacity(matches: MatchBox.maxItems))
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

    func opacity(matches: Int) -> Double {
        return score.value >= matches ? 1.0 :
            score.sum >= matches ? 0.3 : 0.0
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
        MatchesScoreView(score: Score(8, buffer: 8))
            .environmentObject(GameSettings())
    }
}
