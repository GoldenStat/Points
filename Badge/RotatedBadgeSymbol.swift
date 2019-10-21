//
//  RotatedBadgeSymbol.swift
//  Points
//
//  Created by Alexander Völz on 19.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct RotatedBadgeSymbol: View {
	let angle: Angle
	
    var body: some View {
		BadgeSymbol()
			.padding(-60)
			.rotationEffect(angle, anchor: .bottom)
	}
}

struct RotatedBadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
		RotatedBadgeSymbol(angle: .init(degrees: 5))
    }
}
