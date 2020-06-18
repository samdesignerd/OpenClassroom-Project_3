//
//  Weapon.swift
//  game_opc_project_3
//
//  Created by Sam Boulanger on 02/03/2020.
//  Copyright © 2020 Sam Boulanger. All rights reserved.
//

import Foundation

class Weapon{
  private let _damage: Int
  var damage: Int { return self._damage}
  
  init(_ damage: Int){ self._damage = damage }
  
  // change default max attack here :
  static func random(min: Int = 10, max: Int = 37) -> Weapon{
    return Weapon(Int.random(in: (min >= max ? 1 : min)..<max))
  }
}
