//
//  ViewController.swift
//  Algorithm
//
//  Created by ShaoFeng on 2016/12/21.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var mArray:Array = [6,5,8,1,9,8,0,6,9,7,2]
        let sort = Sort()
        print("排序前\(mArray)")
        
        //快速排序
//        sort.quickSort(mArray: &mArray,leftIndex: 0,rightIndex: mArray.count - 1)
        
        //冒泡排序
//        sort.bubbleSort(mArray: &mArray)
        
        //选择排序
//        sort.selectSort(mArray: &mArray)
        
        //简单插入排序
//        sort.insertSort(mArray: &mArray)
        
        //二分法插入排序
        sort.binaryInsertSort(mArray: &mArray)
        
        //希尔排序
//        sort.shellSort(mArray: &mArray)
        print("排序后\(mArray)")
    }
}

