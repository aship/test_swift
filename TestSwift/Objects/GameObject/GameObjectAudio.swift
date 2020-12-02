//
//  GameObjectAudio.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension GameObject {
    // MARK: - Audio
    
    func playSound(_ audioName: AudioSourceKind) {
        scene.rootNode.addAudioPlayer(SCNAudioPlayer(source: audioSources[audioName.rawValue]))
    }
    
    func setupAudio() {
        // Get an arbitrary node to attach the sounds to.
        let node = scene.rootNode
        
        // ambience
        if let audioSource = SCNAudioSource(named: "audio/ambience.mp3") {
            audioSource.loops = true
            audioSource.volume = 0.8
            audioSource.isPositional = false
            audioSource.shouldStream = true
            node.addAudioPlayer(SCNAudioPlayer(source: audioSource))
        }
        // volcano
        if let volcanoNode = scene.rootNode.childNode(withName: "particles_volcanoSmoke_v2", recursively: true) {
            if let audioSource = SCNAudioSource(named: "audio/volcano.mp3") {
                audioSource.loops = true
                audioSource.volume = 5.0
                volcanoNode.addAudioPlayer(SCNAudioPlayer(source: audioSource))
            }
        }
        
        // other sounds
        audioSources[AudioSourceKind.collect.rawValue] = SCNAudioSource(named: "audio/collect.mp3")!
        audioSources[AudioSourceKind.collectBig.rawValue] = SCNAudioSource(named: "audio/collectBig.mp3")!
        audioSources[AudioSourceKind.unlockDoor.rawValue] = SCNAudioSource(named: "audio/unlockTheDoor.m4a")!
        audioSources[AudioSourceKind.hitEnemy.rawValue] = SCNAudioSource(named: "audio/hitEnemy.wav")!
        
        // adjust volumes
        audioSources[AudioSourceKind.unlockDoor.rawValue].isPositional = false
        audioSources[AudioSourceKind.collect.rawValue].isPositional = false
        audioSources[AudioSourceKind.collectBig.rawValue].isPositional = false
        audioSources[AudioSourceKind.hitEnemy.rawValue].isPositional = false
        
        audioSources[AudioSourceKind.unlockDoor.rawValue].volume = 0.5
        audioSources[AudioSourceKind.collect.rawValue].volume = 4.0
        audioSources[AudioSourceKind.collectBig.rawValue].volume = 4.0
    }
}
