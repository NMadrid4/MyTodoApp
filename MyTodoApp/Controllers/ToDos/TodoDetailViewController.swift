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
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var allowTaskSwitch: UISwitch!
    @IBOutlet weak var addNewTaskButoon: UIButton!
    
    var todo: Todo?
    var isExisted = false
    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            titleTextField.text = todo.title
            descriptionTextView.text = todo.description
            
            TodoEndPoint.getTaksFrom(Todo: todo) { (tasks, error) in
                if let error = error {
                    print(error)
                }
                if let tasks = tasks, tasks.count > 0 {
                    DispatchQueue.main.async {
                    self.tasks = tasks
                    self.taskTableView.reloadData()
                    self.allowTaskSwitch.setOn(true, animated: true)
                    self.allowTaskAction(self.allowTaskSwitch)
                    }
                }
            }
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
    
    @IBAction func allowTaskAction(_ sender: UISwitch) {
        if sender.isOn {
        taskTextField.isHidden = false
        taskTableView.isHidden = false
        addNewTaskButoon.isHidden = false
        
            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn, animations: {
                self.taskTableView.alpha = 1
                self.taskTextField.alpha = 1
                self.addNewTaskButoon.alpha = 1
            }, completion: nil)
            
        }else {
            taskTextField.isHidden = true
            taskTableView.isHidden = true
            addNewTaskButoon.isHidden = true
        }
        
    }
    
    @IBAction func addNewTaskAction(_ sender: UIButton) {
        guard !taskTextField.text!.isEmpty else {
            return
        }
        guard let todo = self.todo else{
            return
        }
        sender.isEnabled = false
        tasks.append(Task(title: taskTextField.text!, id: todo.id))
        taskTableView.reloadData()
        
        TodoEndPoint.createTask(Title: taskTextField.text!, fromTodo: todo) { (idTask, error) in
            if let error = error {
                print(error)
            }
            if let _ = idTask {
                DispatchQueue.main.async {
                    self.taskTextField.text = ""
                    self.taskTextField.resignFirstResponder()
                }
            }
        }
    }
    

}

extension TodoDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }
    
    
}

