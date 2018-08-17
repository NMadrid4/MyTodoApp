//  TodoViewController.swift
//  MyTodoApp
//
//  Created by Melanie on 8/15/18.
//  Copyright © 2018 Doapps. All rights reserved.

import UIKit
import SwiftyJSON

class TodoViewController: UIViewController {

  @IBOutlet weak var todosCollectionView: UICollectionView!
  @IBOutlet weak var taskDoneLabel: UILabel!
  @IBOutlet weak var allTaskLabel: UILabel!
  @IBOutlet weak var addNewTodoButton: UIButton!
  
  var todos: [Todo] = []
  var tasks: [Task] = []
  var isDone: Int = Int()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    todosCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "celda")
    getTask()
    
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getData()
    self.navigationController?.navigationBar.isHidden = true
  }

  func getTask() {
    TodoEndPoint.getTaksFrom { (task, error) in
      guard error == nil, let task = task else {
        print(error!)
        return
      }
      DispatchQueue.main.async {
        self.tasks = task
        for itemDone in self.tasks {
          if itemDone.isDone == true {
              self.isDone+=1
          }
        }
        self.taskDoneLabel.text = String(self.isDone)
        self.allTaskLabel.text = String(self.tasks.count)

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
    return cell;
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let todo = todos[indexPath.row]
    performSegue(withIdentifier: "todoViewDetail", sender: todo)
  }

}
