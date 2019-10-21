//
//  BadgeSymbol.swift
//  Points
//
//  Created by Alexander Völz on 19.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BadgeSymbol: View {
	
	static let symbolColor = Color(red: 79.0 / 255, green: 79.0 / 255, blue: 191.0 / 255)
	
    var body: some View {
		GeometryReader { geometry in
			Path { path in
				let width = min(geometry.size.width, geometry.size.height)
				let height = width * 0.75
				let spacing = width * 0.030
				let middle = width / 2
				let topWidth = 0.226 * width
				let topHeight = 0.448 * width
				
				path.addLines([
					CGPoint(x: middle, y: spacing),
					.init(x: middle - topWidth, y: topHeight - spacing),
					CGPoint(x: middle, y: topHeight / 2 + spacing),
					CGPoint(x: middle + topWidth, y: topHeight - spacing),
					CGPoint(x: middle, y: spacing)
					])
			
				path.move(to: CGPoint(x: middle, y: topHeight / 2 - spacing * 3 ))
				path.addLines([
					.init(x: middle - topWidth, y: topHeight + spacing),
					.init(x: spacing, y: height - spacing),
					.init(x: width - spacing, y: height - spacing),
					.init(x: middle + topWidth, y: topHeight + spacing),
					.init(x: middle, y: topHeight / 2 + spacing * 3)
					])
				
			}.fill(Self.symbolColor)
		}
	}
}

struct BadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        BadgeSymbol()
    }
}
