//
//  Binding+extension.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/11.
//

import Foundation
import SwiftUI

extension Binding {
    static func safeUnwrap<T>(_ binding: Binding<T?>, defaultValue: T) -> Binding<T> {
        return Binding<T>(
            get: { binding.wrappedValue ?? defaultValue },
            set: { binding.wrappedValue = $0 }
        )
    }
}
