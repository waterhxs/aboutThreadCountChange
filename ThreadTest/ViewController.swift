//
//  ViewController.swift
//  ThreadTest
//
//  Created by huangxuesong on 2021/5/19.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tbMain: UITableView!
    private var semaphore = DispatchSemaphore.init(value: 2)
    private var messages:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup(){
        tbMain.dataSource = self
        tbMain.delegate = self
        tbMain.tableFooterView = UIView.init()
    }

    @IBAction func onBtn2Click(_ sender: Any) {
        let threadObj = XSThread.init { (t) in
            
            debugPrint("this is running")
            
        } willCompleteCallback: { (t) in
            debugPrint("将要执行")
            sleep(10)
        } messageCallback: { (t, msgs:[String]) in
            self.messages.append(contentsOf: msgs)
            DispatchQueue.main.async {
                self.tbMain.reloadData()
            }
        }
        ThreadManager.shareInstance.add(task: threadObj)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell.init()
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
}
