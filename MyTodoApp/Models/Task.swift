//
//  Task.swift
//  MyTodoApp
//
//  Created by Usuario invitado on 7/07/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import Foundation
import SwiftyJSON

class Task {
    
    var title: String
    var id: Int
    var isDone: Bool
    var todoId: Int
    
  init(title: String, id: Int, isDone: Bool, todoId: Int) {
        self.title = title
        self.id = id
        self.isDone = isDone
        self.todoId = todoId
    }
    
    static func from(json: JSON) -> Task {
      return Task(title: json["title"].stringValue, id: json["id"].intValue, isDone: json["isDone"].boolValue,
                  todoId: json["toDoId"].intValue)
    }
    
    static func from(jsonArray: [JSON]) -> [Task] {
        var resultArray: [Task] = []
        for jsonTask in jsonArray {
            resultArray.append(Task.from(json: jsonTask))
        }
        return resultArray
    }

}
