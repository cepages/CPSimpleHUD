//
//  ViewController.swift
//  SimpleHUD
//
//  Created by Carlos Pages on 28/08/2014.
//  Copyright (c) 2014 Carlos Pages. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let INITIAL_REMAIN_TIME = 10

    
    @IBOutlet weak var simpleHUDButton: UIButton!
    
    var remainTime:Int = 0
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func activateSimpleHUDToucheIn(sender: AnyObject) {
        
        let buttonTouched = sender as UIButton
        
        let hud = CPSimpleHUD.shareWaitingView
        hud.loadingLabel.text = "Simple HUD"
        hud.heightDarkViewContraint.constant = 250;
        hud.widthDarkViewContraint.constant = 250;
        hud.waitingMode = .SmallCubesBorders
        hud.show()
        

        self.remainTime = INITIAL_REMAIN_TIME
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerFire:"), userInfo: nil, repeats: true)
        
    }
    
    func timerFire(timer: NSTimer){
        self.remainTime--
        //We update the button label
        self.simpleHUDButton.setTitle("Time remaining \(self.remainTime)", forState:.Normal)
       
        if self.remainTime == 0 {
            CPSimpleHUD.shareWaitingView.hide()
            self.simpleHUDButton.setTitle("Activate Simple HUD", forState:.Normal)

            timer.invalidate()
        }
    }
    
    
}

