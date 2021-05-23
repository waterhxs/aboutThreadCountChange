//
//  XSThreadQueue.swift
//  ThreadTest
//
//  Created by huangxuesong on 2021/5/23.
//

import Foundation

public struct XSThreadQueue<T> {
    
    fileprivate var queue = [T]()
    
    public var isEmpty:Bool {
        return queue.isEmpty
    }
    
    public var count:Int {
        return queue.count
    }
    
    public mutating func enQueue(_ element:T) {
        queue.append(element)
    }
    
    public mutating func removeFirst() {
        if !isEmpty {
            queue.removeFirst()
        }
    }
    
    public mutating func deQueue() -> T? {
        if isEmpty {
            return nil
        }
        else {
            return queue.removeFirst()
        }
    }
    
    public var front:T? {
        return queue.first
    }
}
