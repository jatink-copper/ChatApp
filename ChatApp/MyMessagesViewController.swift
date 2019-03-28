//
//  MyMessagesViewController.swift
//  liveApp
//
//  Created by Jatin on 06/12/16.
//  Copyright © 2016 coppermobile. All rights reserved.
//

import UIKit

class MyMessagesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var messagesTableView: UITableView!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var isFromDrawer = false 
    
    var messagesView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
//        MQTTManager.sharedInstance.setUpMqttClient()
//        MQTTManager.sharedInstance.setUpReachability()
        MQTTClientManager.sharedInstance.setUpReachability()
        DispatchQueue.main.async {
            self.displayNavBarActivity()
            MQTTClientManager.sharedInstance.setupClient {
                self.dismissNavBarActivity()
            }
//       let view = bgImageView.makeCircleWithShadow()
//        view.addSubview(bgImageView)
//        self.view.addSubview(view)
        
        
        }
//

    }
    
    
    
    private func setUpUI() {
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "My Messages"
        segmentControl.enableRoudedCorner()
        
    }

    @IBAction func segmentControlAction(_ sender: Any) {
        let segment = sender as! UISegmentedControl
        
        if segment.selectedSegmentIndex == 0 {
            messagesView = true
        
        } else {
            messagesView = false
        }
        messagesTableView.reloadData()
    }
   

    @IBAction func logoutButtonAction(_ sender: Any) {
        MQTTClientManager.sharedInstance.unsubscribeTheUser(userID: "1")
        
    }
}
//MARK: TableView Delegate & Datasource 
extension MyMessagesViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messagesView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessagesTableViewCell", for: indexPath) as! MyMessagesTableViewCell
            return cell
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRequestTableViewCell", for: indexPath) as! MyRequestTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messagesView {
            return 2
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if messagesView {
            return messagesTableView.frame.height*0.23
        } else {
            return messagesTableView.frame.height*0.2

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if messagesView {
        performSegue(withIdentifier: "myMessagesToChat", sender: self)
        }
    }
    
    
    
}


