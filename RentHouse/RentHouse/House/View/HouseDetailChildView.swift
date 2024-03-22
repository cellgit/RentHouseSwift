//
//  HouseDetailChildView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/22.
//

import SwiftUI

struct HouseDetailChildView: View {
    
    @StateObject var viewModel: HouseDetailViewModel
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            ScrollView {
                
                
                HStack(alignment: .top, spacing: 10, content: {
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("\(viewModel.address)")
                        
                        Text("租金: \(viewModel.price)")
                        
                        Text("可租日期: \(viewModel.availableDate)")
                        
                        Text("租赁方式: \(viewModel.rentalMethod)")
                        
                        Text("朝向: \(viewModel.orientation)")
                        
                        Text("付款方式: \(viewModel.paymentMethod)")
                        
                        VStack (alignment: .leading){
                            Text("设备: ")
                            MultiFlowLayoutGridView(title: "", viewModel: MultiStringItemViewModel(items: viewModel.facilities))
                        }
                        
                        VStack (alignment: .leading){
                            Text("房源标签: ")
                            MultiFlowLayoutGridView(title: "", viewModel: MultiStringItemViewModel(items: viewModel.tags))
                        }
                        
                        
                        VStack (alignment: .leading){
                            Text("设备: ")
                            MultiFlowLayoutGridView(title: "", viewModel: MultiStringItemViewModel(items: viewModel.facilities))
                        }
                        
                        VStack (alignment: .leading){
                            Text("房源标签: ")
                            MultiFlowLayoutGridView(title: "", viewModel: MultiStringItemViewModel(items: viewModel.tags))
                        }
                        
                        
                        VStack (alignment: .leading){
                            Text("设备: ")
                            MultiFlowLayoutGridView(title: "", viewModel: MultiStringItemViewModel(items: viewModel.facilities))
                        }
                        
                        VStack (alignment: .leading){
                            Text("房源标签: ")
                            MultiFlowLayoutGridView(title: "", viewModel: MultiStringItemViewModel(items: viewModel.tags))
                        }
                        
                        
                    })
                    //            .padding(16)
                    Spacer()
                    
                })
                .padding(16)
            }
            
        })
        
        
        
        
        
        
        
    }
}

#Preview {
    
    let review = Review(user: "123", rating: 5, comment: "评价说:好房源不要错过哦")
    let house = House(price: 2500, rentalMethod: 1, community: "多蓝水岸蓝波苑", building: "4", city: "杭州", district: "钱塘区", citycode: "0571", unit: "1", houseNumber: "301", roomNumber: "A", status: 1, paymentMethod: ["1"], center: Center(lat: 40.0, lon: 120.1), location: nil, roomType: "1", area: 25, floor: 3, totalFloors: 6, decoration: 1, facilities: ["冰箱", "洗衣机", "热水器"], desc: "来吧,租房是你的选择", landlordId: nil, contact: "18298269522", orientation: "1", reviewStatus: "1", tags: ["近地铁", "好房源", "好房东"], leaseTerm: "一年", rating: 5, availableDate: "2024-08", petPolicy: true, moveInRequirements: "一家人", publishDate: "2024-03", reviews: [review], additionalFees: [], createdAt: "2024-03-22", updatedAt: "2024-03-22", id: "123")
    
    return HouseDetailChildView(viewModel: HouseDetailViewModel(model: House()))
}
