//
//  Test.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/6.
//

import Foundation

func calculate(_ n: Int) -> Int {
    // 0和1只需1步
    guard n > 1 else {
        return n
    }
    
    var list = [Int](repeating: 0, count: n+1)
    
    list[0] = 1
    list[1] = 1
    
    for i in 2...n {
        list[i] = list[i-1] + list[i-2]
    }
    
    return list[n]
}


func calculate2(_ n: Int) -> Int {
    
    guard n > 1 else {
        return n
    }
    
    var list = [Int](repeating: 0, count: n+1)
    
    
    for i in 2...n {
        list[i] = list[i-1] + list[i-2]
    }
    
    return list[n]
}





func sort1(_ list: inout [Int]) {
    let n = list.count
    for i in 0..<n {
        for j in 0..<(n-i-1) {
            if list[j] > list[j+1] {
                list.swapAt(j, j+1)
            }
        }
    }
}

