//
//  LoginSignUpModel.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 20/06/24.
//

import Foundation
struct LoginSignUpModel {
    var email : String
    var password: String
    var id: String? = nil
    var country: String?
}

enum ValidationError: Error {
    case email
    case password
    
    case invalidEmail
    case invalidPassword
    case alreadyExist
    case userNotFound
    case invalidCredentials
    
    var message: String {
        switch self {
        case .email:
            return "Email can not blank."
        
        case .invalidEmail:
            return "Email is not valid."
            
        case .password:
            return "Password can not blank."
        case .invalidPassword:
            return "Minimum 8 Characters, At least 1 number, At least 1 Uppercase Character, At least 1 Special Character"
            
        case .alreadyExist:
            return "User is already exist."
            
        case .userNotFound:
            return "User Not Found!"
        case .invalidCredentials:
            return "Please enter valid credentials."
        }
    }
}
