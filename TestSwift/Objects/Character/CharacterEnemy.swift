//
//  CharacterEtc.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension Character {
    func didHitEnemy() {
        model.runAction(SCNAction.group(
            [SCNAction.playAudio(hitEnemySound, waitForCompletion: false),
             SCNAction.sequence(
                [SCNAction.wait(duration: 0.5),
                 SCNAction.playAudio(explodeEnemySound, waitForCompletion: false)
                ])
            ]))
    }
    
    func wasTouchedByEnemy() {
        let time = CFAbsoluteTimeGetCurrent()
        if time > lastHitTime + 1 {
            lastHitTime = time
            model.runAction(SCNAction.sequence([
                SCNAction.playAudio(hitSound, waitForCompletion: false),
                SCNAction.repeat(SCNAction.sequence([
                    SCNAction.fadeOpacity(to: 0.01, duration: 0.1),
                    SCNAction.fadeOpacity(to: 1.0, duration: 0.1)
                    ]), count: 4)
                ]))
        }
    }
}
