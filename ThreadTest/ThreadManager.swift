//
//  ThreadManager.swift
//  ThreadTest
//
//  Created by huangxuesong on 2021/5/23.
//

import UIKit

class ThreadManager: NSObject {
    
    private var queue:XSThreadQueue<XSThreadProtocol> = XSThreadQueue<XSThreadProtocol>.init()
    // 线程池任务可超频的数量
    private let queueFlowTaskCount:Int = 10
    // 线程池超频工作线程数量
    private let flowCount:Int = 5
    // 线程池稳定工作线程数量
    private let stableCount:Int = 2
    // 现在线程池的线程数量
    private var currThreadCountInPool:Int = 0

    static let shareInstance:ThreadManager = {
        let instance = ThreadManager.init()
        return instance
    }()
    
    public func add(task:XSThreadProtocol) {
        queue.enQueue(task)
        processTask()
    }
    
    private func processTask(){
        
        var couldCreateThreadCount = 0
        // 来个锁
        let l = NSConditionLock.init()
        // 加锁取数量
        l.lock()
        couldCreateThreadCount = queue.count - currThreadCountInPool
        // 如果线程队列数量大于超频阀值
        if queue.count > queueFlowTaskCount {
            couldCreateThreadCount = flowCount - currThreadCountInPool
        }
        else{
            couldCreateThreadCount = stableCount - currThreadCountInPool
        }
        // 取完数量解锁
        l.unlock()
        
        if queue.count > 0 && couldCreateThreadCount > 0 {
            var task = queue.deQueue()
            task?.willRunCallback = { (t) in
                self.currThreadCountInPool += 1
            }
            task?.completeCallback = { (t, msgs:inout [String]) in
                // 来个锁
                let lock = NSConditionLock.init()
                // 加锁改数量
                lock.lock()
                self.currThreadCountInPool -= 1
                msgs.append("线程执行完毕")
                msgs.append("执行完成后待执行线程池里的线程数量是:\(self.queue.count)")
                msgs.append("执行完成后执行中的线程数量是:\(self.currThreadCountInPool)")
                // 改完数量解锁
                lock.unlock()
                // 执行完毕再递归检测线程池的操作
                self.processTask()
            }
            task?.run()
        }
    }
}
