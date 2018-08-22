//
//  TodoDetViewController.swift
//  MyTodoApp
//
//  Created by Melanie on 8/17/18.
//  Copyright © 2018 Doapps. All rights reserved.

import UIKit
import SwiftyJSON

class TodoDetViewController: UIViewController {

  @IBOutlet weak var todoTitleTextField: UITextField!
  @IBOutlet weak var todoDescriptionTextView: UITextView!
  @IBOutlet weak var taskView: UIView!
  @IBOutlet weak var taskTableView: UITableView!
  @IBOutlet weak var todoActionButton: UIButton!
  @IBOutlet weak var newTaskButton: UIButton!
  @IBOutlet weak var taskTitleLabel: UILabel!
  @IBOutlet weak var taskCountLabel: UILabel!
  
  var todo: Todo?
  var tasks: [Task] = []
  var isExisted = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setData()
    taskCountLabel.text = String(tasks.count) + " " + "Tasks"
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.view.backgroundColor = .clear
    todoDescriptionTextView.layer.cornerRadius = 4.0
    taskView.layer.cornerRadius = 4.0
    taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "taskCell")
  }
  
  func setData() {
    if let todo = todo {
      todoTitleTextField.text = todo.title
      todoDescriptionTextView.text = todo.description
      getTask(task: todo.task)
    }
    if !isExisted {
      todoActionButton.setTitle("Create", for: .normal)
      todoActionButton.addTarget(self, action: #selector(createTodo), for: .touchUpInside)
      hideTask(value: true)
    }else{
      todoActionButton.setTitle("save Changes", for: .normal)
      todoActionButton.addTarget(self, action: #selector(saveTodoChanges), for: .touchUpInside)
    }
  }
  
  func hideTask(value: Bool) {
    taskView.isHidden = value
    taskTableView.isHidden = value
    taskTitleLabel.isHidden = value
    newTaskButton.isHidden = value
  }
  
  func getTask(task: [JSON]){
    tasks = Task.from(jsonArray: task)
  }
  
  @objc func createTodo() {
    let newTodo = Todo(title: todoTitleTextField.text!, description: todoDescriptionTextView.text!, isTaskAvailable: false, creation: Date(), id: 0, task: [JSON(tasks)])
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
      todo.title = todoTitleTextField.text!
      todo.description = todoDescriptionTextView.text!
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
  
  @IBAction func addNewTask(_ sender: Any) {
    let alert = UIAlertController(title: "Add new Task",
                                  message: "Add a new task",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save", style: .default) { action in
      
      guard let textField = alert.textFields?.first,
        let newTask = textField.text else {
          return
        }
     
      self.tasks.append(Task(title: newTask, id: 0, isDone: false, todoId: self.todo!.id))
      self.taskTableView.reloadData()
      
      TodoEndPoint.createTask(Title: newTask, fromTodo: self.todo!) { (idTask, error) in
        if let error = error {
          print(error)
          return
        }
        if let _ = idTask {
          DispatchQueue.main.async {
            self.showAlert(with: "A task was successfully created")
            self.taskCountLabel.text = String(self.tasks.count) + " " + "Tasks"
          }
        }
      }
    }
    alert.addTextField()
    alert.addAction(saveAction)
    self.present(alert, animated: true, completion: nil)
  }

}

extension TodoDetViewController: UITableViewDataSource {
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
   cell.taskTitleLabel.text = tasks[indexPath.row].title
   
    if tasks[indexPath.row].isDone {
      let attributedString = NSMutableAttributedString(string: tasks[indexPath.row].title)
      attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
      cell.taskTitleLabel.attributedText = attributedString
      cell.taskTitleLabel.textColor = UIColor.gray
      cell.isDoneButton.setImage(#imageLiteral(resourceName: "ic_checked"), for: .normal)
      cell.isDone = true
    }else {
      cell.isDoneButton.setImage(#imageLiteral(resourceName: "ic_unchecked"), for: .normal)
      cell.taskTitleLabel.textColor = UIColor.black
      cell.isDone = false
    }
    cell.taskId = tasks[indexPath.row].id
    cell.todoId = tasks[indexPath.row].todoId
   return cell
   }
  
}


