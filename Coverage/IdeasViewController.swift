//
//  IdeasViewController.swift
//  Coverage
//
//  Created by Developer on 1/24/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Cartography

class IdeasViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()
    
    var ideas: [Idea] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = UINavigationBar()
        view.addSubview(navBar)
        
        let navItem = UINavigationItem(title: "Ideas")
        let create = UIBarButtonItem(title: "create", style: .plain, target: self, action: #selector(IdeasViewController.createPressed(_:)))
        navItem.rightBarButtonItem = create
        navBar.items = [navItem]
        
        constrain(navBar, view) {
            $0.top == $1.top
            $0.width == $1.width
            $0.height == 64
        }
        
        view.addSubview(tableView)
        
        constrain(tableView, navBar, view) {
            $0.top == $1.bottom
            $0.bottom == $2.bottom
            $0.leading == $2.leading
            $0.trailing == $2.trailing
        }
        
        ideas = [
            Idea(name: "Something Cool", description: "Some words about Something Cool.", features: [Idea(name: "feature 1", description: "this is awesome.", features: [])])
        ]
    }
    
    func createPressed(_ sender: Any) {
        let controller = CreateIdeaViewController()
        present(controller, animated: true, completion: nil)
    }
}

extension IdeasViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension IdeasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idea = ideas[indexPath.row]
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = idea.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idea = ideas[indexPath.row]
        let controller = IdeaViewController(idea: idea)
        present(controller, animated: true, completion: {
            tableView.deselectRow(at: indexPath, animated: false)
        })
    }
}
