//
//  ItemGroupView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/22.
//

import SwiftUI

struct ItemGroupView: View {
    
    @Binding var title: String
    
    @Binding var subtitle: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 8, content: {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            Text(subtitle)
                .foregroundColor(.secondary)
        })
        
    }
}

#Preview {
    ItemGroupView(title: .constant("整租"), subtitle: .constant("方式"))
}
