//
//  FabulaToggle.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/21.
//

import SwiftUI

struct FabulaToggleStyle: ToggleStyle {
    
    @GestureState private var translation: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    
    static let minWidth: CGFloat = 52
    static let minHeight: CGFloat = 32
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Capsule()
                .fill(configuration.isOn ? Color.primary : Color.green.opacity(0.5))
            ZStack {
                GeometryReader { proxy in
                    Color.clear
                    Capsule()
                        .stroke(Color.black.opacity(0.1), lineWidth: proxy.size.height * 0.1)
                        .padding(-((proxy.size.height * 0.1) / 2))
                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.2), radius: proxy.size.height * 0.03, x: (proxy.size.height * 0.03) / 2, y: (proxy.size.height * 0.03) / 2)
                }
            }
            .mask(
                Capsule()
            )
            
            Rectangle()
                .fill(Color.clear)
                .overlay(
                    GeometryReader { proxy in
                        ZStack{
                            Circle().fill(Color.blue)
                                .frame(width: getThumbSize(proxy))
                                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.2), radius: proxy.size.height * 0.05)
                                .overlay(
                                    ZStack {
                                        Image(systemName: "poweron")
                                            .font(.custom("Helvetica Bold", size: proxy.size.height * 0.36))
                                            .foregroundColor(Color.primary)
                                            .opacity(configuration.isOn ? 1 : 0)
                                            .scaleEffect(configuration.isOn ? 1 : 0.2)
                                        Image(systemName: "poweroff")
                                            .font(.custom("Helvetica Bold", size: proxy.size.height * 0.36))
                                            .foregroundColor(Color.blue.opacity(0.8))
                                            .opacity(configuration.isOn ? 0 : 1)
                                            .scaleEffect(configuration.isOn ? 0.2 : 1)
                                    }
                                )
                                .rotation3DEffect(Angle(degrees: configuration.isOn ? 0 : -270), axis: (x: 0, y: 0, z:1))
                        }
                        .offset(x: configuration.isOn ? proxy.frame(in: .local).maxX - (getThumbSize(proxy) * 1.06) : proxy.frame(in: .local).minX + (proxy.size.height - getThumbSize(proxy) * 1.06))
                    }
                        .highPriorityGesture( // 하위 onTapGesture 제스처보다 우선순위를 높이기 위해 highPriorityGesture 사용
                            DragGesture().updating(self.$translation) { value, state, _ in
                                state = value.translation.width
                            }
                                .onChanged{ value in
                                    withAnimation(.customSpring) {
                                        configuration.isOn = value.translation.width > 0
                                    }
                                }
                                .onEnded{ value in
                                    
                                }
                                            )
                )
                .clipShape(Capsule())
        }
        .onTapGesture(count: 1) {
            withAnimation(Animation.customSpring) {
                configuration.isOn.toggle()
            }
        }
        .frame(minWidth: FabulaToggleStyle.minWidth, minHeight: FabulaToggleStyle.minHeight)
        
    }
    
    private func getThumbSize(_ proxy: GeometryProxy) -> CGFloat {
        proxy.size.height - proxy.size.height * 0.1
    }
}

struct FabulaToggle: View {
    
    private let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
#if os(macOS)
            Toggle(title, isOn: $isOn)
#else
            Text(title)
            Spacer()
            Toggle(title, isOn: $isOn)
                .frame(width: 52, height: 32)
                .toggleStyle(FabulaToggleStyle())
#endif
            
        }
    }
    
    init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        _isOn = isOn
    }
}
