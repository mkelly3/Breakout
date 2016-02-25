//
//  ViewController.swift
//  Breakout
//
//  Created by mkelly2 on 2/25/16.
//  Copyright © 2016 mkelly2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var breakOutLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dvc = segue.destinationViewController as! GameViewController
        dvc.title = breakOutLabel.text
    }

}

