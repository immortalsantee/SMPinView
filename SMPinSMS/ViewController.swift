//
//  ViewController.swift
//  SMPinSMS
//
//  Created by Santosh Maharjan on 2/4/18.
//  Copyright © 2018 Cyclone Nepal Info Tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var smPinView: SMPinView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func submitHandler(_ sender: UIButton) {
        print(smPinView.smIsAllTextFieldTyped())
    }
    
}

