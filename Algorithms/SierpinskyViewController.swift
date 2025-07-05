//
//  SierpinskyViewController.swift
//  Algorithms
//
//  Created by Maxime Boulat on 2/7/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

import UIKit

class SierpinskyViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        
        addSubviews(to: self.view)
    }
    
    // MARK: - Helpers
    
    private func addSubviews(to view: UIView) {
        
        // base case
        if view.frame.size.width < 1 {
            view.backgroundColor = UIColor.blue
        } else {
            // first view
            var rect = CGRect(x: 0, y: 0, width: view.frame.size.width / 2, height: view.frame.size.height / 2)
            var subview = UIView(frame: rect)
            view.addSubview(subview)
            addSubviews(to: subview)
            
            // second view
            rect = CGRect(x: view.frame.size.width / 2, y: 0, width: view.frame.size.width / 2, height: view.frame.size.height / 2)
            subview = UIView(frame: rect)
            view.addSubview(subview)
            addSubviews(to: subview)
            
            // third view
            rect = CGRect(x: view.frame.size.width / 2, y: view.frame.size.height / 2, width: view.frame.size.width / 2, height: view.frame.size.height / 2)
            subview = UIView(frame: rect)
            view.addSubview(subview)
            addSubviews(to: subview)
        }
    }
} 