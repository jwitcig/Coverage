//
//  Idea.swift
//  Coverage
//
//  Created by Developer on 1/24/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

protocol Post {
    var timestamp: Int { get }
}

protocol Comment: Post {
    var type: CommentType { get }
    
    var title: String { get }
    var body: String { get }
}

struct Idea: Post {
    let timestamp: Int
    
    let name: String
    let description: String
    
    let features: [Idea]
    
    var comments: [Comment]?
    
    init(name: String, description: String, features: [Idea], comments: [Comment]? = nil, timestamp: Int? = nil) {
        self.timestamp = timestamp ?? Int(Date().timeIntervalSinceNow)
        
        self.name = name
        self.description = description
        
        self.features = features
        self.comments = comments
    }
}

struct Complaint: Comment {
    let timestamp: Int
    
    let type: CommentType
    let title: String
    let body: String
}

struct Praise: Comment {
    let timestamp: Int
    
    let type: CommentType
    let title: String
    let body: String}

struct Clarify: Comment {
    let timestamp: Int
    
    let type: CommentType
    let title: String
    let body: String}
