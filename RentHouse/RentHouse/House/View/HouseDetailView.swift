//
//  HouseDetailView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/18.
//

import SwiftUI

struct HouseDetailView: View {
    
    let house: House
    
    @EnvironmentObject var tabBarState: TabBarStateManager
    
    var body: some View {
        
        NavigationLink {
            ProfileView()
        } label: {
            Text("Push")
        }

        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                withAnimation {
                    tabBarState.visible = .hidden
                }
                
//                tabBarState.visible = .hidden
            }
//            .onDisappear {
//                withAnimation {
//                    tabBarState.visible = .visible
//                }
//            }
    }
        
}

#Preview {
    HouseDetailView(house: House())
}
