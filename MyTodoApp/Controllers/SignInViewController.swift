//
//  SignInViewController.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 30/06/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameTexField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTexField.resignFirstResponder()
        passwordTexField.resignFirstResponder()
    }
    
    @IBAction func signinAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToHome", sender: nil)
    }
    
    
    
    //se ejecuta al construir todos los contrains
    //override func viewDidLayoutSubviews() {
    
    //}
    
    //dispositivo sin memoria y te da la opcion de  disparar este metodo y elminar
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
