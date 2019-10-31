//
//  PlayerView.swift
//  Points
//
//  Created by Alexander Völz on 18.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ScoreBoxUI: View, Identifiable {
	@ObservedObject var player : Player

	var id = UUID()

	static var timer : Timer.TimerPublisher = Timer.publish(every: 5, on: .main, in: .common)
	@State private var saveTimer = Self.timer.autoconnect()
	@State private var score : Int = 0 {
		didSet {
			player.points = score
		}
	}
	@State private var tmpScore : Int = 0
		
	var publicScore : Int { get { return self.score } }
	
	static let maxScore = 24
	static let columns = 2
	static let linesPerBox = Box.maxNumberOfLines
	
	static var numberOfBoxes : Int { get {
		let overlay = Self.maxScore % Self.linesPerBox
		let ratio = Self.maxScore / Self.linesPerBox
		return ratio + (overlay > 0 ? 1 : 0)
		} }
	
	public func reset() {
		score = 0
	}
	
	private func filledBox(at index: Int) -> Box {
		return Box(score: score - Self.linesPerBox * index, tmpScore: tmpScore)
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
			Button(action:  {
				if self.score + self.tmpScore < Self.maxScore {
					self.tmpScore += 1
					self.saveTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
				}
			})
			{
				FlowStack(columns: Self.columns, numItems: Self.numberOfBoxes) { index, colWidth in
					self.filledBox(at: index)
						.padding()
						.frame(width: colWidth)
				}.aspectRatio(0.7, contentMode: .fit)
			}
			.onReceive(self.saveTimer) { input in
                if self.tmpScore > 0 {
                    self.score += self.tmpScore
                    self.tmpScore = 0
                }
			}
		}
	}
}

struct PlayerView_Previews: PreviewProvider {
	static var previews: some View {
		ScoreBoxUI(player: Player(name: "Alexander"))
	}
}
