//
//  ViewController.swift
//  SFTextField
//
//  Created by ShaoFeng on 16/7/27.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var switcher: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        switcher.addTarget(self, action: #selector(ViewController.clickSwitch(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @objc private func clickSwitch(sender: UISwitch) {
        textField.secureTextEntry = sender.on
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

