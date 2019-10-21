//
//  Badge.swift
//  Points
//
//  Created by Alexander Völz on 19.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct Badge: View {
	static let rotationCount = 8
	
	var badgeSymbols : some View {
		ForEach(0 ..< Badge.rotationCount) { i in
			RotatedBadgeSymbol(
				angle: .degrees(Double(i) / Double(Badge.rotationCount)) * 360.0
			)
		}.opacity(0.5)
	}
	
    var body: some View {
		ZStack {
			BadgeBackground()
			
			GeometryReader { geometry in
				self.badgeSymbols
					.scaleEffect(0.25, anchor: .top)
					.position(x: geometry.size.width / 2.0,
							  y: geometry.size.height * 0.75)
			}
		}
		.scaledToFit()
	}
}

struct Badge_Previews: PreviewProvider {
	static var previews: some View {
		Badge()
	}
}
