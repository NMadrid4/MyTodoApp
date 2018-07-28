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
    var task: [Task]?
    
    init(title: String, description: String, isTaskAvailable: Bool, creation: Date, id: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.isTaskAvailable = isTaskAvailable
        self.creation = creation
    }
    
    static func from(json: JSON) -> Todo {
        return Todo(title: json["title"].stringValue, description: json["description"].stringValue,
                    isTaskAvailable: json["isTaskAvailable"].boolValue, creation: Date(), id: json["id"].intValue)
    }
    
    static func from(jsonArray: [JSON]) -> [Todo] {
        var resultArray: [Todo] = []
        for jsonTodo in jsonArray {
            resultArray.append(Todo.from(json: jsonTodo))
        }
        return resultArray
    }

}
