//
//  GameViewController.swift
//  Breakout
//
//  Created by mkelly2 on 2/25/16.
//  Copyright © 2016 mkelly2. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate{
    
    @IBOutlet weak var livesLabel: UILabel!
    
    var dynamicAnimator = UIDynamicAnimator ()
    var collisionBehavior = UICollisionBehavior()
    var paddle = UIView()
    var ball = UIView()
    var brick = UIView()
    var bricks : [UIView] = []
    var allObjects : [UIView] = []
    var lives = 5


    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
    }
    
    func resetGame() {
        dynamicAnimator = UIDynamicAnimator(referenceView: view)

        //add a black ball object to the view
        ball = UIView(frame: CGRectMake(view.center.x, view.center.y, 20,20))
        ball.backgroundColor = UIColor.blackColor()
        ball.layer.cornerRadius = 10
        ball.clipsToBounds = true
        view.addSubview(ball)
        allObjects.append(ball)
        
        //add a red padde object to view
        paddle = UIView(frame: CGRectMake(view.center.x, view.center.y * 1.7,80,20))
        paddle.backgroundColor = UIColor.redColor()
        view.addSubview(paddle)
        allObjects.append(paddle)
        
        //create dynamic behavior for the ball
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0        //collision resistance
        ballDynamicBehavior.resistance = 0      // deceleration over time
        ballDynamicBehavior.elasticity = 1.0    // bounce factor
        ballDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        
        //create dynamic behavior for paddle
        let paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleDynamicBehavior.density = 10000
        paddleDynamicBehavior.resistance = 100
        paddleDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(paddleDynamicBehavior)
        
        // create a push behavior to get the ball moving
        let pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.pushDirection = CGVectorMake(0.2, 1.0)
        pushBehavior.magnitude = 0.25
        dynamicAnimator.addBehavior(pushBehavior)
        
        let brickDynamicBehavior = UIDynamicItemBehavior(items: bricks)
        brickDynamicBehavior.density = 10000
        brickDynamicBehavior.resistance = 100
        brickDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(brickDynamicBehavior)

        // create collision behaviors so ball can bounce of other objects
        collisionBehavior = UICollisionBehavior(items: allObjects)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)

        livesLabel.text = "Lives: \(lives)"
        addBrick(20, y: 40, color: UIColor.blueColor())
    }
    func addBrick(x: Int, y: Int, color: UIColor) {
        brick = UIView(frame: CGRectMake(20, 20, 40, 20))
        brick.backgroundColor = color
        view.addSubview(brick)
        bricks.append(brick)
        allObjects.append(brick)

        
    }
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if item.isEqual(ball) && p.y > paddle.center.y {
            lives--
            if lives > 0 {
                livesLabel.text = "Lives: \(lives)"
                ball.center = view.center
                dynamicAnimator.updateItemUsingCurrentState(ball)
            }
            else {
                gameOver("You Lost")
            }
        }
    }
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        if item1.isEqual(ball) && item2.isEqual(bricks) ||
            item2.isEqual(ball) && item1.isEqual(bricks) {
                if brick.backgroundColor == UIColor.blueColor(){
                   brick.backgroundColor = UIColor.redColor()
                }
                else {
                    brick.hidden = true
                    collisionBehavior.removeItem(brick)
                    gameOver("You Win")
                    ball.removeFromSuperview()
                    collisionBehavior.removeItem(ball)
                    dynamicAnimator.updateItemUsingCurrentState(ball)
                }
        }
    }
    func gameOver(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Reset", style: .Default) { (action) -> Void in
            self.resetGame()
            }
        alert.addAction(alertAction)
        
        let quitAction = UIAlertAction(title: "Quit", style: .Cancel, handler: nil)
        alert.addAction(quitAction)
        presentViewController(alert, animated: true, completion: nil)
        
        paddle.removeFromSuperview()
        collisionBehavior.removeItem(paddle)
        dynamicAnimator.updateItemUsingCurrentState(paddle)
        ball.removeFromSuperview()
        collisionBehavior.removeItem(ball)
        dynamicAnimator.updateItemUsingCurrentState(ball)
    }
    
    
    
    @IBAction func dragPaddle(sender: UIPanGestureRecognizer) {
        let panGesture = sender.locationInView(view)
        paddle.center = CGPointMake(panGesture.x, paddle.center.y)
        dynamicAnimator.updateItemUsingCurrentState(paddle)
    }

}