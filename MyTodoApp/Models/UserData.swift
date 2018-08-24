//
//  UserData.swift
//  MyTodoApp
//
//  Created by Melanie on 8/22/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import Foundation

class UserData {
  static let sharedInstance = UserData()
  private init(){}
  var userToken: String?
  var idUser: Int?
}
 
