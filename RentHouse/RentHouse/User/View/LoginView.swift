//
//  LoginView.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Code", text: $viewModel.code)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Get Verification Code") {
                viewModel.getVerificationCode()
            }
            .padding()
            
            Button("Login with Code") {
                viewModel.login()
            }
            .padding()
        }
        .padding()
    }
}
