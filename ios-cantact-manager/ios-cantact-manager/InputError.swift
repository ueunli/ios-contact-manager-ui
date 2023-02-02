//
//  ErrorManage.swift
//  ios-cantact-manager
//
//  Created by 조용현 on 2022/12/22.
//

import Foundation

enum InputError: String, Error {
    case invalidName = "이름"
    case invalidAge = "나이"
    case invalidTel = "연락처"
    case invalidInput = ""
    
    var localizedDescription: String {
        "입력한 \(self.rawValue) 정보가 잘못되었습니다"
    }
}
