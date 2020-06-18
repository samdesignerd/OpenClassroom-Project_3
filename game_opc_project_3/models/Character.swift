//
//  Character.swift
//  game_opc_project_3
//
//  Created by Sam Boulanger on 02/03/2020.
//  Copyright © 2020 Sam Boulanger. All rights reserved.
//

import Foundation

class Character {
  private let _name: String
  var type: CharacterTypes // <-enum. Deafults with paysant and then becomes something else
  var name: String { return _name }
  
  fileprivate var _life: Int = 70 // change default life here
  var life: Int { return _life }
  var isAlive: Bool { return _life != 0 }
  
  fileprivate var _weapon: Weapon // fileprivate 'cause Warrior subclass needs to access ita
  var weapon: Weapon { return _weapon }
  
  private var _killScore: Int = 0
  var killScore: Int { return _killScore }
  
  init(_ name:  String) {
    self._name = name
    self._weapon = Weapon.random(max: 23) // change initial weapon max attack here
    self.type = .peasant
  }
  
  func attack(_ opponentCharacter: Character){
    print("!! \(self.name) attacks \(opponentCharacter.name)!!")
    if (opponentCharacter._life > self.weapon.damage) {
      opponentCharacter._life -= self.weapon.damage
      print("!! \(opponentCharacter.name) has now \(opponentCharacter.life)HP!!")
    } else {
      print("!! \(self._name) killed \(opponentCharacter.name)!!")
      opponentCharacter.die()
      self._killScore += 1
    }
  }
  func equip(_ weapon: Weapon){ self._weapon = weapon }
  func die(){ self._life = 0 }
  
  
  
  // those are used to print stats about the characters
  // the first one is overriden in character subclasses
  func characterAbstractString() -> String {
    return """
    \(self.name)    [\(self.type)]
        Attack: \(self.weapon.damage)     HP: \(self.life)
    """
  }
  func characterStatString() -> String{
    return """
    \(self.isAlive ? "":"[DEAD]    ")Killscore: \(self.killScore)
    """
  }
}

enum CharacterTypes: String  {
//  case mage, warrior, dwarf, peasant
  case mage = "mage"
  case warrior = "warrior"
  case dwarf = "dwarf"
  case peasant = "peasant"
}

// Dwarf deal in treasure box Done
// Warrior done by overridding the weapon computed attribute.
//


class Mage: Character {
  var healPower: Int
  // mage can choose to heal during the fight instead of attacking
  override init(_ name:  String) {
    self.healPower = Int.random(in: 10..<24)
    super.init(name)
    self.type = .mage
  }
  
  func heal(_ target: Character){
    target._life += self.healPower
  }
  
  override func characterAbstractString() -> String {
    return """
    \(self.name)    [\(self.type)]
        Attack: \(self.weapon.damage)     HP: \(self.life)
        Heal: \(self.healPower)
    """
  }
}

class Warrior: Character {
  var attackBuff: Float
  override init(_ name:  String) {
    self.attackBuff = (Float.random(in: 1.1..<1.5)*10).rounded(.up)/10

    super.init(name)
    self.type = .warrior
  }
  // Attack buff right there :
  override var weapon: Weapon {
    return Weapon(Int(Float(self._weapon.damage) * self.attackBuff))
  }
  override func characterAbstractString() -> String {
    return """
    \(self.name)    [\(self.type)]
        Attack: \(self.weapon.damage)     HP: \(self.life)
        Attack buff: \(self.attackBuff)
    """
  }
}

class Dwarf: Character {
  var luckBuff: Float
  override init(_ name:  String) {
    // The luck buff is located in the randomTreasure function
    self.luckBuff = (Float.random(in: 1.4..<2.4)*10).rounded(.up)/10
    super.init(name)
    self.type = .dwarf
  }
  override func characterAbstractString() -> String{
    return """
    \(self.name)    [\(self.type)]
        Attack: \(self.weapon.damage)     HP: \(self.life)
        Lucky charm: \(self.luckBuff)
    """
  }
}


