//
//  TodoDetViewController.swift
//  MyTodoApp
//
//  Created by Melanie on 8/17/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit
import SwiftyJSON

class TodoDetViewController: UIViewController {

  @IBOutlet weak var todoTitleTextField: UITextField!
  @IBOutlet weak var todoDescriptionTextView: UITextView!
  @IBOutlet weak var newTaskTextField: UITextField!
  @IBOutlet weak var newTaskButton: UIButton!
  @IBOutlet weak var taskTableView: UITableView!
  @IBOutlet weak var todoActionButton: UIButton!
  
  var todo: Todo?
  var tasks: [Task] = []
  var isExisted = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
      if let todo = todo {
        todoTitleTextField.text = todo.title
        todoDescriptionTextView.text = todo.description
        getTask(task: todo.task)
      }
    if !isExisted {
      todoActionButton.setTitle("Create", for: .normal)
      todoActionButton.addTarget(self, action: #selector(createTodo), for: .touchUpInside)
    }else{
      todoActionButton.setTitle("save Changes", for: .normal)
      //todoActionButton.addTarget(self, action: #selector(saveTodoChanges), for: .touchUpInside)
    }
  }
  func getTask(task: [JSON]){
    tasks = Task.from(jsonArray: task)
  }
  
  @objc func createTodo() {
    TodoEndPoint.createTodo(withTodo: todo!) { (idNewTodo, error) in
      if let error = error {
        print(error)
        return
      }
      if let _ = idNewTodo {
        print("s")
      }
    }
  }

}

extension TodoDetViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    cell.textLabel?.text = tasks[indexPath.row].title
    return cell
  }
  
  
}
