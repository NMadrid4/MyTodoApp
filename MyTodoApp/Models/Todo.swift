//
//  Todo.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 7/07/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import Foundation

class Todo {
    
    var title: String
    var description: String
    var isTaskAvailable: Bool
    var creation: Date
    var task: [Task]?
    
    init(title: String, description: String, isTaskAvailable: Bool, creation: Date) {
        self.title = title
        self.description = description
        self.isTaskAvailable = isTaskAvailable
        self.creation = creation
    }
}
