//
//  ViewHierarchyContainerViewController.swift
//  Algorithms
//
//  Created by Maxime Boulat on 2/18/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

import UIKit

class ViewHierarchyContainerViewController: UIViewController, SubviewSelectionProtocol {
    
    private var viewController: ViewHierarchyViewController?
    @IBOutlet weak var findCommonSuperviewButton: UIButton!
    @IBOutlet weak var pushCloneButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pushCloneButton.isHidden = true
        self.findCommonSuperviewButton.isHidden = true
        
        if self.navigationController?.viewControllers.first == self {
            self.title = "View selection"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pushCloneButton.layer.cornerRadius = self.pushCloneButton.frame.size.height / 2
        self.pushCloneButton.layer.borderWidth = 1
        self.pushCloneButton.layer.borderColor = UIColor.black.cgColor
        self.pushCloneButton.clipsToBounds = true
        
        self.findCommonSuperviewButton.layer.cornerRadius = self.pushCloneButton.frame.size.height / 2
        self.findCommonSuperviewButton.layer.borderWidth = 1
        self.findCommonSuperviewButton.layer.borderColor = UIColor.black.cgColor
        self.findCommonSuperviewButton.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Containment" {
            let vc = segue.destination as! ViewHierarchyViewController
            self.viewController = vc
            vc.delegate = self
        } else {
            var path: [Int] = []
            
            guard let selectionStack = self.viewController?.selectionStack,
                  !selectionStack.isEmpty else { return }
            
            var subview = selectionStack[0]
            var superView = subview.superview
            
            while superView != self.viewController?.view.superview {
                if let unwrappedSuperView = superView {
                    let index = unwrappedSuperView.subviews.firstIndex(of: subview) ?? 0
                    path.insert(index, at: 0)
                    subview = unwrappedSuperView
                    superView = unwrappedSuperView.superview
                } else {
                    break
                }
            }
            
            let destination = segue.destination
            var subviews = destination.view.subviews
            var target: UIView?
            
            while !path.isEmpty {
                let index = path.removeFirst()
                guard subviews.indices.contains(index) else { break }
                target = subviews[index]
                subviews = target?.subviews ?? []
            }
            
            if let target = target {
                target.backgroundColor = UIColor.red
                destination.view.isUserInteractionEnabled = false
            }
        }
    }
    
    // MARK: - SubviewSelectionProtocol
    
    func didMakeSelection(with stack: [UIView]) {
        if stack.count == 1 {
            self.pushCloneButton.isHidden = false
            self.findCommonSuperviewButton.isHidden = true
        } else if stack.count == 2 {
            self.pushCloneButton.isHidden = true
            self.findCommonSuperviewButton.isHidden = false
        } else {
            self.pushCloneButton.isHidden = true
            self.findCommonSuperviewButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didPressFindCommonSuperview(_ sender: Any) {
        
        guard let viewController = self.viewController,
              viewController.selectionStack.count >= 2 else { return }
        
        let view1 = viewController.selectionStack[0]
        let view2 = viewController.selectionStack[1]
        
        viewController.commonSuperview = AlgorithmManagerSwift.findCommonAncestor(i: view1, m: view2)
        
        viewController.commonSuperview?.layer.borderColor = UIColor.blue.cgColor
    }
} 
