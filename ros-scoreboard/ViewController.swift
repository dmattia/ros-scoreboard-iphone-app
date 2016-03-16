//
//  ViewController.swift
//  ros-scoreboard
//
//  Created by David Mattia on 3/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    private var players : Dictionary<String, Int>?
    let ref = Firebase(url:"https://ros.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            self.players = snapshot.value as? Dictionary<String, Int>
            self.reloadViews()
        })
    }

    func reloadViews() {
        let blueScore = self.players!["Blue Player"]
        self.textLabel.text = "\(blueScore!)"
    }
    
    @IBAction func upButtonPressed(sender: AnyObject) {
        self.players!["Blue Player"] = self.players!["Blue Player"]! + 1
        ref.setValue(players)
    }
}

