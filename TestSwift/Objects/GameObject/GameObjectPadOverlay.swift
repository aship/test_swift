//
//  GameObjectPadOverlay.swift
//  TestSwift
//
//  Created by aship on 2020/11/13.
//

extension GameObject {
    // MARK: - PadOverlayDelegate
    
    func padOverlayVirtualStickInteractionDidStart(_ padNode: PadOverlay) {
        if padNode == overlay!.controlOverlay!.leftPad {
            characterDirection = SIMD2<Float>(Float(padNode.stickPosition.x),
                                              -Float(padNode.stickPosition.y))
        }
        
        if padNode == overlay!.controlOverlay!.rightPad {
            cameraDirection = SIMD2<Float>(-Float(padNode.stickPosition.x),
                                           Float(padNode.stickPosition.y))
        }
    }
    
    func padOverlayVirtualStickInteractionDidChange(_ padNode: PadOverlay) {
        if padNode == overlay!.controlOverlay!.leftPad {
            characterDirection = SIMD2<Float>(Float(padNode.stickPosition.x),
                                              -Float(padNode.stickPosition.y))
        }
        
        if padNode == overlay!.controlOverlay!.rightPad {
            cameraDirection = SIMD2<Float>(-Float(padNode.stickPosition.x),
                                           Float(padNode.stickPosition.y))
        }
    }
    
    func padOverlayVirtualStickInteractionDidEnd(_ padNode: PadOverlay) {
        if padNode == overlay!.controlOverlay!.leftPad {
            characterDirection = [0, 0]
        }
        
        if padNode == overlay!.controlOverlay!.rightPad {
            cameraDirection = [0, 0]
        }
    }
}
