#  Class descriptions


## Game
### Game state
``` swift
class Game {
  var players: [Player]
  var charactersNameRegistry: Set<String> = []
  var playinPlayerIndex: Int = 0 // <- this will be used as a cyclic iterator
  var playinPlayer: Player {
    return self.players[playinPlayerIndex]
  }
}
```

### Game Lifecyle
``` swift
class Game {
  // MARK: Game Lifecycle
  // Introduction. Team building.
  func initializeTeams(){}
  // Launch the game loop :
  func playLap(){
    self.characterChoice()
    self.randomTreasure()
    self.attackingPhase()
  }
  // Conclusion. + ** Battle stats **.
  func declareVictory(){}
  
  
  // Inside the loop :
  func characterChoosing(){} // Choosing the actor for this the lap
  func randomTreasure(){} // Looting
  func attackingPhase(){} // CharacterX attacks opponent CharacterY
  
  
}
```
### How does the lap-loop work ?
*This is about to change*
``` swift
// TODO: Make evolve the lap system. !! This !!
// lapCount increments (this will accumulate the total number of turns)
// and lapModulo reduces the value to an usable index to query the player array.


class Game(){
  var playinPlayerIndex: Int = 0
  var playinPlayer: Player {
    return self.players[playinPlayerIndex]
  }
  func nextLap() {
    var playinPlayerIndex: Int = 0
    var nextPlayinPlayerIndex: Int = self.playinPlayerIndex
    nextPlayinPlayerIndex += 1
    nextPlayinPlayerIndex %= self.players.count
    self.playinPlayerIndex = nextPlayinPlayerIndex
  }
}
```
#### So what do we get in our main ?
``` swift
let game: Game = Game()
game.initializeTeams()
while game.playinPlayer.stillHasCharacters() {
  game.playLap()
  game.nextLap()
}
game.declareVictory()
```


## 




## Others
### Player
### Character
``` swift

```
### Weapon
``` swift
class Weapon{
  let damage: Int
  init(_ damage: Int){
    self.damage = damage
  }
  static func random(max: Int = 47) -> Weapon{
    return Weapon(Int.random(in: 1..<max))
  }
}
```
