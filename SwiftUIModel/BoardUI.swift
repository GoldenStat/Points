//
//  BoardUI.swift
//  Points
//
//  Created by Alexander Völz on 20.10.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import SwiftUI

struct BoardUI: View {
    var body: some View {
		VStack{
			HStack {
				PlayerScore(name: "Alexander")
				PlayerScore(name: "Lili")
			}
			HStack {
				PlayerScore(name: "Villa")
			}
		}
		.background(bgColor).opacity(50.0)
	}
	let bgColor = Color(red: 200 / 255.0, green: 200 / 255.0, blue: 255 / 255.0)
}

struct BoardUI_Previews: PreviewProvider {
    static var previews: some View {
        BoardUI()
    }
}
