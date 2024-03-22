//
//  FabulaSectionModifier.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/21.
//

import SwiftUI

struct FabulaSectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
            .foregroundColor(Color.teal.opacity(0.5))
            .frame(height: 32)
    }
}
