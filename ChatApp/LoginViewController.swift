//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Jatin on 25/01/17.
//  Copyright © 2017 Jatin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    
    var userId = ["1":false,"2":false,"3":false,"4":false,"5":false]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: CollectionView DataSource & Delegates
extension  LoginViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.label.text = (indexPath.row + 1).description
        cell.backgroundColor = themeColor
        if userId[(indexPath.row + 1).description] == true {
         cell.label.textColor = UIColor.white
        } else {
            cell.label.textColor = UIColor.black
        }
        cell.enableRoudedCorner()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for item in userId {
            if item.key == (indexPath.row + 1).description {
             userId[item.key] = true
            } else {
             userId[item.key] = false
            }
        
        }
        collectionView.reloadData()
        
    }
    
}
