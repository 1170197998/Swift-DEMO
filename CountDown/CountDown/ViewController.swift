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
            var timeout = timeInterval
            let queue = DispatchQueue.global()
            timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: queue)

            /*
             _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
             dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行

             */
            
            timer?.scheduleRepeating(deadline: <#T##DispatchTime#>, interval: <#T##DispatchTimeInterval#>, leeway: <#T##DispatchTimeInterval#>)
             _ = timer?.scheduleRepeating(wallDeadline: DispatchWallTime.now(), interval: 1.0 * Double(NSEC_PER_SEC), leeway: DispatchTimeInterval(0))
            
            _ = DispatchSource.makeTimerSource().setEventHandler(handler: {
                if timeout <= 0 {
                    self.timer?.cancel()
                    self.timer = nil
                    DispatchQueue.main.async {
                        self.day.text = "00"
                        self.hour.text = "00"
                        self.minute.text = "00"
                        self.second.text = "00"
                    }
                } else {
                    let days = timeout / (3600 * 24)
                    if days == 0 {
                        self.day.text = ""
                    }
                    let hours = (timeout - days * 24 * 3600) / 3600
                    let minutes = (timeout - days * 24 * 3600 - hours * 3600) / 60
                    let seconds = (timeout - days * 24 * 3600 - hours * 3600 - minutes * 60)
                    DispatchQueue.main.async {
                        if days == 0 {
                            self.day.text = "0"
                        } else {
                            self.day.text = "\(days)"
                        }
                        if hours < 10 {
                            self.hour.text = "0" + "\(hours)"
                        } else {
                            self.hour.text = "\(hours)"
                        }
                        if minutes < 10 {
                            self.minute.text = "0" + "\(minutes)"
                        } else {
                            self.minute.text = "\(minutes)"
                        }
                        if seconds < 10 {
                            self.second.text = "0" + "\(seconds)"
                        } else {
                            self.second.text = "\(seconds)"
                        }

                    }
                    timeout -= 1
                }
            })
            timer?.resume()
        }
    }
    
    @IBAction func calculateTime(_ sender: Any) {
        
    }
}


