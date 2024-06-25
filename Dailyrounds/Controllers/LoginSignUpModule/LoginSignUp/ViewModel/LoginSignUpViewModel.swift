//
//  LoginSignUpViewModel.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 20/06/24.
//

import Foundation
/// login type enumeration
enum LoginSignUp {
    case login
    case signup
}

class LoginSignUpViewModel {
    /// variables
    var loginType: LoginSignUp = .login
    var buttonTitle: String {
        return loginType == .login ? "Login" : "Let's go"
    }
    
    var message: String {
        return loginType == .login ? "log in to continue" : "sign up to continue"
    }
    
    var countryList: [CountryData] = []
    
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var errorMsg: String? = nil
    
    /// static messages
    private let msg = "Something went wrong!"
    private let internetConnection = "Internet connection appears offline."
    /// sign up request
    func signup(request: LoginSignUpModel) {
        if let msg = validate(request: request)?.message, msg.isEmpty == false {
            errorMsg = msg
        } else {
            self.onUpdate?()
        }
    }
    
    
    
    /// get country api request
    func fetchCountry() {
        if Reachability.isConnectedToNetwork() {
            let urlString = "https://api.first.org/data/v1/countries"
            guard let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    self.onError?(self.msg)
                }
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    DispatchQueue.main.async {
                        self.onError?(error.localizedDescription)
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.onError?(self.msg)
                    }
                    return
                }
                
                // Print the raw JSON response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response: \(jsonString)")
                }
                /// error handling by do-catch
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ResponseData.self, from: data)
                    DispatchQueue.main.async {
                        self.countryList = response.data.map({$0.value})
                        if let algeria = response.data["DZ"] {
                            self.countryList.append(algeria)
                        }
                        self.onUpdate?()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.onError?(error.localizedDescription)
                    }
                    debugPrint("Error decoding JSON: \(error)")
                }
            }
            task.resume()
        } else {
            DispatchQueue.main.async {
                self.onError?(self.internetConnection)
            }
        }
    }
    
    /// get user country
    var currentCountry : String? {
        didSet {
            if let countryCode = Locale.current.regionCode,
               let countryName = Locale.current.localizedString(forRegionCode: countryCode) {
                currentCountry = countryName
            } else {
                currentCountry = nil
            }
        }        
    }
   
}
extension LoginSignUpViewModel {
    /// textfiled validations
    private func validate(request: LoginSignUpModel)-> (ValidationError?) {
        if request.email.isEmptyStr {
            return .email
        }
        
        if !isValidEmail(request.email) {
            return .invalidEmail
        }
        
        if request.password.isEmptyStr {
            return .password
        }
        
        if isValidPassword(request.password) {
            return .invalidPassword
        }
        
        if loginType == .signup {
            let users = CoreDataManager.shared.fetchUsers()
            if users.contains(where: {$0.email == request.email}) {
                return .alreadyExist
            }
        } else {
            if loginType == .login {
                let users = CoreDataManager.shared.fetchUsers()
                if let user = users.first(where: { $0.email == request.email }) {
                    if user.password != request.password {
                        return .invalidCredentials
                    }
                } else {
                    return .userNotFound
                }
            }
        }
        
        return nil
    }
}


extension LoginSignUpViewModel {
    /// check valid email like abc@gmail.com

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    /// check valid password like Abc@1234
    private func isValidPassword(_ password:String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-\\[\\]{};':\"\\\\|,.<>/?]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return !passwordTest.evaluate(with: password)
    }
    
    /// rendom number generatoion for unique  id
    func generateRandomNumber(range: ClosedRange<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound + 1))) + range.lowerBound
    }
}

