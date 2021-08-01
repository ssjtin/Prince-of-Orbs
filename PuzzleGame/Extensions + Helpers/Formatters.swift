//
//  Formatters.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 1/8/21.
//  Copyright © 2021 Hoang Luong. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static let secondsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()
}
