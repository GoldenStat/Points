//
//  Line.swift
//  Points
//
//  Created by Alexander Völz on 19.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//


extension Color {
    static let unchecked = Color(red: 235.0 / 255, green: 235.0 / 255, blue: 235.0 / 255).opacity(0.75)
    static let tmp = Color(red: 250.0 / 255, green: 50.0 / 255, blue: 50.0 / 255)
    static let solid = Color(red: 30.0 / 255, green: 30.0 / 255, blue: 30.0 / 255)
}

import SwiftUI

struct Lines : View {
        
    static let lines = [
        (start: (0.0, 1.0), end: (0.0, 0.0)),
        (start: (0.0, 1.0), end: (1.0, 1.0)),
        (start: (1.0, 1.0), end: (1.0, 0.0)),
        (start: (0.0, 0.0), end: (1.0, 0.0)),
        (start: (0.0, 0.0), end: (1.0, 1.0)),
        (start: (0.0, 1.0), end: (1.0, 0.0))
    ]
    
    static var maximumNumberOfLines : Int { get {
        return Self.lines.count - 1
        }
    }
    
    let from : Int
    let to : Int
    var color: Color = .solid
    
    var body: some View {
        
        let upperBound = Self.maximumNumberOfLines
        let from = max(0,min(self.from,self.to))
        let to = min(upperBound,max(self.from,self.to))
        
        return
            GeometryReader { geometry in
                Path { path in
                    
                    let width = Double(min(geometry.size.width, geometry.size.height))
                    let height = width
                    
                    for index in from ..< to {
                        let start = Self.lines[index].start
                        let end = Self.lines[index].end
                        path.move(to: CGPoint(
                            x: start.0 * width,
                            y: start.1 * height))
                        path.addLine(to: CGPoint(
                            x: end.0 * width,
                            y: end.1 * height))
                    }
                }
                .stroke(self.color, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .frame(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height))
                    
        }
    }
}




struct Line: View {
	let start: CGPoint
	let end: CGPoint
	var color = Color.black
	static var lineWidth = 10.0
	
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
			.stroke(self.color, style: StrokeStyle(lineWidth: CGFloat(Self.lineWidth)))
		}
	}
}

struct AnimatedLine: View {
	let start: CGPoint
	let end: CGPoint
	var color = Color.black
	@State private var t : Double = 1.0
	
	static var lineWidth = 20.0

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
        .stroke(self.color, style: StrokeStyle(lineWidth: CGFloat(Self.lineWidth), lineCap: .round, lineJoin: .round))
		.clipShape(Rectangle())
		.frame(width: self.end.x - self.start.x, height: self.end.y - self.start.y)
		}
//		.scaleEffect(t)
//		.animation(Animation.easeInOut(duration: 5))
	}
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
//			Line(start:CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 1.0, y: 1.0))
        Lines(from: 0, to: 3, color: .tmp)
//		AnimatedLine(start: CGPoint(x: 0.0, y: 100.0),
//			 end: CGPoint(x: 100.0, y: 100.0))
    }
}
