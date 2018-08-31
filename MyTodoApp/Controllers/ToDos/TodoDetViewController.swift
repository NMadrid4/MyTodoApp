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
    @IBOutlet weak var todoScrollView: UIScrollView!
    
    var todo: Todo?
    var tasks: [Task] = []
    var isExisted = false
    var userId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        taskCountLabel.text = String(tasks.count) + " " + "Tasks"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.view.backgroundColor = .clear
        todoDescriptionTextView.layer.cornerRadius = 4.0
        taskView.layer.cornerRadius = 4.0
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "taskCell")
        userId = UserData.sharedInstance.idUser!
        registerKeyboardNotifications()
        todoScrollView.isScrollEnabled = false
        
        
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
        todoScrollView.isScrollEnabled = true
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        todoScrollView.contentInset = contentInsets
        todoScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        todoScrollView.isScrollEnabled = false
        todoScrollView.contentInset = .zero
        todoScrollView.scrollIndicatorInsets = .zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        todoTitleTextField.resignFirstResponder()
        todoDescriptionTextView.resignFirstResponder()
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
        TodoEndPoint.createTodo(withTodo: newTodo, userId: userId!) { (idNewTodo, error) in
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
            if newTask != "" {
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
            }else{
                self.showAlert(with: "please write some task ")
            }
            
        }
        alert.addTextField()
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteTask(task: Task, positionTask: Int){
        TodoEndPoint.deleteTask(task: task) { (idDeletedTask, error) in
            if let error = error {
                print(error)
                return
            }
            if let idDeletedTask = idDeletedTask {
                if idDeletedTask > 0 {
                    self.tasks.remove(at: positionTask)
                    self.taskCountLabel.text = String(self.tasks.count) + " " + "Tasks"
                    self.taskTableView.reloadData()
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteTask(task: tasks[indexPath.row], positionTask: indexPath.row)
        }
    }
    
}


