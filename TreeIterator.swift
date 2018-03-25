//
//  TreeIterator.swift
//  AlmightyTree
//
//  Created by Anastasia Sviridenko on 25/03/2018.
//  Copyright © 2018 ASya. All rights reserved.
//

import Foundation

public class TreeIterator<Value: Equatable & Hashable>: IteratorProtocol {
    public typealias Element = Value
    
    private var breadthFirstIterator: [Tree<Value>] = []
    
    public init(tree: Tree<Value>) {
        breadthFirstIterator.append(tree)
    }
    
    public func next() -> Element? {
        // Non-optinal code! It will take O(n) for first element removal.
        // For performance optimization use Stack data structure.
        let tree = breadthFirstIterator.remove(at: 0)
        let element = tree.value
        if let nonnullLeft = tree.left {
            breadthFirstIterator.append(nonnullLeft)
        }
        if let nonnullRight = tree.right {
            breadthFirstIterator.append(nonnullRight)
        }
        return element
    }
}
