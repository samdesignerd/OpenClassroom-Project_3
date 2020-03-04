//
//  Player.swift
//  game_opc_project_3
//
//  Created by Sam Boulanger on 02/03/2020.
//  Copyright © 2020 Sam Boulanger. All rights reserved.
//

import Foundation

class Player {
  let name: String
  let characters: [Character]
  var aliveCharacters: [Character] {
    return self.characters.filter { $0.isAlive }
  }
  var randomAlivePersona: Character? {
    return self.characters.filter { $0.isAlive }.randomElement()
  }
  let type: PlayerType // Enum: .human or .computer
  init(name: String, type: PlayerType, characters: [Character]){
    self.name = name
    self.characters = characters
    self.type = type
  }
  func hasNotLost() -> Bool {
    for persona in self.characters {
      if (persona.isAlive) { return true }
    }
    return false
  }
  static func printCharacterList(_ characters: [Character], killScore: Bool = false) {
    for (i, character) in characters.enumerated() { // Printing the remaining characters
      print("[\(i)] \(character.name)\n    \(character.life)HP    Attack: \(character.weapon.damage)\( killScore ? "    Kills: \(character.killScore)":"")")
    }
  }
}

enum PlayerType {
  case computer
  case human
}
