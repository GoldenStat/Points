//
//  Constants.swift
//  Points
//
//  Created by Alexander Völz on 06.08.19.
//  Copyright © 2019 Alexander Völz. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
	
	struct Game {
		static let idleTime = 5
	}
	
	struct TextSize {
		static let playerName : CGFloat = 32
		static let gameScore : CGFloat = 38
		static let resetLabel : CGFloat = 32
	}

	struct PlayerUI {
		static let bgColor : UIColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8)
		static let nameSize : CGFloat = 26
		//		static let nameHeight : CGFloat = nameSize * 2.0
		static let margin : CGFloat = 10
		static let scoreFrameHeight : CGFloat = 200
		//static var height : CGFloat { get { return nameSize + margin + scoreFrameHeight } }
		static var height = CGFloat(290)
	}
	
	struct Button {
		static let bgColor : UIColor = PlayerUI.bgColor
	}
	
	struct ScoreButton {
		static let bgColor : UIColor = PlayerUI.bgColor
	}
	struct GameBoardView {
		static let bgColor : UIColor = PlayerUI.bgColor
	}
}

