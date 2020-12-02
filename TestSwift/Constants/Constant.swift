//
//  Constant.swift
//  TestSwift
//
//  Created by aship on 2020/12/01.
//

// Collision bit masks
struct Bitmask: OptionSet {
    let rawValue: Int
    static let character = Bitmask(rawValue: 1 << 0) // the main character
    static let collision = Bitmask(rawValue: 1 << 1) // the ground and walls
    static let enemy = Bitmask(rawValue: 1 << 2) // the enemies
    static let trigger = Bitmask(rawValue: 1 << 3) // the box that triggers camera changes and other actions
    static let collectable = Bitmask(rawValue: 1 << 4) // the collectables (gems and key)
}

enum AudioSourceKind: Int {
    case collect = 0
    case collectBig
    case unlockDoor
    case hitEnemy
    case totalCount
}

enum ParticleKind: Int {
    case collect = 0
    case collectBig
    case keyApparition
    case enemyExplosion
    case unlockDoor
    case totalCount
}
