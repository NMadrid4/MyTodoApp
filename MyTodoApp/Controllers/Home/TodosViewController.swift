//
//  TodosViewController.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 7/07/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

class TodosViewController: UIViewController {

    @IBOutlet weak var todoTableView: UITableView!
    
    var todos: [Todo] = [Todo(title: "Lista de compras", description: "Ingredientes de la cena", isTaskAvailable: false, creation: Date())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTableView.register(UINib(nibName: "TodosTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")
        todoTableView.dataSource = self

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
    
    
}
