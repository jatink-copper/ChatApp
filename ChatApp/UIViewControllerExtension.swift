//
//  UIViewControllerExtension.swift
//  liveApp
//
//  Created by Abhi on 16/11/16.
//  Copyright © 2016 coppermobile. All rights reserved.
//

import UIKit

extension UIViewController {
  
  /// Method to provide an accessory toolbar with a done button
  ///
  /// - Returns: The accessory toolbar with the done button
  func getAccessoryToolbar() -> UIToolbar {
    
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    toolBar.isTranslucent = true
    toolBar.barStyle = UIBarStyle.black
    
    let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(forceEndEditing))
    doneButton.tintColor = UIColor.white
    
    toolBar.setItems([flexButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    
    return toolBar
  }
  
  /// Makes the navigation bar background image as per live app's design
  ///
  /// - Parameters:
  ///   - enableBackButton: adds a back button to the navigation with pop functionality
  ///   - enableDismiss: makes the back button dismiss controller
  func makeNavigationLive(enableBackButton: Bool = false, enableDismiss: Bool = false) {
    navigationController?.view.backgroundColor = UIColor.clear
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NavBarBackgroundImage"), for: .default)
    navigationController?.navigationBar.tintColor = UIColor.black
    if enableBackButton && !enableDismiss {
      let _ = addBarButtonWith(image: UIImage(named: "navigationBackButton")!, target: self, and: #selector(self.popViaNavigation))
    }
    if enableDismiss && enableBackButton {
      let _ = addBarButtonWith(image: UIImage(named: "navigationBackButton")!, target: self, and: #selector(self.dismissAnimated))
    }
  }
  
  
  /// Method to add a navigation bar button item to navigation bar
  ///
  /// - Parameters:
  ///   - image: image for the bar button
  ///   - title: bar button title
  ///   - sideLeft: which side bar button will be added
  ///   - target: the target for bar button
  ///   - selector: selector for the button action
  /// - Returns: return back the bar button item
  func addBarButtonWith(image: UIImage? = nil, title: String = "", sideLeft: Bool = true, target: Any?, and selector: Selector) -> UIBarButtonItem? {
    
    let barButtonItem = image != nil ? UIBarButtonItem(image: image, style: .plain, target: self, action: selector) : UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
    if sideLeft {
      navigationItem.leftBarButtonItem = barButtonItem
    } else {
      navigationItem.rightBarButtonItem = barButtonItem
    }
    return barButtonItem
  }
  
  
  /// Method to forcefully end editing of a text input view.
  func forceEndEditing() {
    view.endEditing(true)
  }
  
  func dismissAnimated() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func popViaNavigation() {
    let _ = navigationController?.popViewController(animated: true)
  }
  
  func hideTabBar() {
    self.navigationController?.tabBarController?.tabBar.isHidden = true
  }
  
  func showTabBar() {
    self.navigationController?.tabBarController?.tabBar.isHidden = false
  }
  
  func getTabBar() {
    //   -> UITabBar? {
    //    let tabBarController = AppDelegate.sharedDelegateObject().tabBarViewController
    //    return tabBarController.tabBar
  }
  
  func addTransparentView() {
    let transparentView = UIView(frame: view.frame)
    transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    transparentView.isHidden = true
    transparentView.tag = 987
    view.addSubview(transparentView)
  }
  
  func setTransparentViewAsHidden(_ hidden: Bool = false) {
    guard let transparentView = view.viewWithTag(987) else { return }
    transparentView.isHidden = hidden
  }
  

  
  // Adding Indicator
  func showActivityIndicatorWithText(label: String) {
    let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height+40))
    indicatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    indicatorView.tag = 5000
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    activityView.frame = CGRect(x: indicatorView.frame.midX - 25, y: indicatorView.frame.midY - 25, width: 50, height: 50)
    activityView.color = UIColor.lightGray
    activityView.startAnimating()
    
    let textLabel = UILabel(frame: CGRect(x: 0, y: indicatorView.frame.midY + 25, width: view.frame.width, height: 40))
    textLabel.textColor = UIColor.white
    textLabel.textAlignment = .center
    textLabel.text = label
    
    indicatorView.addSubview(activityView)
    indicatorView.addSubview(textLabel)
    
    view.addSubview(indicatorView)
    
  }
  
  // Removing Indicator
  func removeIndicator() {
    view.viewWithTag(5000)?.removeFromSuperview()
  }
  
  //Navigation Bar Set up
  func setNavigationBackgroundImage() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NavBarBackgroundImage.png"), for: .default)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  func setNavigationBackgroundImageWithLogo() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationBarWithLogo.png"), for: .default)
    
    
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isHidden = false
  }
    
    func textViewHeight(forAttributedText text: NSAttributedString, andWidth width: CGFloat) -> CGFloat {
        let calculationView = UITextView()
        calculationView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        calculationView.attributedText = text
        let size = calculationView.sizeThatFits(CGSize(width: width, height: CGFloat(FLT_MAX)))
        return size.height
    }
    
    func displayNavBarActivity() {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            indicator.startAnimating()
            let item = UIBarButtonItem(customView: indicator)
            
            self.navigationItem.leftBarButtonItem = item
        }
        
     func dismissNavBarActivity() {
            self.navigationItem.leftBarButtonItem = nil
        }
}
