//
//  CircleView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/14.
//

import SwiftUI

struct CircleView: View {
    
    @Binding var progress: CGFloat
    let lineWidth: CGFloat
    let strokeColor: Color
    let backgroundColor: Color
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 背景圆环
                Circle()
                    .stroke(backgroundColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .opacity(0.3) // 透明度设置为0.3，让背景稍微透明，更加美观
                
                // 进度条圆环
                // 由于SwiftUI的角度是从3点钟方向开始的，我们需要将其旋转90度，使之从12点钟方向开始
                Circle()
                    .trim(from: 0, to: progress) // 使用trim方法来绘制圆环的一部分
                    .stroke(strokeColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(Angle(degrees: -90)) // 旋转90度，使其从12点钟方向开始
                    .animation(.easeInOut, value: progress) // 添加动画效果
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        
//        GeometryReader { geometry in
//            ZStack(alignment: .leading) {
//                Arc(startAngle: .degrees(-90), endAngle: Angle(degrees: 270))
//                    .stroke(backgroundColor, style: .init(lineWidth: lineWidth, lineCap: .butt, lineJoin: .miter))
//                Arc(startAngle: .degrees(-90), endAngle: .degrees(-90 + 360 * Double(progress)))
//                    .stroke(strokeColor, style: .init(lineWidth: lineWidth, lineCap: .butt, lineJoin: .miter))
//                    .animation(.easeIn, value: progress)
//            }
//        }
        
        
    }
}

struct Arc: Shape {
    
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    
    var animatableData: CGFloat {
        get { CGFloat(endAngle.radians) }
        set { endAngle = Angle(radians: newValue) }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(
                center: .init(x: rect.midX, y: rect.midY),
                radius: rect.width / 2.0,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: clockwise)
        }
    }
}
