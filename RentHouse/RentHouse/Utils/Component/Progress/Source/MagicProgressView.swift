//
//  MagicProgressView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/14.
//

import SwiftUI

public struct MagicProgressView: View {

    public enum IndicatorType {
        case `default`(progress: Binding<CGFloat>)
        case circle(progress: Binding<CGFloat>, lineWidth: CGFloat, strokeColor: Color, backgroundColor: Color = .clear)
    }

    @Binding var isVisible: Bool
    var type: IndicatorType

    public init(isVisible: Binding<Bool>, type: IndicatorType) {
        self._isVisible = isVisible
        self.type = type
    }

    public var body: some View {
        if isVisible {
            indicator
        } else {
            EmptyView()
        }
    }
    
    // MARK: - Private
    
    private var indicator: some View {
        ZStack {
            switch type {
            case .`default`(let progress):
                DefaultSectorView(progress: progress)
            case .circle(let progress, let lineWidth, let strokeColor, let backgroundColor):
                CircleView(progress: progress, lineWidth: lineWidth, strokeColor: strokeColor, backgroundColor: backgroundColor)
            }
        }
    }
}

