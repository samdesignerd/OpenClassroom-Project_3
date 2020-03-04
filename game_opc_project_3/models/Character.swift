//
//  Character.swift
//  game_opc_project_3
//
//  Created by Sam Boulanger on 02/03/2020.
//  Copyright © 2020 Sam Boulanger. All rights reserved.
//

import Foundation
class Character {
  // "Private or not private ?" : this is one question.
  // "Self or not self ?" is another.
  
  private let _name: String
  var name: String { return _name }
  
  private var _life: Int = 70 // change default life here
  var life: Int { return _life }
  var isAlive: Bool { return _life != 0 }
  
  private var _weapon: Weapon
  var weapon: Weapon { return _weapon }
  
  private var _killScore: Int = 0
  var killScore: Int { return _killScore }
  
  init(_ name:  String) {
    self._name = name
    self._weapon = Weapon.random(max: 23) // change initial weapon max attack here
  }
  
  func attack(_ opponentCharacter: Character){
    print("!! \(self._name) attacks \(opponentCharacter.name)!!")
    if (opponentCharacter._life > self._weapon.damage) {
      opponentCharacter._life -= self._weapon.damage
      print("!! \(opponentCharacter.name) has now \(opponentCharacter.life)HP!!")
    } else {
      print("!! \(self._name) killed \(opponentCharacter.name)!!")
      opponentCharacter.die()
      self._killScore += 1
    }
    
  }
  func equip(_ weapon: Weapon){
    self._weapon = weapon
  }
  func die(){
    self._life = 0
  }
}
