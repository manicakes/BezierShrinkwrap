//
//  ViewController.swift
//  BezierShrinkwrap
//
//  Created by Mani Ghasemlou on 09/27/2015.
//  Copyright (c) 2015 Mani Ghasemlou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: MGImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stepField: UITextField!
    @IBOutlet weak var marginField: UITextField!
    
    @IBAction func goButtonPressed(sender : AnyObject) {
        image.stepValue = Int(stepField.text!)
        image.marginValue = Int(marginField.text!)
        image.drawBezier()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        image.stepValue = Int(stepField.text!)
        image.marginValue = Int(marginField.text!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

