//
//  SignUpViewController.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 7/07/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

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
  
  
  var fieldsValidated = false
  
  override func viewDidLoad() {
        super.viewDidLoad()
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
    }else {
      rePasswordErrorLabel.isHidden = false
      rePasswordErrorMessageLabel.isHidden = false
      }
    }
    
  }
  
  func createUser(username: String, email: String, password: String) {
    TodoEndPoint.createUser(username: username,email: email, password: password) { (idUser, emailError, error) in
      if let error = error {
        print(error)
        return
      }
      if let _ = emailError {
        self.emailErrorLabel.isHidden = false
        self.emailErrorMessageLabel.isHidden = false
        return
      }
      
      if let _ = idUser {
        self.performSegue(withIdentifier: "showModal", sender: nil)
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        self.backgroundView.addSubview(blurEffectView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          self.navigationController?.popViewController(animated: true)
        }
      }
      
   }
 }
  
}
