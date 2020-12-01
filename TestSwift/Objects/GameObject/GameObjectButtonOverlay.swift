//
//  GameObjectButtonOverlay.swift
//  TestSwift
//
//  Created by aship on 2020/11/22.
//

extension GameObject {
    // MARK: - ButtonOverlayDelegate
    
    func willPress(_ button: ButtonOverlay) {
        if button == overlay!.controlOverlay!.buttonA {
            controllerJump(true)
        }
        
        if button == overlay!.controlOverlay!.buttonB {
            controllerAttack()
        }
    }
    
    func didPress(_ button: ButtonOverlay) {
        if button == overlay!.controlOverlay!.buttonA {
            controllerJump(false)
        }
    }
    
    // MARK: - Controlling the character
    
    func controllerJump(_ controllerJump: Bool) {
        character!.isJump = controllerJump
    }
    
    func controllerAttack() {
        if !self.character!.isAttacking {
            self.character!.attack()
        }
    }
}
