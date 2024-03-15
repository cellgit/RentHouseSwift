//
//  BottomSheetView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/15.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var showSheet: Bool
    let sheetHeight: CGFloat
    let content: Content

    init(showSheet: Binding<Bool>, sheetHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self._showSheet = showSheet
        self.sheetHeight = sheetHeight
        self.content = content()
    }

    var body: some View {
        VStack {
            Spacer()
            VStack {
                content
            }
            .frame(height: sheetHeight)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .offset(y: showSheet ? 0 : UIScreen.main.bounds.height)
        }
        .edgesIgnoringSafeArea(.all)
        .background(
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        self.showSheet = false
                    }
                }
        )
        .animation(.default)
    }
}
