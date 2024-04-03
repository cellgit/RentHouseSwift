//
//  HouseDetailChildView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/22.
//

import SwiftUI
import MapKit

struct HouseDetailChildView: View {
    
    @StateObject var viewModel: HouseDetailViewModel
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            ScrollView {
                
                
                HStack(alignment: .top, spacing: 16, content: {
                    
                    VStack(alignment: .leading, spacing: 16, content: {
                        
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(viewModel.price)")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text("元/(\(viewModel.paymentMethod.first ?? "月付"))")
                                .font(.title2)
                                .foregroundColor(.orange)
                        }
                        
                        
                        HStack(alignment: .center, spacing: 16, content: {
                            ItemGroupView(title: $viewModel.roomType, subtitle: $viewModel.rentalMethod)
                            
                            ItemGroupView(title: $viewModel.orientation, subtitle: .constant("朝向"))
                            
                            ItemGroupView(title: $viewModel.status, subtitle: .constant("状态"))
                        })
                        
                        Text("可租日期: \(viewModel.availableDate)")
                        
                        
                        /* WWDC: 地图API使用
                         https://developer.apple.com/videos/play/wwdc2023/10043/
                         */
                        VStack(alignment: .leading, spacing: 12, content: {
                            Text(viewModel.address)
                            
                            
//                            Map {
//                                Annotation("Parking", coordinate: viewModel.coordinate) {
//                                    Image(systemName: "mappin.and.ellipse.circle.fill")
//                                }
//                                .annotationTitles(.hidden)
//
//                            }
//                            .mapStyle(.standard)
//                            .frame(height: 150) // 设置高度为200，宽度自适应
//                            .cornerRadius(10) // 可选，为地图添加圆角
                            
                            /* 使用MapContentBuilder创建地图
                             MapCameraBounds:
                             minimumDistance指的是相机距离地面的最小距离。在此距离内，用户无法进一步放大地图视图。
                             maximumDistance指的是相机距离地面的最大距离。在此距离外，用户无法进一步缩小地图视图。
                             */
                            //$viewModel.position.camera?.centerCoordinate
                            Map(position: $viewModel.position, bounds: MapCameraBounds(minimumDistance: 10, maximumDistance: 50000)) {
                                UserAnnotation()
                                Annotation("房源", coordinate: viewModel.coordinate) {
                                    // house.and.flag.fill
                                    // mappin.and.ellipse.circle.fill
//                                    Image(systemName: "house.and.flag.fill")
//                                        .foregroundColor(.blue)
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(.background)
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.secondary, lineWidth: 3)
                                            .foregroundColor(.blue)
                                        Image(systemName: "house.and.flag.fill")
                                            .padding(5)
                                            .foregroundColor(.blue)
                                    }
                                    
                                }
                                .annotationTitles(.visible)
                            }
                            .frame(height: 150) // 设置高度为200，宽度自适应
                            .cornerRadius(10) // 可选，为地图添加圆角
                            .disabled(false)
                            
                        })
                        .padding(16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(10)
                        
                        
                        
                        VStack (alignment: .leading){
                            Text("设备: ")
                            MultiLabelFlowLayout(items: viewModel.facilities, spacing: 4)
                        }
                        .padding(.vertical, 8)
                        
                        VStack (alignment: .leading){
                            Text("房源标签: ")
                            MultiLabelFlowLayout(items: viewModel.tags, spacing: 4)
                        }
                        .padding(.vertical, 8)
                        
                        
                    })
                    //            .padding(16)
//                    Spacer()
                    
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






