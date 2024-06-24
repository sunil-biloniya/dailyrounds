//
//  LoginSignUpVC.swift
//  Dailyrounds
//
//  Created by sunil biloniya on 20/06/24.
//

import UIKit

class LoginSignUpVC: UIViewController {
    static func storyboardInstance() -> LoginSignUpVC {
        return LoginSignUpVC(nibName: String.className(self), bundle: nil)
    }
    /// outlets
    @IBOutlet weak var lblLetsGo: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var textEmail: TextFieldView!
    @IBOutlet weak var textPassward: TextFieldView!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var stackPassInstruction: UIStackView!
    
    lazy var viewModel: LoginSignUpViewModel = LoginSignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpData()
        self.setupViewModel()
        if viewModel.loginType == .signup {
            self.startLoading(sender: self.view)
            self.viewModel.fetchCountry()
        }
    }
    ///  textfield placehoder or picker view data source and delegate
    private func setUpData(){
        self.countryPicker.isHidden = viewModel.loginType == .login
        self.stackPassInstruction.isHidden = viewModel.loginType == .login
        self.lblLetsGo.text = viewModel.buttonTitle
        self.lblMessage.text = viewModel.message
        self.textEmail.setUp(title: "Email", key: .emailAddress)
        self.textPassward.setUp(title: "Password")
        self.countryPicker.dataSource = self
        self.countryPicker.delegate = self
        
    }
    /// viewModel events
    private func setupViewModel() {
        /// on success
        viewModel.onUpdate = { [weak self] in
            if let self = self {
                self.countryPicker.reloadAllComponents()
                self.stopLoading(sender: self.view)
                // scroll at user country
                if let index = viewModel.countryList.firstIndex(where: { $0.country == self.viewModel.currentCountry ?? "" }) {
                    self.countryPicker.selectRow(index, inComponent: 0, animated: true)
                }
            }
        }
        /// for errors
        viewModel.onError = { error in
            // Handle error appropriately (e.g., show an alert)
            debugPrint("Error fetching books: \(error)")
            self.showAlert(with: error)
        }
    }

}
/// button actions
extension LoginSignUpVC {
    /// click on back button
    @IBAction func didTapBack(_ sender: Any) {
        self.pop()
    }
    /// click on lets go or login
    @IBAction func didTapLetsGo(_ sender: Any) {
        viewModel.signup(request: LoginSignUpModel(email: textEmail.text.text ?? "",
                                                password: textPassward.text.text  ?? ""))
        
        if viewModel.errorMsg?.isEmpty == false {
            self.showAlert(with: viewModel.errorMsg ?? "")
        }
        
        viewModel.onUpdate = { [weak self] in
            if let self = self {
                if self.viewModel.loginType == .login {
                    self.signIn()
                } else {
                    self.signUp()
                }
            }
        }
    }
}
extension LoginSignUpVC {
    /// sign up proccess
    private func signUp(){
        let id = viewModel.generateRandomNumber(range:  1...1000)
        let user = LoginSignUpModel(email: textEmail.text.text ?? "",
                                    password: textPassward.text.text ?? "",
                                    id: "\(id)", country: viewModel.currentCountry
        )
        if CoreDataManager.shared.addUser(user) {
            UserDefaults.standard.setValue(user.id, forKey: "users")
            RootView.shared.setRoot(BookMarkVC.storyboardInstance())
        } else {
            self.showAlert(with: "Sign up failed")
        }
    }
    /// sign in proccess
    private func signIn(){
        let users = CoreDataManager.shared.fetchUsers()
        if let user = users.first(where: { $0.email == textEmail.text.text ?? "" }) {
            UserDefaults.standard.setValue(user.id, forKey: "users")
            RootView.shared.setRoot(BookMarkVC.storyboardInstance())
        } else {
            self.showAlert(with: ValidationError.userNotFound.message)
        }
    }
    
}
// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension LoginSignUpVC:  UIPickerViewDataSource & UIPickerViewDelegate {
    /// number of sections
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    /// number of items
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return viewModel.countryList.count
    }
    /// display data
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.countryList[row].country
    }
    /// data selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if viewModel.countryList.count > 0 {
            viewModel.currentCountry = viewModel.countryList[row].country
        }
    }
}
