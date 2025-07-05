//
//  ContainerViewController.swift
//  Algorithms
//
//  Created by Maxime Boulat on 2/7/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    
    private var view1: UINavigationController?
    private var sierpinsky: UIViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let view1 = storyboard.instantiateViewController(withIdentifier: "ViewHierarchyNav") as! UINavigationController
        view1.view.frame = self.container.frame
        view1.willMove(toParentViewController: self)
        self.container.addSubview(view1.view)
        view1.didMove(toParentViewController: self)
        self.addChildViewController(view1)
        self.view1 = view1
        
        let sierpinsky = storyboard.instantiateViewController(withIdentifier: "Sierpinsky")
        sierpinsky.view.frame = self.container.frame
        sierpinsky.willMove(toParentViewController: self)
        self.container.addSubview(sierpinsky.view)
        sierpinsky.didMove(toParentViewController: self)
        self.addChildViewController(sierpinsky)
        self.sierpinsky = sierpinsky
        
        didPressMaze(nil)
    }
    
    // MARK: - Actions
    
    @IBAction func didPressMaze(_ sender: Any?) {
        for child in self.childViewControllers {
            if child is MazeViewController {
                self.container.bringSubview(toFront: child.view)
                break
            }
        }
    }
    
    @IBAction func didPressHierarchy(_ sender: Any?) {
        if let view1 = self.view1 {
            self.container.bringSubview(toFront: view1.view)
        }
    }
    
    @IBAction func didPressSierpinsky(_ sender: Any?) {
        if let sierpinsky = self.sierpinsky {
            self.container.bringSubview(toFront: sierpinsky.view)
        }
    }
} 
