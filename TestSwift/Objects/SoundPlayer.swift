//
//  SoundPlayer.swift
//  ArrowShooter
//
//  Copyright (c) 2014年 STUDIO SHIN. All rights reserved.
//

import AVFoundation		//AVFoundationフレームワークをインポートする

class SoundPlayer: NSObject, AVAudioPlayerDelegate {
    //プロパティ
    var bgmPlayer: AVAudioPlayer?	//BGMプレイヤー
    var isBGMPause: Bool = false	//BGM一時停止フラグ
    var bgmVolume: Float = 0.5		//BGMの音量
    var seVolume: Float = 0.5		//SEの音量
    var sePlayers: NSMutableSet = NSMutableSet()	//SEのプレイヤーを格納するセット
    
    
    //BGM再生開始
    func setBGMSound(_ filepath: String) {
        self.bgmStop()
        let url: URL? = URL(fileURLWithPath: filepath, isDirectory: false)
        if url != nil {
            self.bgmPlayer = try? AVAudioPlayer(contentsOf: url!)
            self.bgmPlayer?.delegate = self
            self.bgmPlayer?.numberOfLoops = -1
            self.bgmPlayer?.volume = self.bgmVolume
            self.bgmPlayer?.play()
        }
    }
    
    //BGM停止
    func bgmStop() {
        self.isBGMPause = false
        self.bgmPlayer?.stop()
    }
    
    //BGM一時停止
    func bgmPause(_ pause: Bool) {
        if self.isBGMPause != pause {
            self.isBGMPause = pause;
            if self.isBGMPause {
                self.bgmPlayer?.pause();
            }
            else {
                self.bgmPlayer?.play()
            }
        }
    }
    //SE再生
    func sePlay(_ name: String, type: String) {
        let filePath = Bundle.main.path(forResource: name, ofType: type)
        if let path=filePath {
            let url = URL(fileURLWithPath: path,
                          isDirectory: false)
            
            let player: AVAudioPlayer = try! AVAudioPlayer(contentsOf: url)
            
            self.sePlayers.add(player)
            player.delegate = self;
            player.volume = self.seVolume;
            player.play()
        }
    }
    
    
    //AVAudioPlayerデリゲートメソッド
    //再生終了
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                     successfully flag: Bool) {
        for pl in self.sePlayers {
            if pl as! NSObject == player {
                self.sePlayers.remove(pl)
                break
            }
        }
    }
}
