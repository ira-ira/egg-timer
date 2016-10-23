//
//  TimerViewController.swift
//  egg timer
//
//  Created by infuntis on 23.10.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation


class TimerViewController: UIViewController {
    
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resetTimerButton: UIButton!
    
    var timer = NSTimer()
    let timeInterval:NSTimeInterval = 0.01
    let timerEnd:NSTimeInterval = 90
    var timeCount:NSTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetTimeCount()
        timerLabel.text = timeString(timeCount)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.applicationWillResignActive),name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TimerViewController.applicationDidBecomeActive),name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func startTimerButtonTapped(sender: UIButton) {
        
        if !timer.valid { //prevent more than one timer on the thread
            timerLabel.text = timeString(timeCount)
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self,selector: #selector(TimerViewController.timerDidEnd(_:)),userInfo: nil, repeats: true)
            schedulePushNotification()
        }
        
    }
    
    @IBAction func resetTimerButtonTapped(sender: UIButton) {
        timer.invalidate()
        resetTimeCount()
        timerLabel.text = timeString(timeCount)
        cancelAllNotifications()
    }
    
    // MARK: Timer
    
    func resetTimeCount(){
        timeCount = timerEnd
    }
    
    func timerDidEnd(timer: NSTimer){
        //timer that counts down
        timeCount = timeCount - timeInterval
        if timeCount <= 0 {  //test for target time reached.
            timerLabel.text = "Time is up!!"
            timer.invalidate()
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            cancelAllNotifications()
        } else { //update the time on the clock if not reached
            timerLabel.text = timeString(timeCount)
        }
    }
    
    func timeString(time: NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%02i:%02i.%02i",minutes,Int(seconds),Int(secondsFraction * 100.0))
    }
    
    // MARK: Timer Storage
    
    struct PropertyKey {
        static let timeCountKey = "TimerViewController_timeCount"
        static let timeMeasurementKey = "TimerViewController_timeMeasurement"
    }
    
    dynamic private func applicationWillResignActive() {
        if !timer.valid {
            clearDefaults()
            NSLog("Clearning defaults")
        } else {
            saveDefaults()
            NSLog("Saving defaults")
        }
    }
    
    dynamic private func applicationDidBecomeActive() {
        if timer.valid {
            loadDefaults()
            NSLog("Loading defaults")
        }
    }
    
    private func saveDefaults() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(timeCount, forKey: PropertyKey.timeCountKey)
        userDefault.setObject(NSDate().timeIntervalSince1970, forKey: PropertyKey.timeMeasurementKey)
        
        userDefault.synchronize()
        
    }
    
    private func clearDefaults() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey(PropertyKey.timeCountKey)
        userDefault.removeObjectForKey(PropertyKey.timeMeasurementKey)
        
        userDefault.synchronize()
        
    }
    
    private func loadDefaults() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let restoredTimeCount = userDefault.objectForKey(PropertyKey.timeCountKey) as! Double
        let restoredTimeMeasurement = userDefault.objectForKey(PropertyKey.timeMeasurementKey) as! Double
        
        let timeDelta = NSDate().timeIntervalSince1970 - restoredTimeMeasurement
        print(timeDelta)
        print(timeCount - restoredTimeCount - timeDelta)
        timeCount = restoredTimeCount - timeDelta
    }
    
    // MARK: Notifications
    
    func schedulePushNotification() {
        let notification = UILocalNotification()
        notification.alertAction = "Go back to App"
        notification.alertBody = "The 90s timer is finished!"
        notification.fireDate = NSDate(timeIntervalSinceNow: timerEnd+1)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    func cancelAllNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
}
