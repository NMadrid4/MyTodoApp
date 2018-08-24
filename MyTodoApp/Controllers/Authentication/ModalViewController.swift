//
//  ModalViewController.swift
//  MyTodoApp
//
//  Created by Melanie on 8/22/18.
//  Copyright © 2018 Doapps. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class ModalViewController: UIViewController {
  @IBOutlet weak var loadingView: NVActivityIndicatorView!
  
  var parentVC: SignUpViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.layer.cornerRadius = 4.0
    loadingView.type = . ballClipRotatePulse
    loadingView.color = UIColor.red
    loadingView.startAnimating()
    parentVC?.controlDelegate = self
  }
}

extension ModalViewController: SignUpControlDelegate{
  func dismissMyModal(value: Bool) {
    if value {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
      }
    }else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.loadingView.stopAnimating()
        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
}

