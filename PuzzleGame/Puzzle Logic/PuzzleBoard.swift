//
//  Level.swift
//  TinsGame
//
//  Created by Hoang Luong on 22/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//
//  The level class handles the logic behind populating orbs, matching orbs, refilling orbs, etc.

import SpriteKit

let numColumns = 6
let numRows = 5

class PuzzleBoard {
    
    let puzzleNode = SKNode()
    let tilesLayer = SKNode()
    let orbsLayer = SKNode()
    
    var orbs = Array2D<Orb>(columns: numColumns, rows: numRows)
    
    init() {
        addTiles()
        let newOrbs = shuffle()
        addSprites(for: newOrbs)
        puzzleNode.addChild(tilesLayer)
        puzzleNode.addChild(orbsLayer)
    }
    
    func refreshBoard() {
        orbs.allItems.forEach { (orb) in
            orb.sprite?.removeFromParent()
        }
        let newOrbs = shuffle()
        addSprites(for: newOrbs)
    }
    
    private func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * tileWidth + tileWidth / 2,
            y: CGFloat(row) * tileHeight + tileHeight / 2)
    }
    
    func addTiles() {
        for column in 0..<numColumns {
            for row in 0..<numRows {
                let tile = SKSpriteNode(imageNamed: "background_tile")
                tile.size = CGSize(width: tileWidth, height: tileHeight)
                tile.position = pointFor(column: column, row: row)
                tilesLayer.addChild(tile)
                
                if (column+row).isMultiple(of: 2) {
                    tile.alpha = 0.25
                } else {
                    tile.alpha = 0.5
                }
            }
        }
    }
    
    func addSprites(for orbs: Set<Orb>) {
        for orb in orbs {
            addSprite(for: orb)
        }
    }
    
    func addSprite(for orb: Orb) {
        let sprite = SKSpriteNode(imageNamed: orb.spriteName)
        sprite.size = CGSize(width: tileWidth, height: tileHeight)
        sprite.position = pointFor(column: orb.column, row: orb.row)
        orbsLayer.addChild(sprite)
        orb.sprite = sprite
    }
    
    func orb(atColumn column: Int, row: Int) -> Orb? {
        precondition(column>=0 && column<numColumns)
        precondition(row>=0 && row<numRows)
        return orbs[column, row]
    }
    
    func shuffle() -> Set<Orb> {
        return createInitialOrbs()
    }
    
    private func createInitialOrbs() -> Set<Orb> {
        var set: Set<Orb> = []
        
        for row in 0..<numRows {
            for column in 0..<numColumns {
                var element: OrbType
                repeat {
                    element = OrbType.randomElement()
                } while (column >= 2 &&
                orbs[column - 1, row]?.element == element &&
                orbs[column - 2, row]?.element == element)
                || (row >= 2 &&
                orbs[column, row - 1]?.element == element &&
                orbs[column, row - 2]?.element == element)
                
                let orb = Orb(column: column, row: row, element: element)
                orbs[column, row] = orb
                set.insert(orb)
            }
        }
        return set
    }
    
    func performSwap(_ swap: Swap) {
        let columnA = swap.orbA.column
        let rowA = swap.orbA.row
        let columnB = swap.orbB.column
        let rowB = swap.orbB.row
        
        orbs[columnA, rowA] = swap.orbB
        swap.orbB.column = columnA
        swap.orbB.row = rowA
        
        orbs[columnB, rowB] = swap.orbA
        swap.orbA.column = columnB
        swap.orbA.row = rowB
    }
    
    private func detectHorizontalMatches() -> Set<Chain> {
        var set: Set<Chain> = []
        
        for row in 0..<numRows {
            var column = 0
            while column < numColumns-2 {
                if let orb = orbs[column, row] {
                    let matchType = orb.element
                    
                    if orbs[column + 1, row]?.element == matchType &&
                        orbs[column + 2, row]?.element == matchType {
                        let chain = Chain()
                        chain.direction = .horizontal
                        repeat {
                            chain.add(orb: orbs[column, row]!)
                            column += 1
                        } while column < numColumns && orbs[column, row]?.element == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                
                column += 1
            }
            
        }
        return set
    }
    
    private func detectVerticalMatches() -> Set<Chain> {
        var set: Set<Chain> = []
        
        for column in 0..<numColumns {
            var row = 0
            while row < numRows-2 {
                if let orb = orbs[column, row] {
                    let matchType = orb.element
                    
                    if orbs[column, row + 1]?.element == matchType &&
                        orbs[column, row + 2]?.element == matchType {
                        let chain = Chain()
                        chain.direction = .vertical
                        repeat {
                            chain.add(orb: orbs[column, row]!)
                            row += 1
                        } while row < numRows && orbs[column, row]?.element == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                row += 1
            }
        }
        return set
    }
    
    func detectMatches() -> Set<Chain>? {
        var verticalMatches = detectVerticalMatches()
        let horizontalMatches = detectHorizontalMatches()
        
        if verticalMatches.isEmpty {
            print(horizontalMatches.map { $0.chainType })
            return horizontalMatches.isEmpty ? nil : horizontalMatches
        }
        
        verticalMatches.forEach { (verticalChain) in
            horizontalMatches.forEach { (horizontalChain) in
                if !verticalChain.combineIfNecessary(with: horizontalChain) {
                    verticalMatches.insert(horizontalChain)
                } else {
                    
                }
            }
        }
        print(verticalMatches.map { $0.chainType })
        return verticalMatches.count == 0 ? nil : verticalMatches
    }
    
    func removeMatches(_ chains: Set<Chain>) {
        removeOrbs(in: chains)
    }
    
    private func removeOrbs(in chains: Set<Chain>) {
        for chain in chains {
            for orb in chain.orbs {
                orbs[orb.column, orb.row] = nil
            }
        }
    }
    
    //Loop through each column, check from the bottom for empty spot and replace with first orb above
    func fillHoles() -> [[Orb]] {
        var columns: [[Orb]] = []
        
        for column in 0..<numColumns {
            var array: [Orb] = []
            for row in 0..<numRows {
                if orbs[column, row] == nil {
                    for lookup in (row+1)..<numRows {
                        if let orb = orbs[column, lookup] {
                            orbs[column, lookup] = nil
                            orbs[column, row] = orb
                            orb.row = row
                            array.append(orb)
                            break
                        }
                    }
                }
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    func topUpOrbs() -> [[Orb]] {
        var columns: [[Orb]] = []
        
        for column in 0..<numColumns {
            var array: [Orb] = []
            
            var row = numRows-1
            while row >= 0 && orbs[column, row] == nil {
                let element = OrbType.randomElement()
                
                let orb = Orb(column: column, row: row, element: element)
                orbs[column, row] = orb
                array.append(orb)
                row -= 1
            }
            
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    func replaceOrb(at column: Int, row: Int, notReplacedWithElements: [OrbType] = []) {

        guard let newElement = OrbType.allCases.filter({ !notReplacedWithElements.contains($0) }).randomElement() else { return }
        
        let newOrb = Orb(column: column, row: row, element: newElement)
        orbs[column, row]?.sprite?.removeFromParent()
        orbs[column, row] = nil
        orbs[column, row] = newOrb
        
        addSprite(for: newOrb)
    }
    
    func putSlime(for orb: Orb) {
//        let slimeOrb = Orb(column: orb.column, row: orb.row, element: .Slime)
//        orbs[orb.column, orb.row]?.sprite?.removeFromParent()
//        orbs[orb.column, orb.row] = slimeOrb
//        
//        addSprite(for: slimeOrb)
    }
    
    func putSlimes(number: Int) {
        for _ in 0..<number {
            putSlime(for: randomOrb())
        }
    }
    
    func randomOrb() -> Orb {
        return orbs[Int(arc4random_uniform(5)), Int(arc4random_uniform(4))]!
    }
    
}
