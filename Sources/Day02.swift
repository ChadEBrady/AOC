//
//  Day02.swift
//  AdventOfCode
//
//  Created by Chad Brady on 12/1/23.
//

import Foundation

struct Day02: AdventDay {

  let data: String
  private let maxMarbles = Round(red: 12, green: 13, blue: 14)

  func part1() -> Any {
    
    parseGames(input: data).reduce(0, { result, game in
      if game.isPossible(maxMarbles: maxMarbles) {
        return result + game.id
      } else {
        return result
      }
    })
  }

  func part2() -> Any {
    
    parseGames(input: data).reduce(0, { result, game in
      let gameMaxRound = game.maxRound

      let power = gameMaxRound.red * gameMaxRound.blue * game.maxRound.green
      return result + power
    })
  }

  private func parseGames(input: String) -> [Game] {
    
    input.components(separatedBy: .newlines).compactMap {
      guard $0.isEmpty == false else { return nil }

      return Game(value: $0)
    }
  }
}

private struct Game {
  let id: Int
  let rounds: [Round]

  var maxRound: Round {
    rounds.reduce(Round(), { oldRound, newRound in
      let maxRed = max(oldRound.red, newRound.red)
      let maxGreen = max(oldRound.green, newRound.green)
      let maxBlue = max(oldRound.blue, newRound.blue)

      return Round(red: maxRed, green: maxGreen, blue: maxBlue)
    })
  }

  init(value: String) {

      var roundString = value.dropFirst(5)

      let gameIndex = value.firstIndex(of: ":") ?? roundString.startIndex

      let gameId = roundString.prefix(upTo: gameIndex)
      self.id = Int(String(gameId)) ?? -1

      roundString = roundString[gameIndex..<roundString.endIndex]
      roundString = roundString.dropFirst(2)

    self.rounds = roundString.components(separatedBy: ";").map {
      var colorDict = [String: Int]()
      
      let round = $0.components(separatedBy: ",")

      for marbleCount in round {
        let valueKey = marbleCount.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        if
          let color = valueKey.last,
          let value = valueKey.first?.trimmingCharacters(in: .whitespaces)
        {
          colorDict[color] = Int(value) ?? 0
        }
      }
      return Round(dict: colorDict)
    }
  }

  func isPossible(maxMarbles: Round) -> Bool {
    return maxRound.red <= maxMarbles.red &&
      maxRound.green <= maxMarbles.green &&
      maxRound.blue <= maxMarbles.blue
  }
}

private struct Round {
  let red: Int
  let green: Int
  let blue: Int

  init(red: Int = 0, green: Int = 0, blue: Int = 0) {
    self.red = red
    self.green = green
    self.blue = blue
  }

  init(dict: [String: Int]) {
    red = dict["red"] ?? 0
    blue = dict["blue"] ?? 0
    green = dict["green"] ?? 0
  }
}
