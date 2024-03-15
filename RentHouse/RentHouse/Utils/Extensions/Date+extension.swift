//
//  Date+extension.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/15.
//

import Foundation

extension Date {
    
    // 移除时间部分，只保留年月日
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    // 获取给定年月的第一天
    static func startOfMonth(year: Int, month: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        return Calendar.current.date(from: components)
    }
    
    // 获取月份的天数
    func daysInMonth() -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: self)!
        return range.count
    }
    
    // 获取给定月份的所有日期
    static func datesInMonth(year: Int, month: Int) -> [Date] {
        guard let startOfMonth = startOfMonth(year: year, month: month) else {
            return []
        }
        
        let daysCount = startOfMonth.daysInMonth()
        let dates = (0..<daysCount).compactMap { day -> Date? in
            return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth)
        }
        
        return dates
    }
}
