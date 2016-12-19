

import UIKit
import UserNotifications
import AVFoundation

class ViewController: UIViewController, SegmentControlDelegate, modalAdviceDelegate, infoDelegate{
    
    var iMinSessions = 3
    var iTryAgainSessions = 6
    
    func rateMe() {
        let neverRate = UserDefaults.standard.bool(forKey: "neverRate")
        var numLaunches = UserDefaults.standard.integer(forKey: "numLaunches") + 1
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1)))
        {
            showRateMe()
            numLaunches = iMinSessions + 1
        }
        UserDefaults.standard.set(numLaunches, forKey: "numLaunches")
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: NSLocalizedString("rate.Info.title", comment: ""), message: NSLocalizedString("rate.Info.message", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("rate.OK", comment: ""), style: UIAlertActionStyle.default, handler: { alertAction in
            UIApplication.shared.openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1178891322") as! URL)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("rate.no", comment: ""), style: UIAlertActionStyle.default, handler: { alertAction in
            UserDefaults.standard.set(true, forKey: "neverRate")
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("rate.maybe", comment: ""), style: UIAlertActionStyle.default, handler: { alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var muteLabel: UILabel!
    
    func notificationAlloweded() {
        registerForNotifications(types:  [.alert, .badge, .sound])
        startBtnPressed()
        
    }
    
    func notificationNotAlloweded() {
        startBtnPressed()
        
    }
    func firstLaunch(){
        UserDefaults.standard.set(true, forKey: "Walkthrough")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InfoView{
            destination.delegate = self
        }
        if let destination = segue.destination as? modalAdvice{
            destination.delegate = self
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "info"{
            return true
        }
        if identifier == "modalAdvice" && !isNotificationsAvailable()  && !isStarted {
            return true
        } else{
            startBtnPressed()
        }
        return false
    }
    
    
    @IBOutlet weak var segmentCntrl: SegmentControl!
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
    var fisrtConst = 240
    var secondConst = 390
    var thirdConst = 510
    var timer = Timer()
    var selectedType = Array(repeating: false, count: 3)
    var isStarted = false
    var counter: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        firstButton.isHighlighted = true
        middleButton.isHighlighted = true
        selectedType[2] = true
        segmentCntrl.delegate = self
        timerLbl.font = UIFont(name: "AvenirNext-Regular", size: 32.0)
        timerLbl.textColor = UIColor(hex: "#EF4822")
        let str = NSString(format:"%0.2d:%0.2d", getCurrentTimer() / 60,getCurrentTimer()%60)
        timerLbl.text = str as String
        muteLabel.text = NSLocalizedString("mainPage.muteLabel", comment: "")
        
        counterView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationWillResignActive),name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationDidBecomeActive),name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "Walkthrough") {
            performSegue(withIdentifier: "info", sender: self)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    func startBtnPressed() {
        
        if(!isStarted){
            scheduleNotification(identifier: "egg-timer-1", title: NSLocalizedString("notification.Title", comment: ""), subtitle: "", body: NSLocalizedString("notification.Body", comment: ""),timeInterval: TimeInterval(getCurrentTimer()))
            counter = getCurrentTimer()
            counterView.maxValue = getCurrentTimer()
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerAction), userInfo:nil ,   repeats: true)
            
            isStarted = true
            disableButtons()
            self.startBtn.setImage(#imageLiteral(resourceName: "stop"), for: UIControlState())
            segmentCntrl.enabled = false
            muteLabel.isHidden = false
            muteLabel.alpha = 1.0
            UIView.animate(withDuration: 2, delay: 3, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {self.muteLabel.alpha = 0.0}, completion: { finished in self.muteLabel.isHidden = true})
        } else{
            timerLbl.font = UIFont(name: timerLbl.font.fontName, size: 32)
            isStarted = false
            timer.invalidate()
            counterView.counter = 0
            counterView.maxValue = getCurrentTimer()
            counter = getCurrentTimer()
            refreshTimerValue()
            enableButtons()
            setHighlightingForButtons()
            self.startBtn.setImage(#imageLiteral(resourceName: "play"), for: UIControlState())
            deleteNotification()
            segmentCntrl.enabled = true
            AudioUtil.sharedInstance().stopSoundEffect()
            rateMe()
        }
    }
    
    func refreshTimerValue(){
        let str = NSString(format:"%0.2d:%0.2d", counter! / 60,counter!%60)
        timerLbl.text = str as String
    }
    
    func segmentChanged() {
        counter = getCurrentTimer()
        refreshTimerValue()
    }
    
    func timerAction(){
        counterView.counter+=1
        counter!-=1
        if counter! < 0 {
            timer.invalidate()
           AudioUtil.sharedInstance().playSoundEffect("Angry-chicken.mp3")
            timerLbl.font = UIFont(name: timerLbl.font.fontName, size: 24)
            timerLbl.text = NSLocalizedString("mainPage.Ready", comment: "")
        } else{
            let str = NSString(format:"%0.2d:%0.2d", counter! / 60,counter!%60)
            timerLbl.text = str as String
        }
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
        var coldDelta = 0
        if segmentCntrl.selectedIndex == 0 {
            coldDelta = 30
        }
        if selectedType[0]{
            return fisrtConst + coldDelta
        } else if selectedType[1]{
            return secondConst + coldDelta
        } else{
            return thirdConst + coldDelta
        }
    }
    
    
    func deleteNotification() {
        if #available(iOS 10, *) {
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
    
    private func loadDefaults() {
        let userDefault = UserDefaults.standard
        let restoredCounter = userDefault.object(forKey: PropertyKey.counterKey) as! Int
        let restoredTimeMeasurement = userDefault.object(forKey: PropertyKey.counterMeasurementKey) as! Double
        
        let timeDelta = Date().timeIntervalSince1970 - restoredTimeMeasurement
        if(timeDelta > 60*60){
            startBtnPressed()
            return
        }
        
        counter! = restoredCounter - Int(timeDelta) + 1
        let delta = getCurrentTimer() - counter!
        if(delta <= counterView.maxValue){
            counterView.counter = delta
        } else{
            counterView.counter = counterView.maxValue
        }
        timerAction()
        
    }
    
    
    func scheduleNotification(identifier: String, title: String, subtitle: String, body: String, timeInterval: TimeInterval, repeats: Bool = false) {
        if #available(iOS 10, *) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound(named:"Angry-chicken.mp3")
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            let notification = UILocalNotification()
            notification.alertBody = "\(title)\n\(subtitle)\n\(body)"
            notification.fireDate = Date(timeIntervalSinceNow: timeInterval)
            notification.soundName = "Angry-chicken.mp3"
            
            UIApplication.shared.scheduleLocalNotification(notification)
       }
    }
    
    
    func isNotificationsAvailable() -> Bool{
            return UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false
    }
    
    func registerForNotifications(types: UIUserNotificationType) {
        if #available(iOS 10.0, *) {
            let options = types.authorizationOptions()
            UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
                if granted {
                    
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    struct PropertyKey {
        static let counterKey = "EggTimerViewController_timeCount"
        static let counterMeasurementKey = "EggTimerViewController_timeMeasurement"
    }
    
    private func saveDefaults() {
        let userDefault = UserDefaults.standard
        userDefault.set(counter, forKey: PropertyKey.counterKey)
        userDefault.set(Date().timeIntervalSince1970, forKey: PropertyKey.counterMeasurementKey)
        
        userDefault.synchronize()
        
    }
    
    private func clearDefaults() {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: PropertyKey.counterKey)
        userDefault.removeObject(forKey: PropertyKey.counterMeasurementKey)
        
        userDefault.synchronize()
        
    }
    
    dynamic private func applicationWillResignActive() {
        if !timer.isValid {
            clearDefaults()
        } else {
            saveDefaults()
        }
    }
    
    dynamic private func applicationDidBecomeActive() {
        if timer.isValid {
            loadDefaults()
        }
    }
    
}

// MARK: - <#Description#>
extension UIUserNotificationType {
    
    @available(iOS 10.0, *)
    func authorizationOptions() -> UNAuthorizationOptions {
        var options: UNAuthorizationOptions = []
        if contains(.alert) {
            options.formUnion(.alert)
        }
        if contains(.sound) {
            options.formUnion(.sound)
        }
        if contains(.badge) {
            options.formUnion(.badge)
        }
        return options
    }
    
}

