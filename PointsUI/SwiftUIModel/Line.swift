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


struct Line_Previews: PreviewProvider {
    static var previews: some View {
		Line(start: CGPoint(x: 0.0, y: 1.0),
			 end: CGPoint(x: 1.0, y: 1.0))
    }
}
