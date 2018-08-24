//
//  SignInViewController.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 30/06/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var usernameTexField: UITextField!
  @IBOutlet weak var passwordTexField: UITextField!
  @IBOutlet weak var signinButton: UIButton!
  @IBOutlet weak var signupButton: UIButton!
  @IBOutlet weak var seePassword: UIButton!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet var backgroundView: UIView!
  @IBOutlet weak var frontView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    usernameTexField.addDoneButtonToKeyboard(myAction:  #selector(self.usernameTexField.resignFirstResponder))
    passwordTexField.addDoneButtonToKeyboard(myAction: #selector(self.passwordTexField.resignFirstResponder))
    scrollView.isScrollEnabled = false
    registerKeyboardNotifications()
    
    signinButton.layer.cornerRadius = 4.0
    signupButton.layer.cornerRadius = 4.0
    
    backgroundView.backgroundColor = UIColor(red: 255/255.0, green: 204/255.0, blue: 98/255.0, alpha: 1.0)
    let layer = CAGradientLayer()
    layer.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
    layer.colors = [UIColor(red: 255/255.0, green: 204/255.0, blue: 98/255.0, alpha: 1.0).cgColor, UIColor(red: 255/255.0, green: 83/255.0, blue: 26/255.0, alpha: 0.9).cgColor]
    frontView.layer.insertSublayer(layer, at: 0)
    
    usernameTexField.putLayer(textField: usernameTexField)
    usernameTexField.layer.masksToBounds = true
    usernameTexField.backgroundColor = UIColor.clear
    usernameTexField.attributedPlaceholder = NSAttributedString(string: "example@example.com",
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    
    
    passwordTexField.putLayer(textField: passwordTexField)
    passwordTexField.layer.masksToBounds = true
    passwordTexField.backgroundColor = UIColor.clear
    passwordTexField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
    
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.isHidden = false
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    usernameTexField.resignFirstResponder()
    passwordTexField.resignFirstResponder()
  }
  
  
  func registerKeyboardNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(notification:)),
                                           name: NSNotification.Name.UIKeyboardWillShow,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(notification:)),
                                           name: NSNotification.Name.UIKeyboardWillHide,
                                           object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    scrollView.isScrollEnabled = true
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
    let keyboardSize = keyboardInfo.cgRectValue.size
    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    scrollView.isScrollEnabled = false
    scrollView.contentInset = .zero
    scrollView.scrollIndicatorInsets = .zero
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
        UserData.sharedInstance.userToken = idToken
        UserData.sharedInstance.idUser = idUser
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
