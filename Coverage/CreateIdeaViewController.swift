//
//  CreateIdeaViewController.swift
//  Coverage
//
//  Created by Developer on 1/24/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Cartography

class CreateIdeaViewController: UIViewController {
    
    lazy var nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "name"
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var descriptionField: UITextView = {
        let textView = UITextView()
        textView.text = "description"
        return textView
    }()
    
    lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "post", style: .plain, target: self, action: #selector(CreateIdeaViewController.createPressed(_:)))
        return button
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(CreateIdeaViewController.cancelPressed(_:)))
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        
        let navbar = UINavigationBar()
        view.addSubview(navbar)
        
        let navItem = UINavigationItem(title: "New Idea")
        navItem.leftBarButtonItem = cancelButton
        navItem.rightBarButtonItem = createButton
        navbar.items = [navItem]
        
        constrain(navbar, view) {
            $0.width == $1.width
            $0.height == 64
        }
        
        view.addSubview(nameField)
        view.addSubview(descriptionField)
        
        constrain(nameField, descriptionField, navbar) {
            name, description, navBar in
            
            let sideMargin: CGFloat = 20
            
            name.leading == navBar.leading + sideMargin
            description.leading == navBar.leading + sideMargin
            
            name.trailing == navBar.trailing - sideMargin
            description.trailing == navBar.trailing - sideMargin

            
            name.top == navBar.bottom + 40
            description.top == name.bottom + 40
        
            description.height == 80
        }
    }
    
    func createPressed(_ sender: Any) {
        
    }
    
    func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
