//
//  ViewController.swift
//  Volume Override Test
//
//  Created by Corey McCourt on 6/5/18.
//  Copyright © 2018 Corey McCourt. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    var audioSession = AVAudioSession.sharedInstance()
    let volumeView = MPVolumeView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    let keyPathToObserve:String = "outputVolume"
    
    var buttonPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print()
        print(volumeView.subviews.first)
        print()
        
        volumeView.isHidden = false
        volumeView.alpha = 0.01
        volumeView.alpha = 1
        
        
        view.addSubview(volumeView)
        
        do {
            try self.audioSession.setActive(true)
        } catch {
            print("ERROR")
        }
        
        self.audioSession.addObserver(self, forKeyPath: keyPathToObserve, options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else { return }
        if keyPath == keyPathToObserve {
            if !buttonPressed {
                guard let oldVal = change[NSKeyValueChangeKey.oldKey] as? Float,
                    let newVal = change[NSKeyValueChangeKey.newKey] as? Float
                    else { return }
                
                let button = oldVal < newVal ? "UP" : "DOWN"
                print(button)
                
                
                // TODO: DONT DETECT VOLUME RESET - simple solution implemented
                //       ALLOW VOLUME ADJUSTMENT WITH BOUNDS  +/- MAX
                buttonPressed = true
                
                // Reset Volume to center
                guard let volumeControl = volumeView.subviews.first as? UISlider else {return} // DO THIS ONCE AS MEMBER VARIABLE
                volumeControl.setValue(0.5, animated: false)
            }
            else {
                buttonPressed = false
            }
            
            
            
        }
        
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        self.audioSession.removeObserver(self, forKeyPath: keyPathToObserve, context: nil)
    }
}



