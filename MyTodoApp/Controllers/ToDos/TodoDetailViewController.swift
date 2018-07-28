//
//  TodoDetailViewController.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 21/07/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TodoDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var todoActionButton: UIButton!
    
    var todo: Todo?
    var isExisted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            titleTextField.text = todo.title
            descriptionTextView.text = todo.description
        }
        if !isExisted {
            todoActionButton.setTitle("Create", for: .normal)
        }else{
            todoActionButton.setTitle("save Changes", for: .normal)
            todoActionButton.addTarget(self, action: #selector(saveTodoChanges), for: .touchUpInside)
        }
    }
    
    @objc func saveTodoChanges() {
        if let todo = self.todo {
            todo.title = titleTextField.text!
            todo.description = descriptionTextView.text!
            saveTodoChangeWith(todo: todo)
            
        }
    }
    
    func saveTodoChangeWith(todo: Todo){
        let params = ["title": todo.title, "description": todo.description]
        let url = String(format: "\(TodoAPI.baseURL)\(TodoAPI.editMyTodoUrl)", "\(todo.id)")
        Alamofire.request(url, method: .put, parameters: params).responseJSON{ response in
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }

}
