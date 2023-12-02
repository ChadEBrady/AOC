//
//  Day01.swift
//  AdventOfCode
//
//  Created by Chad Brady on 12/1/23.
//

import Foundation

struct Day01: AdventDay {

    let data: String

    let nameToDigit = [
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9,
    ]

    func part1() -> Any {
        var values = [Int]()
        let lines: [String] = data.components(separatedBy: .newlines)

        for line in lines {
            let firstDigit = line.first { $0.isWholeNumber }?.wholeNumberValue ?? 0
            let lastDigit = line.last { $0.isWholeNumber }?.wholeNumberValue ?? 0

            let value = (firstDigit * 10) + lastDigit
            values.append(value)
        }

        return values.reduce(0, +)
    }

    func part2() -> Any {
          var values = [Int]()
        let lines: [String] = data.components(separatedBy: "\n")

        for line in lines {
            guard line.isEmpty == false else { continue }
            var startIndex = line.startIndex
            var endIndex = line.index(before: line.endIndex)
            var firstDigit = -1
            var lastDigit = -1

            while firstDigit < 0 || lastDigit < 0 {
                let firstChar = line[startIndex]
                let lastChar = line[endIndex]
                if firstDigit < 0 {
                    if let firstNum = firstChar.wholeNumberValue {
                        firstDigit = firstNum
                    } else if let wordDigit = isWordDigit(str: line, startIndex: startIndex)
                    {
                        firstDigit = wordDigit
                    }
                }

                if lastDigit < 0 {
                    if let lastNum = lastChar.wholeNumberValue {
                        lastDigit = lastNum
                    } else if let wordDigit = isWordDigit(str: line, startIndex: endIndex)
                    {
                        lastDigit = wordDigit
                    }
                }

                if startIndex != line.index(before: line.endIndex) {
                    startIndex = line.index(after: startIndex)
                }

                if endIndex != line.startIndex {
                    endIndex = line.index(before: endIndex)
                }
            }

            let value = (firstDigit * 10) + lastDigit
            values.append(value)
        }

        return values.reduce(0, +)
    }

    func isWordDigit(str: String, startIndex: String.Index) -> Int? {

        let maxKeyLength = nameToDigit.keys.reduce(0, { max($0, $1.count) })

        var keyLength = 0
        var digit: Int? = nil

        while keyLength <= maxKeyLength && digit == nil {
            guard let subStringEndIndex = str.index(startIndex, offsetBy: keyLength, limitedBy: str.endIndex) else { break }

            let subString = String(str[startIndex..<subStringEndIndex])
            if let mapped = nameToDigit[subString] {
                digit = mapped
            }
            keyLength += 1
        }

        return digit
    }
}
