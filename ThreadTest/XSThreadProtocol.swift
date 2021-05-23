//
//  XSThreadProtocol.swift
//  ThreadTest
//
//  Created by huangxuesong on 2021/5/23.
//

import Foundation

protocol XSThreadProtocol {
    var willRunCallback: threadActionCallback {set get}
    var completeCallback: threadActionForMessageCallback {set get}
    func run()
}
