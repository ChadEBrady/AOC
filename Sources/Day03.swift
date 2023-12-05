//
//  Day03.swift
//
//
//  Created by Chad Brady on 12/3/23.
//

import Foundation

struct Position: Hashable {
  let row: Int
  let col: Int
}

struct Day03: AdventDay {
  let data: String

  func part1() -> Any {
    partsAndGears().0.reduce(0, +)
  }
  
  func part2() -> Any {
    partsAndGears().1.reduce(0,+)
  }

  func partsAndGears() -> ([Int], [Int]) {
    
    let digits: [String] = [0,1,2,3,4,5,6,7,8,9].map { String($0) }
    
    let matrix = data.components(separatedBy: .newlines).map {
      return Array($0)
    }

    var digitPositions: [Position] = []
    var partPositions: [Position: Int] = [:]
    var symbolPositions: [Position] = []
    var starPositions: [Position] = []
    var partDigits: [Int] = []
    var positionStart: Position?

    var cleanUp = {
      let partNum = arrayToInt(arr: partDigits)
      digitPositions.forEach {
        partPositions[$0] = partNum
      }
      digitPositions.removeAll()
      partDigits.removeAll()
      positionStart = nil
    }

    for (rowIndex, row) in matrix.enumerated() {
      for (colIndex, col) in row.enumerated() {
        
        let currentPos = Position(row: rowIndex, col: colIndex)
        
        if positionStart != nil {
          if digits.contains(String(col)) == false {
            cleanUp()
          } else if let value = Int(String(col)) {
            
            digitPositions.append(currentPos)
            partDigits.append(value)
            continue
          }
        } else if let value = Int(String(col)) {
          
          positionStart = currentPos
          digitPositions.append(currentPos)
          partDigits.append(value)
        }

        if digits.contains(String(col)) == false && col != "." {
          if col == "*" {
            starPositions.append(currentPos)
          }
          symbolPositions.append(currentPos)
        }
      }

      if positionStart != nil {
        cleanUp()
      }
    }

    let realParts = symbolPositions.flatMap {
      getParts(pos: $0, positions: partPositions)
    }

    let gearRatio = starPositions.map {
      getParts(pos: $0, positions: partPositions)
    }.filter { $0.count > 1 }.map { $0.reduce(1,*) }

    return (realParts, gearRatio)
  }

  func getParts(pos: Position, positions: [Position: Int]) -> [Int] {
    var parts = Set<Int>()
    surroundingPositions(position: pos).forEach {
      if let part = positions[$0] {
        parts.insert(part)
      }
    }
    return Array(parts)
  }

  func surroundingPositions(position: Position) -> [Position] {
    let offsets = [-1, 0, 1]
    var positions = [Position]()
    for row in offsets {
      for col in offsets {
        let neighbor = Position(
          row: position.row + row,
          col: position.col + col
        )
        if neighbor != position {
          positions.append(neighbor)
        }
      }
    }
    return positions
  }

  func arrayToInt(arr: [Int]) -> Int {
    return arr.reversed().enumerated().reduce(0) { (result, value) in
      let position = Int(pow(Double(10), Double(value.offset)))
      return result + value.element * position
    }
  }
}
