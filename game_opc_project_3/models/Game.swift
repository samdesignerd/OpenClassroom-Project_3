//
//  Game.swift
//  game_opc_project_3
//
//  Created by Sam Boulanger on 02/03/2020.
//  Copyright © 2020 Sam Boulanger. All rights reserved.
//

import Foundation

class Game {
  private var charactersNameRegistry: Set<String> = []
  private var attackingCharacter: Character?
  
  private var players: [Player] = []
  var attackingPlayer: Player { return self.players[attackingPlayerIndex] }
  var defendingPlayer: Player { return self.players[defendingPlayerIndex] }
  
  // MARK: Lapping mecanics
  private var lapCount: Int = 0
  private var attackingPlayerIndex: Int {
    return self.lapCount % 2
  }
  private var defendingPlayerIndex: Int {
    return (self.lapCount + 1) % 2
  }
  func incrementLap() { self.lapCount += 1 }
  
  ///++++++++++ FIX
  init(){
    self.players = handlePlayerCreation() // woowoo1 fix and code initializeTeams method
  }
  //TODO: Create character input initialisation procedure
  //TODO: Must remove this default behaviour and incorpore the users (human and machine) to the mix.
  private func handlePlayerCreation() -> [Player]{ // woowoo1
    return [
      Player( name: "Samuelito", type: .human, characters: [ // set those from input (CLI)
        Character("Ganondorf"),
        Character("Samus"),
        Character("Yoshi"),
      ]),
      Player( name: "MrPseudoRandom", type: .computer, characters: [
        Character("Computer_01"),
        Character("Computer_02"),
        Character("Computer_03"),
      ])
    ]
  }
  ///+++++++++
  
  
  
  
  
  
  
  
  
  // MARK: Game Lifecycle
  // Introduction. Team building.
  private func initializeTeams(){ // TODO: UI !!!!
    // triggered at initialisation.
    // Asks players to choose characters for their team
    
  }
  // Launch the game loop :
  func playLap(){
    print("[ New lap ] Player: \(self.attackingPlayer.name)")
    self.characterChoosing()
    Thread.sleep(forTimeInterval: 0.5)
    self.randomTreasure()
    Thread.sleep(forTimeInterval: 0.5)
    self.attackingPhase()
    print("\n")
    self.incrementLap()
    Thread.sleep(forTimeInterval: 0.8)
  }
  // Conclusion. + ** Battle stats **.
  func declareVictory(){
    print("\(self.attackingPlayer.name) has no more characters. \(self.attackingPlayer.name) looses.")
    Thread.sleep(forTimeInterval: 1.0)
    print("\(self.defendingPlayer.name) wins.")
    Thread.sleep(forTimeInterval: 1.4)
    print("\n\n\n[END OF GAME STATS]")
    Thread.sleep(forTimeInterval: 0.6)
    self.players.forEach { player in
      print("\(player.name) : \(player.hasNotLost() ? "WINNER" : "LOOSER")")
      Player.printCharacterList(player.characters, killScore: true)
      print("")
    }
  }
  
  
  
  // MARK: Inside the loop (game.playLap())
  // MARK: Choosing the attacking character
  private func characterChoosing(){ // Choosing the actor for this lap
    switch(game.attackingPlayer.type){
      case .human:
        self.attackingCharacter = self.askTargetCharacter(
          "Please choose the character you want to attack with",
          characterList: self.attackingPlayer.aliveCharacters
        )
        print("You choosed \(self.attackingCharacter!.name).\n")
      case .computer:
        self.attackingCharacter = game.attackingPlayer.randomAlivePersona!
        print("Computer will attack with \(self.attackingCharacter!.name)")
    }
  }
  
  //  MARK: Treasure chest
  private func randomTreasure(){
    if (Double.random(in: 0.0..<1.0) < 0.9){
      self.openTreasure()
    }
  }
  private func openTreasure(){ // looting
    let weapon = Weapon.random()
    switch(game.attackingPlayer.type){
      case .human:
        print("""
        You stepped on a treasure. It contains a weapon
        with \(weapon.damage) damage points.
        Do you want to equip it ? (Yes or No)
        """)
        if (self.askYesOrNo()) { self.attackingCharacter!.equip(weapon) }
      case .computer:
        let stronger: Bool = (weapon.damage > self.attackingCharacter!.weapon.damage)
        print("""
        The opponent has found a weapon with \(weapon.damage) damage points
        in a treasure box and will \(stronger ? "":"not ")equip it.
        """)
        if (stronger) { self.attackingCharacter!.equip(weapon) }
    }
  }
  
  
  
  // TODO: YEAH
  // MARK: Attack Phase
  private func attackingPhase(){
    switch(game.attackingPlayer.type){
    case .human:
      self.attackingCharacter!.attack(
        self.askTargetCharacter(
          "Please choose the character you want to attack",
          characterList: self.defendingPlayer.aliveCharacters
        )
      )
    case .computer:
      self.attackingCharacter!.attack(
        self.defendingPlayer.randomAlivePersona!
      )
    }
  }
  
  
  
  
  // MARK: USER INTERACTION HELPERS
  func askYesOrNo() -> Bool{ // yes or no helper
    while true {
      if let input = readLine() {
        if ["yes", "y"].contains(input.lowercased()) {
          return true
        } else if ["no", "n"].contains(input.lowercased()) {
          return false
        }
      }
      print("Incorrect entry. Please choose between yes or no.")
    }
  }
  func askCappedNumber(_ max: Int) -> Int{ // choose a number in a list helper
    while true {
      if let input = readLine() {
        if let number = Int(input) {
          if number < max {
            return number
          }
        }
      }
      print("Please write a number between 0 and \(max).")
    }
  }
  func askTargetCharacter(_ inquiry: String, characterList: [Character]) -> Character { // Handles asking the character to the user
    print("\(inquiry) (0-\(characterList.count - 1)) :")
    Player.printCharacterList(characterList)
    return characterList[self.askCappedNumber(characterList.count)]
  }
}
