//
//  InfoView.swift
//  egg timer
//
//  Created by infuntis on 18.12.16.
//  Copyright © 2016 gala. All rights reserved.
//

import Foundation
import UIKit

protocol infoDelegate: class {
    func firstLaunch()
}

class InfoView : UIViewController{
    var delegate:infoDelegate?
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func okDidPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: {
            self.delegate?.firstLaunch()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        label.text = NSLocalizedString("infoWindow.IndoLabel", comment: "")
        
    }
}
