//
//  ChatCollectionTableViewCell.swift
//  ChatApp
//
//  Created by Jatin on 10/03/17.
//  Copyright © 2017 Jatin. All rights reserved.
//

import UIKit

class ChatCollectionTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatCollectionView: UICollectionView!
    var cellArray: NSArray!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        if let json = loadJson(filename: "Sample") , let facebook = json["facebook"]as? NSDictionary,let attachment = facebook ["attachment"]as? NSDictionary,let payload = attachment["payload"]as? NSDictionary,let elements =   payload["elements"]as? NSArray {
            self.cellArray = elements
        }
        heightConstraint.constant = 300
        
        
    }
    
    func loadJson(filename fileName: String) -> [String: AnyObject]?
    {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        {
            if let data = NSData(contentsOf: url) {
                do {
                    let object = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                    if let dictionary = object as? [String: AnyObject] {
                        return dictionary
                    }
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        }
        return nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCollectionViewCell", for: indexPath) as! ChatCollectionViewCell
        if let data = cellArray[indexPath.row] as? NSDictionary {
            cell.celldata = data
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cellArray != nil) ? cellArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/1.5-20, height: collectionView.bounds.height)
    }

}
