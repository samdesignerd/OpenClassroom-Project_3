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
  
  init(name: String, characters: [Character]){
    self.name = name
    self.characters = characters
  }
  func hasNotLost() -> Bool {
    for persona in self.characters {
      if (persona.isAlive) { return true }
    }; return false
  }
  static func printCharacterList(_ characters: [Character], killScore: Bool = false, offset: Int = 0) {
    for (i, character) in characters.enumerated() { // Printing the remaining characters
//      print("[\(i + offset)] \(character.name)\n    \(character.life)HP    Attack: \(character.weapon.damage)\( killScore ? "    Kills: \(character.killScore)":"")")
      print("""
            [\(i + offset)] \(character.characterAbstractString())
                    \(killScore ? character.characterStatString()+"\n" : "")
            """)
    }
  }
}
