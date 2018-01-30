//
//  ViewController.swift
//  Example
//
//  Created by Jaime.Frutos on 30/1/18.
//  Copyright © 2018 Jaime Frutos. All rights reserved.
//

import UIKit
import ProgressSnackBar

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showWithText(_ sender: Any) {
        
        let snackbar = ProgressSnackBar()
        snackbar.showWithAction("Internet connection lost", actionTitle: "OK", duration: 5) {
            // tap on OK button
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

