//
//  modalAdvice.swift
//  egg timer
//
//  Created by infuntis on 23.10.16.
//  Copyright © 2016 gala. All rights reserved.
//

import UIKit

protocol modalAdviceDelegate: class {
    func notificationAlloweded()
    func notificationNotAlloweded()
}

class modalAdvice: UIViewController {
    var delegate:modalAdviceDelegate?
    
    
    @IBOutlet weak var adviceLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        adviceLabel.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
        adviceLabel.text = NSLocalizedString("modalWindow.NotificationAdvice", comment: "")

        // Do any additional setup after loading the view.
    }

    @IBAction func notOkAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: {
            self.delegate?.notificationNotAlloweded()
        })
    }
    @IBAction func okAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: {
            self.delegate?.notificationAlloweded()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
