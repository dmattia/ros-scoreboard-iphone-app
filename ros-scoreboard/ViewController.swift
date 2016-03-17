//
//  ViewController.swift
//  ros-scoreboard
//
//  Created by David Mattia on 3/16/16.
//  Copyright © 2016 David Mattia. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var playerTableView: UITableView!
    private var players : Dictionary<String, Int>?
    let ref = Firebase(url:"https://ros.firebaseio.com")
    let dictNames = ["Blue Player", "Green Player", "Red Player", "Yellow Player"]
    let colors = [UIColor.blueColor(), UIColor.greenColor(), UIColor.redColor(), UIColor.yellowColor()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            self.players = snapshot.value as? Dictionary<String, Int>
            self.reloadViews()
        })
        
        self.playerTableView.delegate = self
        self.playerTableView.dataSource = self
    }

    func reloadViews() {
        self.playerTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let players = players {
            return players.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellid = "ScoreCell"
        let cell = self.playerTableView.dequeueReusableCellWithIdentifier(cellid) as! playerTabelViewCell
        
        let score = players![dictNames[indexPath.row]]
        cell.scoreLabel.text = "\(dictNames[indexPath.row]): \(score!)"
        cell.plusButton.tag = indexPath.row
        cell.minusButton.tag = indexPath.row
        
        //cell.backgroundColor = colors[indexPath.row]
        //cell.scoreLabel.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    @IBAction func resetPresset(sender: AnyObject) {
        while self.players!.isEmpty {
            self.players?.popFirst()
        }
        for name in dictNames {
            self.players![name] = 0
        }
        ref.setValue(players)
    }
    
    @IBAction func minusClicked(sender: AnyObject) {
        let row = sender.tag
        if self.players![dictNames[row]] > 0 {
            self.players![dictNames[row]] = self.players![dictNames[row]]! - 1
            ref.setValue(players)
        }
    }
    
    @IBAction func plusClicked(sender: UIButton) {
        let row = sender.tag
        if self.players![dictNames[row]] < 5 {
            self.players![dictNames[row]] = self.players![dictNames[row]]! + 1
            ref.setValue(players)
        }
    }
}

