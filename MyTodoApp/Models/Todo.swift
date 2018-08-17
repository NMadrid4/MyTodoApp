//
//  Todo.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 7/07/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import Foundation
import SwiftyJSON

class Todo {
    
    var id: Int
    var title: String
    var description: String
    var isTaskAvailable: Bool
    var creation: Date
    var task: [JSON]
    
  init(title: String, description: String, isTaskAvailable: Bool, creation: Date, id: Int, task: [JSON]) {
        self.id = id
        self.title = title
        self.description = description
        self.isTaskAvailable = isTaskAvailable
        self.creation = creation
        self.task = task
        
    }
    
    static func from(json: JSON) -> Todo {
      return Todo(title: json["title"].stringValue, description: json["description"].stringValue, isTaskAvailable: false,
                  creation: Date(), id: json["id"].intValue, task: json["tasks"].array!)
    }
    
    static func from(jsonArray: [JSON]) -> [Todo] {
        var resultArray: [Todo] = []
        for jsonTodo in jsonArray {
            resultArray.append(Todo.from(json: jsonTodo))
        }
        return resultArray
    }

}
