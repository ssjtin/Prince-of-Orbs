//
//  EnemyStruct.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 10/10/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

struct Stage: Decodable {
    let name: String
    let imageName: String
    let attacks: [EnemyAttack]
    var targetScore: Int
    let counter: Int
}
