//
//  Line.swift
//  Points
//
//  Created by Alexander Völz on 19.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct Line: View {
	let start: CGPoint
	let end: CGPoint
	var color = Color.black
	static var width = 2.0
	
	var body : some View {
		GeometryReader { geometry in
			Path { path in
				let width = min(geometry.size.width, geometry.size.height)
				let height = width
				path.move(to: CGPoint(
					x: self.start.x * width,
					y: self.start.y * height
				))
				path.addLine(to: CGPoint(
					x: self.end.x * width,
					y: self.end.y * height
				))
			}
			.stroke(self.color, style: StrokeStyle(lineWidth: CGFloat(Self.width)))
		}
	}
}

struct AnimatedLine: View {
	let start: CGPoint
	let end: CGPoint
	var color = Color.black
	@State private var t : Double = 1.0
	
	static var width = 2.0

	var body : some View {
		VStack {
			Button("length of line") {
				withAnimation {
					self.t += 0.5
				}
			}
		Path { path in
		path.move(to: CGPoint(
			x: self.start.x,
			y: self.start.y
		))
		path.addLine(to: CGPoint(
			x: self.start.x + (self.end.x - self.start.x) * CGFloat(t),
			y: self.end.y   + (self.end.y - self.start.y) * CGFloat(t)
		))
		}
		.stroke(self.color, style: StrokeStyle(lineWidth: CGFloat(Self.width)))
		.clipShape(Rectangle())
		.frame(width: self.end.x - self.start.x, height: self.end.y - self.start.y)
		}
//		.scaleEffect(t)
//		.animation(Animation.easeInOut(duration: 5))
	}
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
		AnimatedLine(start: CGPoint(x: 0.0, y: 100.0),
			 end: CGPoint(x: 100.0, y: 100.0))
    }
}
