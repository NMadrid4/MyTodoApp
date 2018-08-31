//
//  SignUpViewController.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 7/07/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

protocol SignUpControlDelegate{
    func dismissMyModal(value: Bool)
}

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var rePasswordErrorLabel: UILabel!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorMessageLabel: UILabel!
    @IBOutlet weak var rePasswordErrorMessageLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var controlDelegate: SignUpControlDelegate?
    var blurEffectView: UIVisualEffectView!
    
    var fieldsValidated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        signUpButton.layer.cornerRadius = 4.0
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: backgroundView.bounds.width, height: backgroundView.bounds.height)
        layer.colors = [UIColor(red: 255/255.0, green: 204/255.0, blue: 98/255.0, alpha: 1.0).cgColor, UIColor(red: 255/255.0, green: 83/255.0, blue: 26/255.0, alpha: 0.9).cgColor]
        backgroundView.layer.insertSublayer(layer, at: 0)
        
        usernameTextField.customTextField(textField: usernameTextField, placeholderText: "Username")
        emailTextField.customTextField(textField: emailTextField, placeholderText: "example@example.com")
        passwordTextField.customTextField(textField: passwordTextField, placeholderText: "password")
        rePasswordTextField.customTextField(textField: rePasswordTextField, placeholderText: "re-password")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showModal" {
            let modalView: ModalViewController = segue.destination as! ModalViewController
            modalView.parentVC = self
        }
    }
    
    @IBAction func singUpAction(_ sender: Any) {
        guard let pwd = passwordTextField.text, let rePassword = rePasswordTextField.text, let email = emailTextField.text,
            let username = usernameTextField.text else {
                self.showAlert(with: "Please complete the fields")
                return
        }
        
        if pwd == "" || rePassword == "" || email == "" || username == "" {
            self.showAlert(with: "Please complete the fields")
            return
        }else {
            if pwd == rePassword {
                createUser(username: username, email: email, password: pwd)
                let blurEffect = UIBlurEffect(style: .regular)
                blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = self.view.bounds
                self.backgroundView.addSubview(blurEffectView)
                
                self.performSegue(withIdentifier: "showModal", sender: nil)
            }else {
                rePasswordErrorLabel.isHidden = false
                rePasswordErrorMessageLabel.isHidden = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.titleLabel.center.y -= self.backgroundView.bounds.height
        //print(self.usernameTextField.bounds)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
//            self.titleLabel.center.y += self.backgroundView.bounds.height
            self.titleLabel.alpha += 1.0
        }
    }
    
    func createUser(username: String, email: String, password: String) {
        TodoEndPoint.createUser(username: username,email: email, password: password) { (idUser, emailError, error) in
            if let error = error {
                print(error)
                return
            }
            if let _ = emailError {
                self.controlDelegate?.dismissMyModal(value: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.blurEffectView.removeFromSuperview()
                }
                self.emailErrorLabel.isHidden = false
                self.emailErrorMessageLabel.isHidden = false
                return
            }
            if let _ = idUser {
                self.controlDelegate?.dismissMyModal(value: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}







