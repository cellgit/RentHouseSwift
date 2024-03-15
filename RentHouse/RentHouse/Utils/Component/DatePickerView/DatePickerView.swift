//
//  DatePickerView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/15.
//

import SwiftUI

class DateSelectionViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
}

struct CustomDatePickerView: View {
    @ObservedObject var viewModel: DateSelectionViewModel
    let startDate: Date
    let endDate: Date
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }

    init(viewModel: DateSelectionViewModel) {
        self.viewModel = viewModel

        // 设置日期范围为当前年和下一年
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 1
        if let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date())) {
            startDate = startOfYear
            endDate = calendar.date(byAdding: components, to: startDate)!
        } else {
            // 默认范围，防止初始化失败
            startDate = Date()
            endDate = Date()
        }
    }

    var body: some View {
        VStack {
            Text("选中的日期: \(dateFormatter.string(from: viewModel.selectedDate))")
            DatePicker(
                "选择日期",
                selection: $viewModel.selectedDate,
                in: startDate...endDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .frame(maxHeight: 400)
        }
        .padding([.top], 16)
        .padding(.horizontal, 4)
    }
}



//struct CustomDatePickerView: View {
//    @ObservedObject var viewModel: DateSelectionViewModel
//    let startDate: Date
//    let endDate: Date
//
//    init(viewModel: DateSelectionViewModel) {
//        self.viewModel = viewModel
//
//        // 设置日期范围为当前年和下一年
//        let calendar = Calendar.current
//        var components = DateComponents()
//        components.year = 1
//        if let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date())) {
//            startDate = startOfYear
//            endDate = calendar.date(byAdding: components, to: startDate)!
//        } else {
//            // 默认范围，防止初始化失败
//            startDate = Date()
//            endDate = Date()
//        }
//    }
//
//    var body: some View {
//        VStack {
//            DatePicker(
//                "选择日期",
//                selection: $viewModel.selectedDate,
//                in: startDate...endDate,
//                displayedComponents: [.date]
//            )
//            .datePickerStyle(GraphicalDatePickerStyle())
//            .frame(maxHeight: 400)
//            Text("选中的日期: \(viewModel.selectedDate.formatted(date: .long, time: .omitted))")
//        }
//    }
//}


