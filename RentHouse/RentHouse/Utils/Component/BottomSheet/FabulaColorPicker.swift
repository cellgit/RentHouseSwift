//
//  FabulaColorPicker.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/21.
//

import SwiftUI

struct FabulaColorPicker: View {
    
    private let title: String
    @Binding var selection: Color
    
    var body: some View {
        HStack(spacing: 0) {
            ColorPicker(title, selection: $selection)
        }
    }
    
    init(_ title: String, selection: Binding<Color>) {
        self.title = title
        _selection = selection
    }
}
