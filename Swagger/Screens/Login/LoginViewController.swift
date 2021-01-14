//
//  LoginViewController.swift
//  Swagger
//
//  Created by Philip on 11.01.2021.
//

import Foundation
import UIKit

enum AuthorizationType {
    case login
    case signup
}

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private lazy var userInfoTextFields = [nameTextField, emailTextField, passwordTextField]
    
    private let provider = ServiceProvider<SwaggerAPIService>()
    
    private var authorizationType: AuthorizationType = .login
    
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAuthotizationType(.login)
        passwordTextField.isSecureTextEntry = true
    }

    // MARK: - setup methods
    
    private func setupAuthotizationType(_ type: AuthorizationType) {
        authorizationType = type
        
        switch type {
        case .login:
            nameTextField.isHidden = true
            loginButton.setTitle("Login", for: .normal)
            emailTextField.text = DataStore.shared.read(type: .email) ?? ""
            passwordTextField.text = DataStore.shared.read(type: .password) ?? ""
        case .signup:
            nameTextField.isHidden = false
            loginButton.setTitle("Sign up", for: .normal)
            emailTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    private func saveUserAuthInfo(authModel: LoginModel) {
        if let email = emailTextField.text {
            DataStore.shared.write(value: email, type: .email)
        }
        if let password = passwordTextField.text {
            DataStore.shared.write(value: password, type: .password)
        }
        if let accessToken = authModel.accessToken {
            DataStore.shared.write(value: accessToken, type: .accessToken)
        }
    }
    
    // MARK: - UI methods
    
    private func checkUserFieldsFilled() -> Bool {
        switch authorizationType {
        case .login:
            return !(emailTextField.text?.isEmpty ?? false || passwordTextField.text?.isEmpty ?? false)
        case .signup:
            return !(emailTextField.text?.isEmpty ?? false || passwordTextField.text?.isEmpty ?? false || nameTextField.text?.isEmpty ?? false)
        }
    }
    
    private func highlightEmptyFields() {
        let animationDuration: TimeInterval = 0.25
        let errorColor = #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 0.3526862158)

        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.userInfoTextFields.forEach { field in
                field?.backgroundColor = field?.text?.isEmpty ?? false ? errorColor : .white
            }
        }
        UIView.animate(withDuration: animationDuration, delay: animationDuration) { [weak self] in
            self?.userInfoTextFields.forEach { $0?.backgroundColor = .white }
        }
    }
    
    private func setupUserInfoFields(isEnabled enabled: Bool) {
        userInfoTextFields.forEach {
            $0?.isUserInteractionEnabled = enabled
            $0?.alpha = enabled ? 1.0 : 0.5
        }
    }
    
    // MARK: API requests
    
    private func login() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        
        provider.load(service: .login(email: email, password: password), decodeType: ResponseModel<LoginModel>.self) { [weak self] result in
            self?.handleAuthorizationResult(result)
        }
    }
    
    private func signup() {
        provider.load(service: .signUp(name: nameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? ""), decodeType: ResponseModel<LoginModel>.self) { [weak self] result in
            self?.handleAuthorizationResult(result)
        }
    }
    
    // MARK: API handlers
    
    private func handleAuthorizationResult(_ result: CustomResult<LoginModel>) {
        setupUserInfoFields(isEnabled: true)
        
        switch result {
        case .success(let login):
            self.saveUserAuthInfo(authModel: login)
            self.pushTableViewController()
        case .failure(let errors):
            let errors1 = errors as? [ResponseError]
            errors1?.forEach { print("Error \($0.status): \($0.name). \($0.message)") }
        case .empty:
            print("Null response")
        }
    }
    
    
    // MARK: - navigation
    
    private func pushTableViewController() {
        guard let tableVC = self.initControllerFromStoryboard(of: TableViewController.self) as? TableViewController else { return }
        self.navigationController?.pushViewController(tableVC, animated: true)
    }
    
    // MARK: - @IBAction
    
    @IBAction private func onLoginButtonTapped(_ sender: Any) {
        
        guard checkUserFieldsFilled() else {
            return highlightEmptyFields()
        }
        
        setupUserInfoFields(isEnabled: false)
        
        switch authorizationType {
        case .login:
            login()
        case .signup:
            signup()
        }
    }
    
    @IBAction private func onChangeAuthButtonTapped(_ sender: Any) {
        let authType: AuthorizationType = authorizationType == .login ? .signup : .login
        setupAuthotizationType(authType)
    }
    
}
