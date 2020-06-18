//
//  Game.swift
//  game_opc_project_3
//
//  Created by Sam Boulanger on 02/03/2020.
//  Copyright © 2020 Sam Boulanger. All rights reserved.
//

import Foundation

class Game {
  static let characterTypes = ["mage", "warrior", "dwarf", "peasant"]
  private let playerPerGame = 2 // Supports multiplayer > 2
  private let characterPerPlayer = 2 // 3 characters per player
  private var characterNameRegistry: Set<String> = [] // permits to check if a name is already registered
  private var competitors: [Player] = [Player]()
  var winner: Player? {
    if competitors.count == 1 { return competitors[0] }
    return nil
  }
  // MARK: Lap mecanics
  private var lapCount: Int = 0
  private var effectiveLapCount: Int = 0
  private var contenderIndex: Int {
    return self.lapCount % self.playerPerGame
  }
  func incrementLap() {
    self.lapCount += 1
  }
  private var attackingCharacter: Character?
  
  private var players: [Player] = [] // This contains all the players
  var contender: Player { return self.players[contenderIndex] } // The player whose turn it is
  var defendingPlayers: [Player] { // All the characters the player can attack with its choosen character
    var players: [Player] = []
    for player in self.competitors.filter({ ($0.name != self.contender.name) }) {
      players.append(player)
    }
    return players
  }
  

  init(){
    print("""
    
    \tFormation Developpeur SWIFT - Projet 3
    \tCreated by Sam Boulanger on 02/03/2020.
    ___________________________________________
    
    
    """)
    
    self.initializeTeams()
    self.competitors = self.players
  }
  
  
  
  
  
  
  
  // MARK: Game Lifecycle
  
  
  // Introduction. Team building.
  private func initializeTeams(){ // TODO: UI !!!!
    // triggered at initialisation.
    // Asks players to choose characters for their team
    for playerIndex in 1...self.playerPerGame {
      print("Player #\(playerIndex)\nPlease enter the name of your character followed by enter.\nYou have \(self.characterPerPlayer) character\(self.characterPerPlayer > 1 ? "s" : "") to create.")
      var characters: [Character] = []
      for _ in 1...self.characterPerPlayer {
        let newName: String = self.UIaskNewCharacterName() // returns only new names
        characterNameRegistry.insert(newName)
        var newCharacter: Character
        switch self.UIaskCharacterType() {
        case "mage":
          newCharacter = Mage(newName)
        case "warrior":
          newCharacter = Warrior(newName)
        case "dwarf":
          newCharacter = Dwarf(newName)
        default:
          newCharacter = Character(newName)
        }
        print(newCharacter.characterAbstractString())
        print()
        characters.append(newCharacter)
      }
      self.players.append(Player(name: "Player #\(playerIndex)", characters: characters)) // creating the player instance
      Thread.sleep(forTimeInterval: 0.5)
      print("Player #\(playerIndex) created.\n")
      Thread.sleep(forTimeInterval: 0.5)
    }
  }
  
  // Launch the game loop :
  func playLap(){
    if self.contender.hasNotLost() {
      print("[ New lap ]     Player: \(self.contender.name)     [ New lap ]")
      self.characterChoosing()
      Thread.sleep(forTimeInterval: 0.5)
      self.randomTreasure(character: self.attackingCharacter!)
      Thread.sleep(forTimeInterval: 0.5)
      self.attackPhase()
      print("\n")
      
      self.updateCompetitors()
      self.effectiveLapCount += 1
    }
    self.incrementLap()
    Thread.sleep(forTimeInterval: 0.8)
  }
  
  // Conclusion. + ** Battle stats **.
  func declareVictory(){
    Thread.sleep(forTimeInterval: 1.0)
    print("\(self.winner!.name) wins.")
    Thread.sleep(forTimeInterval: 1.4)
    print("\n\n\n[END OF GAME STATS]")
    Thread.sleep(forTimeInterval: 0.6)
    print("You played \(self.effectiveLapCount) laps.")
    self.players.forEach { player in
      print("\(player.name) : \(player.hasNotLost() ? "WINNER" : "LOOSER")")
      Player.printCharacterList(player.characters, killScore: true)
      print("\nHave a good day!\n")
    }
  }
  
  
  
  // MARK: Inside the loop (game.playLap())
  // MARK: Choosing the attacking character
  private func characterChoosing(){ // Choosing the actor for this lap
    self.attackingCharacter = self.UIaskTargetCharacter(
      "Please choose the character you want to attack with",
      targetPlayers: [self.contender]
    )
  }
  
  //  MARK: Treasure chest
  private func randomTreasure(character: Character){
    var luck: Float = 0.2
    if let dwarf = character as? Dwarf { // <- Dwarf buff
        luck *= dwarf.luckBuff
    }
    if Float.random(in: 0.0..<1.0) < luck {
      self.openTreasure()
    }
  }
  private func openTreasure(){ // looting
    let weapon = Weapon.random()
    print("""
    You stepped on a treasure. It contains a weapon
    with \(weapon.damage) damage points.
    Do you want to equip it ? (Yes or No)
    """)
    if (self.UIaskYesOrNo()) { self.attackingCharacter!.equip(weapon) }
  }
  
  // MARK: Attack Phase
  private func attackPhase(){
    if let mage = self.attackingCharacter! as? Mage {
      // check if mage, propose to heal instead of attacking
      if self.UIaskMageCureOrNo() {
        mage.heal(
          self.UIaskTargetCharacter(
            "Please choose the character you want to heal",
            targetPlayers: self.competitors // can heal anyone
          )
        )
        return
      }
    }
    self.attackingCharacter!.attack( self.UIaskTargetCharacter(
        "Please choose the character you want to attack",
        targetPlayers: self.defendingPlayers
      )
    )
  }
  // MARK: Updating competitors
  // Looking any loser
  private func updateCompetitors(){
    for contender in self.competitors{
      if !contender.hasNotLost() {
        print("\(contender.name) has no more characters. \(contender.name) loses.\n")
      }
    }
    self.competitors = self.competitors.filter({ $0.hasNotLost() })
  }
  
  
  
  
  
  // MARK: USER INTERACTION PRINT HELPERS
  //  UIaskYesOrNo() -> Bool
  //  UIaskCappedNumber(_ max: Int) -> Int
  //  UIaskNewCharacterName() -> String
  //  UIaskTargetCharacter(_ inquiry: String, characterList: [Character]) -> Character
  
  //  UIaskCharacterType() -> CharacterTypes
  //  UIaskMageCureOrNo() -> Bool
  func UIaskYesOrNo() -> Bool{ // yes or no helper
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
  func UIaskCappedNumber(_ max: Int) -> Int{ // choose a number in a list helper
    while true {
      if let input = readLine() {
        if let number = Int(input) {
          if number < max {
            return number
          }
        }
      }
      print("Please write a number between 0 and \(max-1).")
    }
  }
  func UIaskNewCharacterName() -> String{
    print("Name your character :")
    while true {
      if let input = readLine() {
        if input == "" {
          print("Please write something.")
        } else {
          if !self.characterNameRegistry.contains(input) {
            return input
          }
          print("Character name is already taken, please choose another one.")
        }
      }
    }
  }
  func UIaskNewCharacterType() -> String{
    while true {
      return "Mage"
    }
  }
  func UIaskTargetCharacter(_ inquiry: String, targetPlayers: [Player]) -> Character { // Handles asking the character to the user
    let characterCount: Int = targetPlayers.reduce(0){ $0 + $1.aliveCharacters.count }
    print("\(inquiry) (0-\(characterCount - 1)) :")
//    if ((targetPlayers.count == 0)) { print("error")}
    if (targetPlayers.count == 1){
      print("- \(targetPlayers[0].name)'s characters :")
      Player.printCharacterList(targetPlayers[0].aliveCharacters)
      return targetPlayers[0].aliveCharacters[self.UIaskCappedNumber(characterCount)]
    } else {
      let characters: [Character] = targetPlayers.reduce([Character]()){ $0 + $1.aliveCharacters }
      var characterOffset = 0
      for player in targetPlayers {
        print("- \(player.name)'s characters :")
        Player.printCharacterList(player.aliveCharacters, offset: characterOffset)
        characterOffset += player.aliveCharacters.count
      }
      return characters[self.UIaskCappedNumber(characterCount)]
    }
  }
  
  
  
  
  
  
  func UIaskCharacterType() -> String {
    let typeList: String = Game.characterTypes.map({ "\($0)" }).joined(separator: ", ")
    print("Choose a type for your Character (\(typeList)) :")
    
    while true {
      if let input = readLine() {
        // better check if is in [Game.characterTypes] :
        // if not return peasant
        
        if Game.characterTypes.contains(input.lowercased()){
          return input.lowercased()
        } else {
          print("Incorrect entry. Please choose between those : \(typeList)")
        }
      }
    }
  }
  
  func UIaskMageCureOrNo() -> Bool {
    print("Do you want to cure a character ?")
    return self.UIaskYesOrNo()
  }
}



  
