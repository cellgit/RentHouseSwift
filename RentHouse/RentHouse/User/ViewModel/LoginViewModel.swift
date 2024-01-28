//
//  LoginViewModel.swift
//  RentHouse
//
//  Created by liuhongli on 2024/1/28.
//

import Foundation
import Foundation
import Combine


/*
 {
   "code": 200,
   "message": "验证码发送成功",
   "data": {
     "msg": "用户登录成功",
     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1YTUwN2RmYzg1ZTJhZGI0YzgxZDczMyIsImlhdCI6MTcwNjQyODU0OCwiZXhwIjoxNzEwMDI4NTQ4fQ.0DBdS0nayRew_UcQ4khwStxK1ZRKlduN6ccSMPFtgyU",
     "isNewUser": false,
     "phone": "18298269522"
   }
 }
 */

class LoginViewModel: ObservableObject {
    @Published var phone: String = ""
    @Published var code: String = ""
    private var cancellables = Set<AnyCancellable>()

    func getVerificationCode() {
        NetworkManager.shared.request(AuthAPI.sendCode(phone: phone))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // 请求完成
                    break
                case .failure(let error):
                    // 错误处理
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { (response: JsonResponse) in
                // 成功获取验证码
                print("成功获取验证码,请查看手机: \(response.message)")
                // 这里可以继续处理如保存 token 等操作
            })
            .store(in: &cancellables)
    }
    
    
    func login() {
        NetworkManager.shared.request(AuthAPI.login(phone: phone, code: code))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // 请求完成
                    break
                case .failure(let error):
                    // 错误处理
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { (response: User) in
                // 登录成功
                print("Verification code response: \(response)")
                // 这里可以继续处理如保存 token 等操作
            })
            .store(in: &cancellables)
    }
    
    
    
}
