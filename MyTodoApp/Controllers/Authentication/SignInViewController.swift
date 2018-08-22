//
//  SignInViewController.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 30/06/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
  
    @IBOutlet weak var usernameTexField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var seePassword: UIButton!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
    
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTexField.resignFirstResponder()
        passwordTexField.resignFirstResponder()
    }
    
    @IBAction func signinAction(_ sender: UIButton) {
      if usernameTexField.text! == "" || passwordTexField.text! == "" {
        self.showAlert(with: "Complete the fields")
      }else {
        singIn(email: usernameTexField.text!, password: passwordTexField.text!)
      }
    }
  
  func singIn(email: String, password: String){
    TodoEndPoint.loginUser(email: email, password: password) { (idToken, idUser, error) in
      if let error = error {
        print(error)
        return
      }
      if let _ = idToken, let _ = idUser {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          let tabBarController = UIStoryboard(name: "Home", bundle: nil ).instantiateViewController(withIdentifier: "tabBarController")
          self.present(tabBarController, animated: true, completion: nil)
        }
      }else {
        self.showAlert(with: "User or password incorrect")
      }
    }
  }
  
  @IBAction func seePasword(_ sender: UIButton) {
    if passwordTexField.isSecureTextEntry {
        passwordTexField.isSecureTextEntry = false
        sender.setImage(#imageLiteral(resourceName: "ic_hidePassword"), for: .normal)
    }else{
      passwordTexField.isSecureTextEntry = true
      sender.setImage(#imageLiteral(resourceName: "ic_seePasword"), for: .normal)
    }
  }

}
