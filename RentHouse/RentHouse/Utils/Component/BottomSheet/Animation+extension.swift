//
//  Animation+extension.swift
//  RentHouse
//
//  Created by liuhongli on 2024/3/21.
//

import SwiftUI

extension Animation {
    static var customSpring: Animation {
       self.spring(response: 0.28, dampingFraction: 0.8, blendDuration: 0.86)
    }
}
