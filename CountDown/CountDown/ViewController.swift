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
        //datePicker选择完毕
    }
    
    @IBAction func calculateTime(_ sender: Any) {
        
        print(datePicker.date)
        timer = nil
        //截止日期
        let endDate = datePicker.date
        //开始日期
        let startDate = Date()
        //时间间隔
        let timeInterval:TimeInterval = endDate.timeIntervalSince(startDate)
        
        if timer == nil {
            //剩余时间
            var timeout = timeInterval
            if timeout != 0 {
                
                //创建全局队列
                let queue = DispatchQueue.global()
                //在全局队列下创建一个时间源
                timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
                //设定循环的间隔是一秒,并且立即开始
                timer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: .seconds(1))
                //时间源出发事件
                timer?.setEventHandler(handler: {
                    //必须是当前日期往后的日期,在datePicker上也做了限制
                    if timeout <= 0 {
                        self.timer?.cancel()
                        self.timer = nil
                        DispatchQueue.main.async(execute: {
                            self.day.text = "00"
                            self.hour.text = "00"
                            self.minute.text = "00"
                            self.second.text = "00"
                        })
                    } else {
                        //计算剩余时间
                        let days = Int(timeout) / (3600 * 24)
                        if days == 0 {
                            self.day.text = ""
                        }
                        let hours = (Int(timeout) - Int(days) * 24 * 3600) / 3600
                        let minutes = (Int(timeout) - Int(days) * 24 * 3600 - Int(hours) * 3600) / 60
                        let seconds = Int(timeout) - Int(days) * 24 * 3600 - Int(hours) * 3600 - Int(minutes) * 60
                        //主队列中刷新UI
                        DispatchQueue.main.async(execute: {
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
                        })
                        timeout -= 1
                    }
                })
                //启动时间源
                timer?.resume()
            }
        }
    }
}
