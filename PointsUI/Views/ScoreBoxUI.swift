//
//  PlayerView.swift
//  Points
//
//  Created by Alexander Völz on 18.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

extension Double { static var lineAnimationSpeed = 0.2}

struct ScoreBoxUI: View, Identifiable {
    // public vars
    @ObservedObject var settings : GameSettings
    
    var players : Players {
        return settings.players
    }

    var player : Player
    var id: Player.ID { player.id }
            
    func saveScore() {
        if tmpScore > 0 {
            score += tmpScore
            tmpScore = 0
        }
    }
        
    @State private var score : Int = 0 {
        didSet {
            for (index,player) in settings.players.items.enumerated() {
                if player.id == self.player.id {
                    settings.players.items[index].score = self.score
                }
            }
        }
    }
    
    @State private var tmpScore : Int = 0
    
//    var publicScore : Int { self.score }
    
    static let maxScore = 24
    static let columns = 2
    static let linesPerBox = Int(Box.maxLength)
    
    static var numberOfBoxes : Int { get {
        let overlay = Self.maxScore % Self.linesPerBox
        let ratio = Self.maxScore / Self.linesPerBox
        return ratio + (overlay > 0 ? 1 : 0)
        } }
    
    public func reset() {
        score = 0
        tmpScore = 0
    }
    
    private func filledBox(at index: Int) -> Box {
        // count points and tmp points to what should be in this box
        
        let start = index * Self.linesPerBox
        let end = start + Self.linesPerBox
        var thisBoxScore = 0
        var thisBoxTmpScore = 0
        
        for point in start ... end {
            if point < score {
                thisBoxScore += 1
            } else if point < score + tmpScore {
                thisBoxTmpScore += 1
            }
        }
        
        return Box(points: thisBoxScore, tmpPoints: thisBoxTmpScore)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Puntos: \(score)")
                if tmpScore > 0 {
                    Text(" + ")
                    Text("\(tmpScore)")
                }
            }
            Button(action: {
                if self.score + self.tmpScore < Self.maxScore {
                    self.tmpScore += 1
                }
            })
            {
                FlowStack(columns: Self.columns, numItems: Self.numberOfBoxes) { index, colWidth in
                    self.filledBox(at: index)
                        .padding()
                        .frame(width: colWidth)
                        .animation(.easeInOut(duration: .lineAnimationSpeed))
                }.aspectRatio(0.7, contentMode: .fit)
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoxUI(settings: GameSettings(), player: Player(name: "Alexander"))
    }
}
