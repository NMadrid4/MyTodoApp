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
    var creation: Date
    
    init(title: String, creation: Date) {
        self.title = title
        self.creation = creation
    }
    
    static func from(json: JSON) -> Task {
        return Task(title: json["title"].stringValue, creation: Date())
    }
    
    func from(jsonArray: [JSON]) -> [Task] {
        var resultArray: [Task] = []
        for jsonTask in jsonArray {
            resultArray.append(Task.from(json: jsonTask))
        }
        return resultArray
    }

}
