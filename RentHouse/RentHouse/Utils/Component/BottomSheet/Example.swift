//
//  Example.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/21.
//

import SwiftUI

public struct P8_BottomSheet: View {
    
    @State private var isOpen: Bool = false
    
    @State private var minArea: Double = 38
    @State private var maxArea: Double = 300
    @State private var radius: Double = 16
    
    @State private var backgroundDisabled: Bool = true
    @State private var backgroundColor: Color = Color.black.opacity(0.16)
    
    @State private var contentCoverColor: Color = .blue//Color.fabulaBack0
    @State private var contentBGColor: Color = .secondary//Color.fabulaBar2
    
    @State private var indicatorMin: Double = 4
    @State private var indicatorMax: Double = 34
    @State private var indicatorColor: Color = .primary//Color.fabulaPrimary
    @State private var indicatorBGColor: Color = .teal//Color.fabulaBar1
    
    private var constants: SheetConstants {
        SheetConstants(
            minArea: minArea,
            maxArea: maxArea,
            radius: radius,
            
            backgroundDisabled: backgroundDisabled,
            backgroundColor: backgroundColor,
            
            contentCoverColor: contentCoverColor,
            contentBGColor: contentBGColor,
            
            indicatorMin: indicatorMin,
            indicatorMax: indicatorMax,
            indicatorColor: indicatorColor,
            indicatorBGColor: indicatorBGColor
        )
    }
    
    public init() {}
    public var body: some View {
        ZStack {
            Form {
                Section(header: Text("Standard")) {
                    FabulaSlider(value: $minArea, title: "minArea", min: 24, max: 60)
                    FabulaSlider(value: $maxArea, title: "maxArea", min: 200, max: 500)
                    FabulaSlider(value: $radius, title: "radius", min: 0, max: minArea / 2)
                }
                
                Section(header: Text("Background")) {
                    FabulaToggle("backgroundDisabled", isOn: $backgroundDisabled)
                    FabulaColorPicker("backgroundColor", selection: $backgroundColor)
                }
                
                Section(header: Text("Content")) {
                    FabulaColorPicker("contentBGColor", selection: $contentBGColor)
                    FabulaColorPicker("contentCoverColor", selection: $contentCoverColor)
                }
                
                Section(header: Text("Indicator")) {
                    FabulaSlider(value: $indicatorMin, title: "indicatorMin", min: 0, max: 10)
                    FabulaSlider(value: $indicatorMax, title: "indicatorMax", min: 0, max: 80)
                    FabulaColorPicker("indicatorColor", selection: $indicatorColor)
                    FabulaColorPicker("indicatorBGColor", selection: $indicatorBGColor)
                }
            }
#if os(macOS)
            .background(Color.fabulaBackWB100.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
#endif
            .frame(maxWidth: 500)
            .padding(.bottom, minArea)
            
            GeometryReader { proxy in
                BottomSheet(isOpen: $isOpen, constants: constants) {
//                    DummyView(direction: .horizontal)
                }
            }
        }
    }
}
