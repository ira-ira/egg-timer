//
//  ViewController.swift
//  egg timer
//
//  Created by infuntis on 09.10.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBAction func firstBtnPressed(_ sender: AnyObject) {
        if(!isStarted){
            selectedType[0] = true
            selectedType[1] = false
            selectedType[2] = false
            setHighlightingForButtons()
            counter = getCurrentTimer()
            refreshTimerValue()
        }
        
    }
    @IBAction func middleButnPressed(_ sender: AnyObject) {
        if(!isStarted){
            selectedType[0] = false
            selectedType[1] = true
            selectedType[2] = false
            setHighlightingForButtons()
            counter = getCurrentTimer()
            refreshTimerValue()
        }
        
        
    }
    @IBAction func lastBtnPressed(_ sender: AnyObject) {
        if(!isStarted){
            selectedType[0] = false
            selectedType[1] = false
            selectedType[2] = true
            setHighlightingForButtons()
            counter = getCurrentTimer()
            refreshTimerValue()
        }
        
    }
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var counterView: RoundTimer!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var lastButton: UIButton!
    let fisrtConst = 240
    let secondConst = 360
    let thirdConst = 450
    var timer = Timer()
    var selectedType = Array(repeating: false, count: 3)
    var isStarted = false
    var counter: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(thirdConst)
        firstButton.isHighlighted = true
        middleButton.isHighlighted = true
        selectedType[2] = true
        timerLbl.font = UIFont(name: "04b_19", size: 32.0)
        let str = NSString(format:"%0.2d:%0.2d", thirdConst / 60,thirdConst%60)
        timerLbl.text = str as String
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func restartBtnPressed(_ sender: AnyObject) {
        if isStarted{
            counterView.counter = 0
            counterView.maxValue = getCurrentTimer()
            counter = getCurrentTimer()
            refreshTimerValue()
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerAction), userInfo:nil ,   repeats: true)
            
        }
    }
    @IBAction func startBtnPressed(_ sender: AnyObject) {
        if(!isStarted){
            counter = getCurrentTimer()
            counterView.maxValue = getCurrentTimer()
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerAction), userInfo:nil ,   repeats: true)
            
            isStarted = true
            disableButtons()
            self.startBtn.setImage(#imageLiteral(resourceName: "stop"), for: UIControlState())
            
        } else{
            isStarted = false
            timer.invalidate()
            counterView.counter = 0
            counterView.maxValue = getCurrentTimer()
            counter = getCurrentTimer()
            refreshTimerValue()
            enableButtons()
            setHighlightingForButtons()
            self.startBtn.setImage(#imageLiteral(resourceName: "play"), for: UIControlState())
        }
    }
    
    func refreshTimerValue(){
        let str = NSString(format:"%0.2d:%0.2d", counter! / 60,counter!%60)
        timerLbl.text = str as String
    }
    
    func timerAction(){
        counterView.counter+=1
        counter!-=1
        let str = NSString(format:"%0.2d:%0.2d", counter! / 60,counter!%60)
        timerLbl.text = str as String
    }
    
    func disableButtons(){
        firstButton.isEnabled = false
        middleButton.isEnabled = false
        lastButton.isEnabled = false
    }
    func enableButtons(){
        firstButton.isEnabled = true
        middleButton.isEnabled = true
        lastButton.isEnabled = true
    }
    
    
    func setHighlightingForButtons(){
        if selectedType[0]{
            firstButton.isHighlighted = false
        } else{
            firstButton.isHighlighted = true
        }
        if selectedType[1]{
            middleButton.isHighlighted = false
        } else{
            middleButton.isHighlighted = true
        }
        if selectedType[2]{
            lastButton.isHighlighted = false
        } else{
            lastButton.isHighlighted = true
        }
    }
    
    func getCurrentTimer()-> Int{
        if selectedType[0]{
            return fisrtConst
        } else if selectedType[1]{
            return secondConst
        } else{
            return thirdConst
        }
    }
}

