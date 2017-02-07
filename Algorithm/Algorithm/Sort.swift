//
//  Sort.swift
//  Algorithm
//
//  Created by ShaoFeng on 2016/12/21.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

import UIKit

class Sort: NSObject {
    
    /// 快速排序
    ///
    /// - Parameters:
    ///   - mArray: 要排序的数组
    ///   - leftIndex: 第一个元素索引
    ///   - rightIndex: 最后一个元素索引
    public func quickSort(mArray: inout Array<Int>, leftIndex:  Int, rightIndex:  Int) {
        if leftIndex < rightIndex {
            var left = leftIndex
            var right = rightIndex
            let temp = getMiddleIndex(mArray: &mArray, leftIndex: &left, rightIndex: &right)
            quickSort(mArray: &mArray, leftIndex: leftIndex, rightIndex: temp - 1)
            quickSort(mArray: &mArray, leftIndex: temp + 1, rightIndex: rightIndex)
        }
    }
    
    private func getMiddleIndex(mArray: inout Array<Int>, leftIndex: inout Int, rightIndex: inout Int) -> (Int) {
        let tempValue = mArray[leftIndex]
        while leftIndex < rightIndex {
            
            while leftIndex < rightIndex && tempValue <= mArray[rightIndex] {
                rightIndex -= 1
            }
            if leftIndex < rightIndex {
                mArray[leftIndex] = mArray[rightIndex]
            }
            while leftIndex < rightIndex && mArray[leftIndex] <= tempValue {
                leftIndex += 1
            }
            if leftIndex < rightIndex {
                mArray[rightIndex] = mArray[leftIndex]
            }
        }
        mArray[leftIndex] = tempValue
        return leftIndex
    }
    
    /// 冒泡排序
    ///
    /// - Parameter mArray: 要排序的数组
    public func bubbleSort(mArray: inout Array<Int>) {
        for i in 0..<(mArray.count - 1) {
            for j in 0..<(mArray.count - i - 1) {
                if mArray[j] > mArray[j + 1] {
                    //交换元素位置
                    (mArray[j],mArray[j + 1]) = (mArray[j + 1],mArray[j])
                }
            }
        }
    }
    
    /// 选择排序
    ///
    /// - Parameter mArray: 要排序的数组
    public func selectSort(mArray: inout Array<Int>) {
        for i in 0..<mArray.count {
            var minIndex = i
            for j in (i + 1)..<mArray.count {
                if mArray[minIndex] > mArray[j] {
                    minIndex = j
                }
            }
            if minIndex != i {
                (mArray[i],mArray[minIndex]) = (mArray[minIndex],mArray[i])
            }
        }
    }
    
    /// 直接插入排序
    ///
    /// - Parameter mArray: 要排序的数组
    public func insertSort(mArray: inout Array<Int>) {
        for i in 0..<mArray.count - 1 {
            if mArray[i + 1] < mArray[i] {
                let temp = mArray[i + 1]
                for j in (1...(i + 1)).reversed() {
                    if mArray[j - 1] > temp {
                        (mArray[j - 1],mArray[j]) = (mArray[j],mArray[j - 1])
                    }
                }
            }
        }
    }
    
    /*
     - (void)binaryInsertSort:(NSMutableArray *)mArray
     {
     //索引从1开始 默认让出第一元素为默认有序表 从第二个元素开始比较
     for(int i = 1 ; i < [mArray count] ; i++){
     //二分查找
     int temp= [[mArray objectAtIndex:i] intValue];
     int left = 0;
     int right = i - 1;
     while (left <= right) {
     int middle = (left + right)/2;
     if(temp < [[mArray objectAtIndex:middle] intValue]){
     right = middle - 1;
     } else {
     left = middle + 1;
     }
     }
     //排序
     for(int j = i ; j > left; j --){
     [mArray replaceObjectAtIndex:j withObject:[mArray objectAtIndex:j - 1]];
     }
     [mArray replaceObjectAtIndex:left withObject:[NSNumber numberWithInt:temp]];
     }
     }

     */
    
    /// 二分法插入排序
    ///
    /// - Parameter mArray: 要排序的数组
    public func binaryInsertSort(mArray: inout Array<Int>) {
        for i in 1..<mArray.count {
            let temp = mArray[i]
            var left = 0
            var right = i - 1
            while left <= right {
                let middle = (left + right) / 2
                if temp < mArray[middle] {
                    right = middle - 1
                } else {
                    left = middle + 1
                }
            }
            
            //有错~
            for j in (left + 1...i).reversed() {
                mArray[j] = mArray[j - 1]
            }
            mArray[left] = temp
        }
    }
    
    /// 希尔排序
    ///
    /// - Parameter mArray: 要排序的数组
    public func shellSort(mArray: inout Array<Int>) {
        var gap = mArray.count / 2
        while gap >= 1 {
            for i in gap..<mArray.count {
                let temp = mArray[i]
                var j = i
                while j >= gap && temp < mArray[j - gap] {
                    mArray[j] = mArray[j - gap]
                    j -=  gap
                }
                mArray[j] = temp
            }
            gap = gap / 2
        }
    }
}
