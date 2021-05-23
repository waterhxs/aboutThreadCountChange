//
//  XSThread.swift
//  ThreadTest
//
//  Created by huangxuesong on 2021/5/23.
//

import UIKit

typealias threadActionCallback = (_ t:Thread)->()
typealias threadActionForMessageCallback = (_ t:Thread, _ messages:inout [String])->()
typealias threadActionForMessageOutPutCallback = (_ t:Thread, _ messages:[String])->()

class XSThread: NSObject {
    
    private var thread:Thread?
    private var _willRunCallback:threadActionCallback?
    private var runCallback:threadActionCallback?
    private var willCompleteCallback:threadActionCallback?
    private var _completeCallback:threadActionForMessageCallback?
    private var _messageCallback:threadActionForMessageOutPutCallback?
    private var messages:[String] = []
    
    override init() {
        super.init()
        setup()
    }
    
    init(runCallback:@escaping(threadActionCallback),
         willCompleteCallback:@escaping(threadActionCallback),
         messageCallback:@escaping(threadActionForMessageOutPutCallback)) {
        super.init()
        self.runCallback = runCallback
        self.willCompleteCallback = willCompleteCallback
        self._messageCallback = messageCallback
        setup()
    }
    
    private func setup() {
        thread = Thread.init(target: self, selector: #selector(onThreadAction(_:)), object: nil)
    }
    
    @IBAction private func onThreadAction(_ sender:Any){
        _willRunCallback!(thread!)
        runCallback!(thread!)
        willCompleteCallback!(thread!)
        _completeCallback!(thread!, &messages)
        _messageCallback!(thread!, messages)
    }
}

extension XSThread: XSThreadProtocol {
    
    var willRunCallback: threadActionCallback {
        get {
            return _willRunCallback!
        }
        set {
            _willRunCallback = newValue
        }
    }
    
    var completeCallback: threadActionForMessageCallback {
        get {
            return _completeCallback!
        }
        set {
            _completeCallback = newValue
        }
    }
    
    func run() {
        thread!.start()
    }
    
}
