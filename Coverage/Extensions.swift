//
//  Extensions.swift
//  Coverage
//
//  Created by Developer on 1/25/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

extension String {
    var capitalizingFirstLetter: String {
        let first = String(characters.prefix(1)).capitalized
        let theRest = String(characters.dropFirst())
        return first + theRest
    }
}

extension Sequence where Iterator.Element == Comment {
    func of(type: CommentType) -> [Iterator.Element] {
        return filter { $0.type == type }
    }
}
