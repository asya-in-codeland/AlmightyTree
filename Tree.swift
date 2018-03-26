//
//  Tree.swift
//  AlmightyTree
//
//  Created by Anastasia Sviridenko on 25/03/2018.
//  Copyright © 2018 ASya. All rights reserved.
//

import Foundation

public protocol AbstractTree {
    associatedtype Element
    var value: Element {get}
    var left: Self? {get}
    var right: Self? {get}
}

public final class Tree<Value: Equatable & Hashable>: AbstractTree, Equatable, Hashable, CustomStringConvertible {

    public let value: Value
    public var left: Tree<Value>?
    public var right: Tree<Value>?
    
    public init(value: Value) {
        self.value = value
    }
    
    public var description: String {
        return "\(value) " + left.descriptionOrNil + right.descriptionOrNil
    }
    
    public var hashValue: Int {
        return value.hashValue + left.hashValueOrNone + right.hashValueOrNone
    }
    
    public static func ==(lhs: Tree<Value>, rhs: Tree<Value>) -> Bool {
        return isEqual(lhs: lhs, rhs: rhs)
    }
    
    public func contain(element: Value) -> Bool {
        if value == element {
            return true
        }
        
        return (left?.contain(element: element) ?? false) || (right?.contain(element: element) ?? false)
    }
    
    // MARK: - Private Recursive
    
    private static func isEqual(lhs: Tree<Value>?, rhs: Tree<Value>?) -> Bool {
        guard let left = lhs, let right = rhs else {
            return lhs == nil && rhs == nil
        }
        
        return left.value == right.value && isEqual(lhs: left.left, rhs: right.left) && isEqual(lhs: left.right, rhs: right.right)
    }
}

extension Tree {
    public func makeIterator() -> TreeIterator<Tree<Value>> {
        return TreeIterator(tree: self)
    }
}

extension Tree {
    public var minDepth: Int {
        return findDepth(node: self, depth: 0, comparator: min)
    }
    
    public var maxDepth: Int {
        return findDepth(node: self, depth: 0, comparator: max)
    }
    
    private func findDepth(node: Tree?, depth: Int, comparator:(_ left: Int, _ right: Int)->Int) -> Int {
        if node == nil {
            return depth
        }
        
        if node?.left == nil {
            return findDepth(node: node?.right, depth: depth+1, comparator: comparator)
        }
        
        if node?.right == nil {
            return findDepth(node: node?.left, depth: depth+1, comparator: comparator)
        }
        
        let leftDepth = findDepth(node: node?.left, depth: depth+1, comparator: comparator)
        let rightDepth = findDepth(node: node?.right, depth: depth+1, comparator: comparator)
        return comparator(leftDepth, rightDepth)
    }
}

extension Optional where Wrapped: CustomStringConvertible {
    var descriptionOrNil: String {
        return self?.description ?? "nil"
    }
}

extension Optional where Wrapped: Hashable {
    var hashValueOrNone: Int {
        return self?.hashValue ?? 0
    }
}
