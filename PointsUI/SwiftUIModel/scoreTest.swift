//
//  scoreTest.swift
//  PointsUI
//
//  Created by Alexander Völz on 23.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct ScoreButton: View, Identifiable {
	var id = UUID()
	@State var score = 0
	var body: some View {
		HStack {
			Button(action: { self.score += 1 }) {
					Text("Score: \(score)")
			}
			Button(action: {self.score = 0 }) {
				Text("reset")
			}
		}
	}
}

struct myView: View {
	@State var buttons = [ ScoreButton(score: 0) ]
	@State var button = ScoreButton(score: 0)
	@State private var date: Date = Date()
	var body: some View {
		VStack {
			ForEach(buttons) { button in
				button
			}
			button
			Button("reset all scores") {
				self.buttons = [ ScoreButton(score: 0) ]
				self.button = ScoreButton(score: 0)
			}
		}
	}
}

struct PickerView : View {
	@State private var wakeUp = Date()
	
	var body: some View {
		Form {
			DatePicker("enter Date:", selection: $wakeUp, displayedComponents: .hourAndMinute)
//		.labelsHidden()
		}
	}
}

struct score_Previews: PreviewProvider {
	static var previews : some View {
		PickerView()
	}
}
