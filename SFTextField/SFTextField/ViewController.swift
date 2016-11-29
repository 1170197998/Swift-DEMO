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
        switcher.addTarget(self, action: #selector(ViewController.clickSwitch(_:)), for: UIControlEvents.valueChanged)
    }
    
    @objc fileprivate func clickSwitch(_ sender: UISwitch) {
        textField.isSecureTextEntry = sender.isOn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

