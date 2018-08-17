//
//  Notes.swift
//  MyTodoApp
//
//  Created by Melanie on 8/14/18.
//  Copyright © 2018 Doapps. All rights reserved.

import Foundation
import SwiftyJSON

class Notes {
  
  var id: Int
  var description: String
  
  init(id: Int, description: String) {
    self.id = id
    self.description = description
  }
  
  static func from(json: JSON) -> Notes {
    return Notes(id: json["id"].intValue, description: json["description"].stringValue)
  }
  
  static func from(jsonArray: [JSON]) -> [Notes] {
    var resultArray: [Notes] = []
    for jsonNotes in jsonArray {
      resultArray.append(Notes.from(json: jsonNotes))
    }
    return resultArray
  }
  
}
