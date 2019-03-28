//
//  ChatCollectionViewCell.swift
//  ChatApp
//
//  Created by Jatin on 10/03/17.
//  Copyright © 2017 Jatin. All rights reserved.
//

import UIKit
import SDWebImage


class ChatCollectionViewCell: UICollectionViewCell , UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var chatTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatButtonsTableView: UITableView!
    @IBOutlet weak var chatSubheadingLabel: UILabel!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var chatHeadingLabel: UILabel!
    
    var celldata : NSDictionary!
    var cellButtons : NSArray!

    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let url = celldata["image_url"] as? String {
            chatImageView.sd_setImage(with: URL(string:url), placeholderImage: nil)
       
        }
        if let titleText = celldata["title"] as? String {
            chatHeadingLabel.text = titleText
        }
        if let subTitleText = celldata["subtitle"] as? String {
            chatSubheadingLabel.text = subTitleText
        }
        
        if let buttons = celldata["buttons"] as? NSArray {
            cellButtons = buttons
        }
        self.layoutIfNeeded()
        self.contentView.addBorder(withColor: UIColor.lightGray, andBorderWidth:1.0)
        self.contentView.enableRoudedCorner()
        chatButtonsTableView.delegate = self
        chatButtonsTableView.dataSource = self
        chatButtonsTableView.reloadData()
        chatButtonsTableView.scrollsToTop = true
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ChatCVButtonTableViewCell", for: indexPath) as! ChatCVButtonTableViewCell
        if let buttons = cellButtons , let button = buttons[indexPath.row] as? NSDictionary {
        cell.cvButton.setTitle(button["title"] as? String, for: .normal)
        cell.buttonData = button
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let buttons = celldata["buttons"] as? NSArray else {
        return 0
        }
        return buttons.count
    }
    
}
