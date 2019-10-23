//
//  Box.swift
//  Points
//
//  Created by Alexander Völz on 19.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI


struct Box : View {
	static let maxNumberOfLines = 5

	public var score = 0 { didSet {
		if score < 0 { score = 0 }
		if score > Box.maxNumberOfLines { score = Box.maxNumberOfLines }
		}}
	public var tmpScore = 0 { didSet {
		if tmpScore < 0 { tmpScore = 0 }
		if tmpScore > Box.maxNumberOfLines - score { tmpScore = Box.maxNumberOfLines - score }
		}}
		
	static let uncheckedColor = Color(red: 235.0 / 255, green: 235.0 / 255, blue: 235.0 / 255)
	static let tmpColor = Color(red: 250.0 / 255, green: 50.0 / 255, blue: 50.0 / 255)
	static let solidColor = Color(red: 30.0 / 255, green: 30.0 / 255, blue: 30.0 / 255)
	
	static let lines = [
		(start: (0.0, 1.0), end: (0.0, 0.0)),
		(start: (0.0, 1.0), end: (1.0, 1.0)),
		(start: (1.0, 1.0), end: (1.0, 0.0)),
		(start: (0.0, 0.0), end: (1.0, 0.0)),
		(start: (0.0, 0.0), end: (1.0, 1.0)),
		(start: (0.0, 1.0), end: (1.0, 0.0))
	]

	func start(for index: Int) -> CGPoint {
		return CGPoint(x: Self.lines[index].start.0, y: Self.lines[index].start.1)
	}
	func end(for index: Int) -> CGPoint {
		return CGPoint(x: Self.lines[index].end.0, y: Self.lines[index].end.1)
	}

	var body: some View {
			
		return
			ZStack {
				ForEach(0..<Box.maxNumberOfLines) { i in
					if i < self.score {
						Line(
							start: self.start(for: i),
							end: self.end(for: i),
							color: Box.solidColor
						)
					} else if i < self.score + self.tmpScore {
						Line(
							start: self.start(for: i),
							end: self.end(for: i),
							color: Box.tmpColor
						)
					} else {
						Line(
							start: self.start(for: i),
							end: self.end(for: i),
							color: Box.uncheckedColor
						)
					}
				}
		}
	}
}


struct Box_Previews: PreviewProvider {
    static var previews: some View {
		Box(score: 2, tmpScore: 8)
			.padding()
    }
}
