//
//  SceneObjectCongras.swift
//  TestSwift
//
//  Created by aship on 2020/11/24.
//

import SceneKit

extension SceneObject {
    // MARK: Congratulating the Player
    
    func showEndScreen() {
        gameIsComplete = true
        
        // Add confettis
        let particleSystemPosition = SCNMatrix4MakeTranslation(0.0, 8.0, 0.0)
        #if os(iOS) || os(tvOS)
        self.scnScene.addParticleSystem(confettiParticleSystem, transform: particleSystemPosition)
        #elseif os(OSX)
        gameSCNView.scene!.addParticleSystem(confettiParticleSystem, transform: particleSystemPosition)
        #endif
        
        // Stop the music.
        self.scnScene.rootNode.removeAllAudioPlayers()
        
        // Play the congrat sound.
        self.scnScene.rootNode.addAudioPlayer(SCNAudioPlayer(source: victoryMusic))
        
        // Animate the camera forever
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.cameraYHandle.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y:-1, z: 0, duration: 3)))
            self.cameraXHandle.runAction(SCNAction.rotateTo(x: CGFloat(-Double.pi / 4), y: 0, z: 0, duration: 5.0))
        }
        
        self.skScene.showEndScreen();
    }
}
