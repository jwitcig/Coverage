//
//  IdeaViewController.swift
//  Coverage
//
//  Created by Developer on 1/24/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Cartography
import JWSwiftTools

class IdeaViewController: UIViewController {

    let idea: Idea
    
    lazy var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.items = [self.navItem]
        return bar
    }()
    
    lazy var navItem: UINavigationItem = {
        let item =  UINavigationItem(title: self.idea.name)
        item.leftBarButtonItem = self.back
        return item
    }()
    
    lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(self.mainContentView)
        return scrollView
    }()
    
    lazy var mainContentView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    lazy var descriptionField: UITextView = {
        let description = UITextView()
        description.isEditable = false
        description.isSelectable = false
        description.text = self.idea.description
        return description
    }()
    
    lazy var featureContainer: UITableView = {
        let container = UITableView()
        container.dataSource = self
        container.delegate = self
        container.alwaysBounceVertical = false
        return container
    }()
    
    lazy var back: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(IdeaViewController.backPressed(_:)))
        
        let _ = UILongPressGestureRecognizer(target: self, action: #selector(IdeaViewController.backLongPressed(_:)))
        return button
    }()
    
    lazy var bottomBar: UIToolbar = {
        let bar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [space, self.comment]
        return bar
    }()
    
    lazy var comment: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "comment", style: .plain, target: self, action: #selector(IdeaViewController.commentPressed(_:)))
        return button
    }()
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 3
        return control
    }()
    
    lazy var praiseListView: UITableView = self.createCommentsListView()
    lazy var clarifyListView: UITableView = self.createCommentsListView()
    lazy var complaintListView: UITableView = self.createCommentsListView()
    
    lazy var commentLists: [UIView] = {
        return [self.praiseListView, self.clarifyListView, self.complaintListView]
    }()
    
    lazy var typeControl: UISegmentedControl = {
        let typeControl = UISegmentedControl()
        for (index, type) in self.typeControlSegments {
            typeControl.insertSegment(withTitle: type.rawValue.capitalizingFirstLetter, at: index, animated: false)
        }
        typeControl.selectedSegmentIndex = 0
        self.commentTypeChanged(typeControl)
        typeControl.addTarget(self, action: #selector(IdeaViewController.commentTypeChanged(_:)), for: .valueChanged)
        return typeControl
    }()
    
    let typeControlSegments: [Int : CommentType] = [
        0: .praise,
        1: .clarify,
        2: .complaint,
    ]
    
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
        
        view.addSubview(bottomBar)
        
        view.addSubview(mainScrollView)
        
        let info = UIView()
        info.addSubview(descriptionField)
        info.addSubview(featureContainer)
        
        let comments = UIView()
        comments.addSubview(typeControl)
        commentLists.forEach(comments.addSubview)

        [info, comments].forEach(mainContentView.addArrangedSubview)
        
        constrain(navBar, view) {
            $0.top == $1.top
            
            $0.width == $1.width
            $0.height == 64
        }
        
        constrain(bottomBar, view) {
            $0.width == $1.width
            $0.bottom == $1.bottom
        }
        
        constrain(mainScrollView, mainContentView, navBar, bottomBar, view) {
            scrollView, contentView, top, bottom, parent in
            
            scrollView.leading == parent.leading
            scrollView.trailing == parent.trailing
            scrollView.top == top.bottom
            scrollView.bottom == bottom.top
            
            contentView.leading == scrollView.leading
            contentView.trailing == scrollView.trailing
            contentView.top == scrollView.top
            contentView.bottom == scrollView.bottom
        }
        
        constrain(featureContainer, info, descriptionField) {
            features, parent, description in
            
            let topMargin: CGFloat = 20
            let sideMargin: CGFloat = 20
            
            description.top == parent.top + 40
            description.height == 100
            description.leading == parent.leading + sideMargin
            description.trailing == parent.trailing - sideMargin
            
            features.top == description.bottom + topMargin
            features.leading == parent.leading + sideMargin
            features.trailing == parent.trailing - sideMargin
            features.bottom == parent.bottom
        }
       
        constrain([info, comments] + [mainScrollView]) {
            let sections = $0[0..<$0.count-1]
            let parent = $0[$0.count-1]
            
            for section in sections {
                section.size == parent.size
            }
        }
        
        constrain(commentLists + [comments, typeControl]) {
            let commentLists = $0[0..<$0.count-2]
            let parent = $0[$0.count-2]
            let control = $0[$0.count-1]
            
            control.top == parent.top + 20
            control.centerX == parent.centerX
            control.width == parent.width * 0.8
            
            for list in commentLists {
                list.top == control.bottom + 20
                list.bottom == parent.bottom
                list.leading == parent.leading
                list.trailing == parent.trailing
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featureContainer.reloadData()
    }
    
    func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func backLongPressed(_ recognizer: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
        (parent as? IdeaViewController)?.backLongPressed(recognizer)
    }
    
    func commentPressed(_ sender: Any) {
        let controller = CreateCommentViewController(idea: idea)
        present(controller, animated: true, completion: nil)
    }
    
    func createCommentsListView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }
    
    func setActive(type: CommentType) {
        commentLists.forEach { $0.isHidden = true }
        switch type {
        case .praise:
            praiseListView.isHidden = false
        case .clarify:
            clarifyListView.isHidden = false
        case .complaint:
            complaintListView.isHidden = false
        }
    }
    
    func commentTypeChanged(_ control: UISegmentedControl) {
        guard let type = typeControlSegments[control.selectedSegmentIndex] else { return }
        setActive(type: type)
    }
}

extension IdeaViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension IdeaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case featureContainer:
            return idea.features.count
        case praiseListView:
            return idea.comments?.of(type: .praise).count ?? 0
        case clarifyListView:
            return idea.comments?.of(type: .clarify).count ?? 0
        case complaintListView:
            return idea.comments?.of(type: .complaint).count ?? 0
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        switch tableView {
        case featureContainer:
            let feature = self.feature(for: indexPath)
            cell.textLabel?.text = feature.name
            cell.detailTextLabel?.text = feature.description
        default:
            guard let comment = idea.comments?[safe: indexPath.row] else { return UITableViewCell() }
            cell.textLabel?.text = comment.title
            cell.detailTextLabel?.text = comment.body
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = IdeaViewController(idea: self.feature(for: indexPath))
        present(controller, animated: true, completion: nil)
    }
    
    func feature(for indexPath: IndexPath) -> Idea {
        return idea.features[indexPath.row]
    }
}
