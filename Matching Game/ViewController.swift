//
//  ViewController.swift
//  Matching Game
//
//  Created by Kevin Chang on 8/6/16.
//  Copyright © 2016 Kevin Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var boardView: UIView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var winLabel: UIImageView!
    @IBOutlet var newGameButton: UIButton!
    
    var boardWidth: Int!
    
    var button1 = UIButton()
    var button2 = UIButton()
    var button3 = UIButton()
    var button4 = UIButton()
    var button5 = UIButton()
    var button6 = UIButton()
    var button7 = UIButton()
    var button8 = UIButton()
    var button9 = UIButton()
    var button10 = UIButton()
    var button11 = UIButton()
    var button12 = UIButton()
    var button13 = UIButton()
    var button14 = UIButton()
    var button15 = UIButton()
    var button16 = UIButton()
    
    var cards = [UIButton]()
    var currentBtnList = [UIButton]()
    
    var cardCount = 4
    
    var card1: UIButton!
    var card2: UIButton!
    
    var choices = ["blackHexagon", "blueHexagon", "greenOctagon", "greenTriangle", "pinkTriangle", "purpleSquare", "redPentagon", "yellowSquare"]
    
    var pairs = [Int]()
    
    var score = 0
    var targetScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cards = [button1, button2, button3, button4, button5, button6, button7, button8, button9, button10, button11, button12, button13, button14, button15, button16]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func buttonActionDown(sender: UIButton!) {
        flipCard(sender)
    }
    
    func buttonActionUp(sender: UIButton!) {
        check()
    }

    @IBAction func startPressed(sender: UIButton) {
        if cardCount < 16
        {
            cardCount = cardCount + 2
        }
        boardWidth = Int(boardView.frame.width)
        while currentBtnList.count > 0 {
            currentBtnList.removeFirst().removeFromSuperview()
        }
        newRound(cardCount)
        startButton.hidden = true
        startButton.setTitle("Next Round", forState: UIControlState.Normal)
        targetScore = targetScore + cardCount / 2
        winLabel.hidden = true
    }
    
    @IBAction func newGameButtonPressed(sender: UIButton) {
        cardCount = 4
        score = 0
        targetScore = 0
        startButton.setTitle("Start", forState: UIControlState.Normal)
        startButton.hidden = false
        scoreLabel.text = "Score: 0"
        while currentBtnList.count > 0 {
            currentBtnList.removeFirst().removeFromSuperview()
        }
    }
    
    func newRound(numBtn: Int) {
        var dim = 0
        while dim * dim < numBtn {
            dim = dim + 1
        }
        
        let width = Double(boardWidth) / Double(dim)
        
        var count = 0
        while count < numBtn {
            let x = (count % dim) * Int(width) + Int(width * 0.05)
            let y = (count / dim) * Int(width) + Int(width * 0.05)
            
            var button = cards[count]
            button = UIButton(frame: CGRect(x: x, y: y, width: Int(width * 0.9), height: Int(width * 0.9)))
            let image = UIImage(named: "CardBack")! as UIImage
            button.setBackgroundImage(image, forState: UIControlState.Normal)
            button.tag = count
            button.addTarget(self, action: #selector(buttonActionDown), forControlEvents: .TouchDown)
            button.addTarget(self, action: #selector(buttonActionUp), forControlEvents: .TouchUpInside)
            
            currentBtnList.append(button)
            
            boardView.addSubview(button)
            
            count = count + 1
        }
        
        newRound()
    }

    func flipCard(card: UIButton) {
        let index = card.tag //cards.indexOf(card)
        print("Index: " + String(index))
        let choiceIndex = pairs[index]
        print("Choice Index: " + String(choiceIndex))
        let face = choices[choiceIndex]
        print("Face: " + face)
        
        let image = UIImage(named: face)! as UIImage
        card.setBackgroundImage(image, forState: UIControlState.Normal)

        card.backgroundColor = UIColor.whiteColor()

        card.userInteractionEnabled = false
        card.adjustsImageWhenHighlighted = false
        
        if card1 == nil {
            card1 = card
        } else if card2 == nil {
            card2 = card
        }
    }
    
    func flipDown(card: UIButton) {
        let image = UIImage(named: "CardBack")! as UIImage
        card.setBackgroundImage(image, forState: UIControlState.Normal)
        card.backgroundColor = UIColor.clearColor()
        card.setTitle("", forState: UIControlState.Normal)
        card.userInteractionEnabled = true
    }
    
    func check() {
        if card1 != nil && card2 != nil {
            if !checkHelper() {
                sleep(UInt32(1))
                flipDown(card1)
                flipDown(card2)
            } else {
                card1.userInteractionEnabled = false
                card2.userInteractionEnabled = false
                score = score + 1
                scoreLabel.text = "Score: " + String(score)
                print("score: " + String(score))
                print("card count / 2: " + String (cardCount / 2))
                if score == targetScore {
                startButton.hidden = false
                winLabel.hidden = false
                }
            }
            card1 = nil
            card2 = nil
        }
    }
    
    func checkHelper() -> Bool {
        let index1 = card1.tag
        let choiceIndex1 = pairs[index1]
        let face1 = choices[choiceIndex1]
        
        let index2 = card2.tag
        let choiceIndex2 = pairs[index2]
        let face2 = choices[choiceIndex2]
        
        if face1 == face2 {
            return true
        } else {
            return false
        }
    }
    
    func newRound() {
        var random = Set<Int>()
        
        while random.count < cardCount / 2 {
            let rand = Int(arc4random_uniform(UInt32(choices.count)))
            random.insert(rand)
        }
        
        var randomPairs = [Int]()
        
        for num in random {
            randomPairs.append(num)
        }
        
        for num in random {
            let index = Int(arc4random_uniform(UInt32(random.count)))
            randomPairs.insert(num, atIndex: index)
        }
        
        pairs = randomPairs
    }
    
}

