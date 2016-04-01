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

    @IBOutlet weak var difficultyButton: UIButton!
    @IBOutlet weak var playerTableView: UITableView!
    
    private var players : Dictionary<String, Int>?
    let scoreRef = Firebase(url:"https://ros.firebaseio.com/scores")
    let difficultyRef = Firebase(url:"https://ros.firebaseio.com/difficulty")

    let dictNames = ["Blue Player", "Green Player", "Red Player", "Yellow Player"]
    let colors = [UIColor.blueColor(), UIColor.greenColor(), UIColor.redColor(), UIColor.yellowColor()]
    let difficulties: [String: UIColor] = [
        "Easy": UIColor.greenColor(),
        "Medium": UIColor.grayColor(),
        "Hard": UIColor.redColor()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreRef.observeEventType(.Value, withBlock: {
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
        return 100
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
    
    func difficultyToValue(difficulty: String) -> Int {
        if difficulty == "Easy" {
            return 0
        } else if difficulty == "Medium" {
            return 1
        } else {
            return 2
        }
    }
    
    @IBAction func difficultyButtonClicked(sender: AnyObject) {
        if let currentDifficulty = self.difficultyButton.titleLabel?.text {
            var nextDifficulty = "Easy"
            if currentDifficulty == "Easy" {
                nextDifficulty = "Medium"
            } else if currentDifficulty == "Medium" {
                nextDifficulty = "Hard"
            }

            difficultyRef.setValue(difficultyToValue(nextDifficulty))
            
            self.difficultyButton.setTitle(nextDifficulty, forState: .Normal)
            self.difficultyButton.backgroundColor = difficulties[nextDifficulty]
        }
    }
    
    @IBAction func resetPresset(sender: AnyObject) {
        while self.players!.isEmpty {
            self.players?.popFirst()
        }
        for name in dictNames {
            self.players![name] = 0
        }
        scoreRef.setValue(players)
    }
    
    @IBAction func minusClicked(sender: AnyObject) {
        let row = sender.tag
        if self.players![dictNames[row]] > 0 {
            self.players![dictNames[row]] = self.players![dictNames[row]]! - 1
            scoreRef.setValue(players)
        }
    }
    
    @IBAction func plusClicked(sender: UIButton) {
        let row = sender.tag
        if self.players![dictNames[row]] < 5 {
            self.players![dictNames[row]] = self.players![dictNames[row]]! + 1
            scoreRef.setValue(players)
        }
    }
}

