//
//  CommentViewController.swift
//  Coverage
//
//  Created by Developer on 1/25/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Cartography

enum CommentType: String {
    case praise, clarify, complaint
}

class CreateCommentViewController: UIViewController {
    
    let idea: Idea
    
    lazy var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.items = [self.navItem]
        return bar
    }()
    
    lazy var navItem: UINavigationItem = {
        let item =  UINavigationItem(title: "Comment")
        item.leftBarButtonItem = self.back
        item.rightBarButtonItem = self.post
        return item
    }()
    
    lazy var back: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(CreateCommentViewController.backPressed(_:)))
        return button
    }()
    
    lazy var post: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "post", style: .plain, target: self, action: #selector(CreateCommentViewController.postPressed(_:)))
        return button
    }()
    
    lazy var titleField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "title"
        return textField
    }()
    
    lazy var bodyField: UITextView = {
        let textView = UITextView()
        return textView
    }()

    lazy var typeControl: UISegmentedControl = {
        let typeControl = UISegmentedControl()
        for type in [.praise, .clarify, .complaint] as [CommentType] {
            typeControl.insertSegment(withTitle: type.rawValue.capitalizingFirstLetter, at: 0, animated: false)
        }
        return typeControl
    }()
    
    init(idea: Idea) {
        self.idea = idea
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        
        view.addSubview(navBar)
        
        view.addSubview(typeControl)
        
        view.addSubview(titleField)
        view.addSubview(bodyField)
        
        constrain(navBar, view) {
            $0.top == $1.top
            
            $0.width == $1.width
            $0.height == 64
        }
        
        constrain(typeControl, view, navBar) { typeControl, parent, navBar in
            typeControl.top == navBar.bottom + 20
            typeControl.centerX == parent.centerX
            
            typeControl.width == parent.width * 0.85
        }
        
        constrain(view, navBar, typeControl, titleField, bodyField) {
            view, navBar, typeControl, titleField, bodyField in

            titleField.centerX == view.centerX
            titleField.top == typeControl.bottom + 40
            titleField.width == view.width * 0.8
            
            bodyField.centerX == view.centerX
            bodyField.top == titleField.bottom + 20
            bodyField.width == view.width * 0.8
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func postPressed(_ sender: Any) {
        
    }
}
