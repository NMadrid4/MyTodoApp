//
//  ModalViewController.swift
//  MyTodoApp
//
//  Created by Melanie on 8/22/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

  @IBOutlet weak var loadingProgressView: UIProgressView!
  var current:Float = 0.0
  override func viewDidLoad() {
        super.viewDidLoad()

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
}

