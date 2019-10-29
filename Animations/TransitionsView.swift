//
//  TransitionsView.swift
//  Points
//
//  Created by Alexander Völz on 29.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct TransitionsView: View {
	@State var isShowing = true
	var border : UnitPoint = .init(x: 0.2, y: 0.6)
	var body: some View {
		VStack {
			Button("Tap Me") {
				withAnimation {
				self.isShowing.toggle()
				}
			}
			if isShowing {
			Text("Hello World")
				.foregroundColor(Color.red)
				.frame(width: 200, height: 200)
				.transition(.pivot)
			}
		}
	}
}

struct TransitionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionsView()
    }
}
