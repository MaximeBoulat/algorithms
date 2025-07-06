//
//  ViewHierarchyViewController.swift
//  Algorithms
//
//  Created by Maxime Boulat on 2/13/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

import UIKit

protocol SubviewSelectionProtocol: AnyObject {
    func didMakeSelection(with stack: [UIView])
}

class ViewHierarchyViewController: UIViewController {
    
    var selectionStack: [UIView] = []
    weak var delegate: SubviewSelectionProtocol?
    var commonSuperview: UIView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectionStack = []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func didSelectView(_ sender: UITapGestureRecognizer) {
        
        if let commonSuperview = self.commonSuperview {
            commonSuperview.layer.borderColor = UIColor.black.cgColor
            self.commonSuperview = nil
        }
        
        if self.selectionStack.count == 2 {
            for view in self.selectionStack {
                view.layer.borderColor = UIColor.black.cgColor
            }
            self.selectionStack.removeAll()
        } else {
            let selection = sender.view!
            if self.selectionStack.isEmpty || selection != self.selectionStack[0] {
                selection.layer.borderColor = UIColor.red.cgColor
                self.selectionStack.append(selection)
            }
        }
        
        self.delegate?.didMakeSelection(with: self.selectionStack)
    }
}

class BorderedView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
} 
