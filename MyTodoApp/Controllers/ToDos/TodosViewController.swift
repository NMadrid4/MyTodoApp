//
//  TodosViewController.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 7/07/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class TodosViewController: UIViewController {

    @IBOutlet weak var todoTableView: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TodosViewController.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
        return refreshControl
    }()
    
    var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTableView.register(UINib(nibName: "TodosTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")
        todoTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData(refreshControl: nil)
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getData(refreshControl: refreshControl)
    }
    
    func getData(refreshControl: UIRefreshControl?){
        TodoEndPoint.getTodos { (todos, error) in
            guard error == nil, let todos = todos else {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.todos = todos
                self.todoTableView.reloadData()
                refreshControl?.endRefreshing()
            }
        }
    }
 
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == "todoDetail", let todo = sender as? Todo {
            let todoDetailVC = storyboard?.instantiateViewController(withIdentifier: "todoDetailVC") as! TodoDetailViewController
            todoDetailVC.todo = todo
            todoDetailVC.isExisted = true
            self.navigationController?.pushViewController(todoDetailVC, animated: true)
        }
        
    }
}

extension TodosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        performSegue(withIdentifier: "todoDetail", sender: todo)
    }
}

extension TodosViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodosTableViewCell
        
        cell.titleLabel.text = todos[indexPath.row].title
        cell.descriptionLabel.text = todos[indexPath.row].description
        cell.creation.text = "\(todos[indexPath.row].creation)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todoDeleted = self.todos.remove(at: indexPath.row)
            self.todoTableView.deleteRows(at: [indexPath], with: .automatic)
            
            TodoEndPoint.delete(Todo: todoDeleted) { (itemsDeleted, error) in
            if let error = error {
                    print(error)
            
                }
                
            }
        }
    }
    
}
