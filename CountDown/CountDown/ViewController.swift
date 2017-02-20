//
//  ViewController.swift
//  CountDown
//
//  Created by ShaoFeng on 2017/2/20.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var second: UILabel!
    
    var timer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.minimumDate = Date()
        datePicker.locale = Locale(identifier: "zh_CH")
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
    }
    
    @objc fileprivate func dateChange()->() {
        print(datePicker.date)
        
        let endDate = datePicker.date
        let startDate = Date()
        let timeInterval:TimeInterval = endDate.timeIntervalSince(startDate)
        
        if timer == nil {
            let timeout = 0
            let queue = DispatchQueue.global()
            timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            DispatchSource.setEventHandler(timer) -> () {
                
            }

            
            
        }
        
    }
    
    @IBAction func calculateTime(_ sender: Any) {
        
    }

}


