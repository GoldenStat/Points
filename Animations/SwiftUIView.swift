//
//  SwiftUIView.swift
//  PointsUI
//
//  Created by Alexander Völz on 26.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {

	let letters = Array("Hello SwiftUI")
	@State private var enabled = false
	@State private var dragAmount = CGSize.zero
	private var distance : CGFloat { get { return  sqrt(dragAmount.height*dragAmount.height + dragAmount.width*dragAmount.width) }}
	private var isMoving : Bool { get { dragAmount != CGSize.zero }}
	
	var body: some View {
		HStack(spacing: 0) {
			ForEach(0 ..< letters.count) { num in
				Text(String(self.letters[num]))
					.padding(5)
					.font(.title)
					.background(self.enabled ? Color.blue : Color.red)
					.clipShape(RoundedRectangle(cornerRadius: CGFloat(self.isMoving ? 80 : 0)) )
					.rotation3DEffect(Angle(degrees: self.enabled ? 0 : Double( self.distance)), axis: (x: 0.0, y: 1.0, z: 0.0))
					.offset(self.dragAmount)
					.animation(Animation.default.delay(Double(num) / 20))
			}
		}
		.gesture(
			DragGesture()
				.onChanged {
					self.dragAmount = $0.translation
					self.enabled.toggle()
			}
			.onEnded { _ in
				self.dragAmount = .zero
				self.enabled.toggle()
			}
		)
	}
}

struct SwiftUIView_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUIView()
	}
}
