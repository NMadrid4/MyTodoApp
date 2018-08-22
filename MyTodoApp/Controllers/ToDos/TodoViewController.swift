//  TodoViewController.swift
//  MyTodoApp
//
//  Created by Melanie on 8/15/18.
//  Copyright © 2018 Doapps. All rights reserved.

import UIKit
import SwiftyJSON

class TodoViewController: UIViewController, CountTasksProtocol {

  @IBOutlet weak var todosCollectionView: UICollectionView!
  @IBOutlet weak var taskDoneLabel: UILabel!
  @IBOutlet weak var allTaskLabel: UILabel!
  @IBOutlet weak var addNewTodoButton: UIButton!
  
  var todos: [Todo] = []
  var tasks: [Task] = []
  var isDoneCount: Int = Int()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    todosCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "celda")
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.isHidden = false
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white

  
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
    getTasks()
    getData()
   
  }

  func getTasks() {
    TodoEndPoint.getTaksFrom { (task, error) in
      guard error == nil, let task = task else {
        print(error!)
        return
      }
      DispatchQueue.main.async {
        self.tasks = task
        self.isDoneCount = 0
        for itemDone in self.tasks {
          if itemDone.isDone == true {
            self.isDoneCount+=1
          }
        }
        self.taskDoneLabel.text = String(self.isDoneCount)
        self.allTaskLabel.text =  String(self.tasks.count)
      }
    }
  }
  
  func getData(){
    TodoEndPoint.getTodos { (todos, error) in
      guard error == nil, let todos = todos else {
        print(error!)
        return
      }
      DispatchQueue.main.async {
        self.todos = todos
        self.todosCollectionView.reloadData()
      }
    }
  }
  
  //protocol
  func tasksToDone() {
    if isDoneCount <= tasks.count-1 {
      isDoneCount+=1
      self.taskDoneLabel.text = String(self.isDoneCount)
    }else{
      return
    }
  }
  
  func decrease() {
    isDoneCount-=1
    self.taskDoneLabel.text = String(self.isDoneCount)
  }
  
  override func performSegue(withIdentifier identifier: String, sender: Any?) {
    if identifier == "todoViewDetail", let todo = sender as? Todo {
      let todoDetailVC = storyboard?.instantiateViewController(withIdentifier: "todoDetVC") as! TodoDetViewController
      todoDetailVC.todo = todo
      todoDetailVC.isExisted = true
      self.navigationController?.pushViewController(todoDetailVC, animated: true)  
    }
  }
}

extension TodoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return todos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda", for: indexPath) as! CollectionViewCell
    cell.todoTitleLabel.text = todos[indexPath.row].title
    cell.getTask(task: todos[indexPath.row].task)
    cell.delegate = self
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let todo = todos[indexPath.row]
    performSegue(withIdentifier: "todoViewDetail", sender: todo)
  }
}
