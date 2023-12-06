//
//  Day05.swift
//
//
//  Created by Chad Brady on 12/5/23.
//

import Foundation

enum Mappings: String, CaseIterable {
  case seedToSoil = "seed-to-soil"
  case soilToFertilizer = "soil-to-fertilizer"
  case fertilizerToWater = "fertilizer-to-water"
  case waterToLight = "water-to-light"
  case lightToTemperature = "light-to-temperature"
  case temperatureToHumidity = "temperature-to-humidity"
  case humidityToLocation = "humidity-to-location"
}

struct Day05: AdventDay {

  let data: String

  func parseData() -> (Seeds, [Mappings: SectionMapping]) {
    var lines = data.components(separatedBy: .newlines)
    let seeds = Seeds(input: lines.removeFirst())

    var sections: [Mappings: SectionMapping] = [:]
    var currentSection: [Map] = []
    var currentMap: Mappings? = nil
    while lines.isEmpty == false {
      let line = lines.removeFirst()
      if
        line.isEmpty,
        let currentMap = currentMap
      {
        sections[currentMap] = SectionMapping(maps: currentSection)
        currentSection = []
      } else if let first = line.components(separatedBy: .whitespaces).first,
        Int(first) != nil
      {
        currentSection.append(Map(input: line))
      } else {
        currentMap = Mappings(rawValue: line.components(separatedBy: .whitespaces).first ?? "")
      }
    }
    return (seeds, sections)
  }

  func part1() -> Any {
    let (seeds, mapping) = parseData()
    return seeds.seeds.reduce(Int.max, { min($0, LocationMap(seed: $1, mapping: mapping).toLocation)})
  }

  func part2() -> Any {
    return -1
  }

}


struct Map {
  let sourceDestinations: [Int: Int]
  init(input: String) {
    var sourceDestinations: [Int: Int] = [:]
    let values = input.components(separatedBy: .whitespaces)
    let destinationStart = Int(values[0]) ?? 0
    let sourceStart = Int(values[1]) ?? 0
    let range = Int(values[2]) ?? 0
    for value in 0..<Int(range) {
      sourceDestinations[sourceStart + value] = destinationStart + value
    }
    self.sourceDestinations = sourceDestinations
  }
}

struct Seed {
  let location: Int
}

struct Seeds {
  let seeds: [Seed]

  init(input: String) {
    var seeds: [Seed] = []
    if let values = input.components(separatedBy: ":").last {
      seeds = String(values).components(separatedBy: .whitespaces).filter { $0.isEmpty == false }.map { Seed(location: Int($0) ?? 0) }
    }
    self.seeds = seeds
  }
}

struct SectionMapping {
  let mapping: [Int: Int]
  init(maps: [Map]) {
    let mappings = maps.map { $0.sourceDestinations }
    mapping = mappings.flatMap { $0 }.reduce([:]) { (partial, map) in
      var newMap = partial
      newMap[map.key] = map.value
      return newMap
    }
  }

  func destination(for source: Int) -> Int {
    return mapping[source] ?? source
  }
}


struct LocationMap {
  let seed: Seed
  let seedMapping: [Mappings: SectionMapping]

  init(seed: Seed, mapping: [Mappings: SectionMapping]) {
    self.seed = seed
    self.seedMapping = mapping
  }

  var toSoil: Int {
    getMapping(.seedToSoil, seed.location)
  }

  var toFertilizer: Int {
    getMapping(.soilToFertilizer, toSoil)
  }

  var toWater: Int {
    getMapping(.fertilizerToWater, toFertilizer)
  }

  var toLight: Int {
    getMapping(.waterToLight, toWater)
  }

  var toTemp: Int {
    getMapping(.lightToTemperature, toLight)
  }

  var toHumidity: Int {
    getMapping(.temperatureToHumidity, toTemp)
  }

  var toLocation: Int {
    getMapping(.humidityToLocation, toHumidity)
  }

  func getMapping(_ key: Mappings, _ source: Int) -> Int {
    seedMapping[key]?.destination(for: source) ?? source
  }

}

//struct LocationRange {
//
//}
//
//
//struct SoilMap {
//  let ranges: []
//}
//
//struct SeedMap {
//
//  init(seed: Seed) {
//
//  }
//
//  func toSoil() -> Soil {
//
//  }
//}
//
//
//
//struct SoilMap: Conversion {
//  var destinationRangeStart: Int
//  var sourceRangeStart: Int
//  var rangeLength: Int
//
//
//}
