//
//  HapticsService.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-24.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit

func playHaptics(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}
