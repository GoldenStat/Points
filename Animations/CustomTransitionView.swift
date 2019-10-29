//
//  CustomTransitionView.swift
//  Points
//
//  Created by Alexander Völz on 29.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier{
	var anchor: UnitPoint
	var amount: Double
	
	func body(content: Content) -> some View {
		content.rotationEffect(.degrees(amount), anchor: anchor)
		.clipped()
	}
	
}

extension AnyTransition {
	static var pivot: AnyTransition {
		.modifier(
			active: CornerRotateModifier(anchor: .topLeading, amount: 90),
			identity: CornerRotateModifier(anchor: .topLeading, amount: 0)
		)
	}
}

struct CustomTransitionView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
					.transition(.pivot)
    }
}

struct CustomTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTransitionView()
    }
}
