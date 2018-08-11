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
            todoActionButton.addTarget(self, action: #selector(createTodo), for: .touchUpInside)
        }else{
            todoActionButton.setTitle("save Changes", for: .normal)
            todoActionButton.addTarget(self, action: #selector(saveTodoChanges), for: .touchUpInside)
        }
    }
    @objc func createTodo() {
        let newTodo = Todo(title: titleTextField.text!, description: descriptionTextView.text!, isTaskAvailable: false, creation: Date(), id: 0)
        TodoEndPoint.createTodo(withTodo: newTodo) { (idNewTodo, error) in
            if let error = error {
                print(error)
                return
            }
            if let _ = idNewTodo {
                self.navigationController?.popViewController(animated: true)
            }
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
        TodoEndPoint.edidTodo(withUpdateTodo: todo) { todoId, error in
            if let error = error {
                print(error)
                return
            }
            if let _ = todoId {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }

}
