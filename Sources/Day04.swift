//
//  Day04.swift
//
//
//  Created by Chad Brady on 12/4/23.
//

import Foundation

struct Card {
  let id: Int
  let first: Set<Int>
  let second: Set<Int>

  init(input: String) {
    let gameString = input.dropFirst(5)
    let gameIndex = input.firstIndex(of: ":") ?? gameString.startIndex
    let gameId = gameString.prefix(upTo: gameIndex)
    self.id = Int(String(gameId)) ?? -1

    let values = String(gameString[gameIndex..<gameString.endIndex]).components(separatedBy: "|")
    
    first = Set(values.first?.components(separatedBy: .whitespaces).compactMap { Int($0) } ?? [])
    second = Set(values.last?.components(separatedBy: .whitespaces).compactMap { Int($0) } ?? [])

  }

  func matched() -> Set<Int> {
    first.intersection(second)
  }
}


struct Day04: AdventDay {

  let data: String

  func part1() -> Any {
    let lines = data.components(separatedBy: .newlines)
    return lines.map {
      return Card(input: $0)
    }.filter { $0.matched().count > 0 }.map {
      return 1 << ($0.matched().count - 1)
    }.reduce(0, +)
  }


  // DOES NOT WORK CORRECTLY WITH FULL SET
  func part2() -> Any {
    var lines = data.components(separatedBy: .newlines).filter { !$0.isEmpty }
    var cards: [Card] = []
    var copies: [Int] = []
    var count: Int = 0
    makeCards(lines: &lines, cards: &cards, copies: &copies, count: &count)

    return count
  }

  func makeCards(lines: inout [String], cards: inout [Card], copies: inout [Int], count: inout Int) {
    if lines.isEmpty { return }
     
    let line = lines.removeFirst()

    let card = Card(input: line)

    let copyCount = copies.filter { $0 == card.id }.count

    cards.append(card)
    count += 1

    var wins = card.matched().count
    var copiedCards: [Int] = []
    while wins > 0 {
      let winCopy = card.id + wins
      copiedCards.append(winCopy)
      wins -= 1
    }

    copies.append(contentsOf: copiedCards)
    count += copiedCards.count * (copyCount + 1)
    for _ in 0..<copyCount {
      copies.append(contentsOf: copiedCards)
    }

    makeCards(lines: &lines, cards: &cards, copies: &copies, count: &count)
  }
}
