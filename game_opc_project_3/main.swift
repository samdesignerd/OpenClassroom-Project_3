//
//  main.swift
//  game_opc_project_3
//
//  Created by Sam Boulanger on 25/02/2020.
//  Copyright © 2020 Sam Boulanger. All rights reserved.
//

import Foundation

let game: Game = Game()
while game.attackingPlayer.hasNotLost() {
  game.playLap()
}
game.declareVictory()
