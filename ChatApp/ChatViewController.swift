//
//  ChatViewController.swift
//  liveApp
//
//  Created by Jatin on 06/12/16.
//  Copyright © 2016 coppermobile. All rights reserved.
//

import UIKit

let themeColor = UIColor(colorLiteralRed: 126.0/255.0, green: 178.0/255.0, blue: 12.0/255.0, alpha: 0.5)

enum ChatType:Int {
case Bot,Normal
}

class ChatViewController: UIViewController , UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,updateStatusDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
  
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var bottomCVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    var  keyboardHeight : CGFloat!
    var  chatType : ChatType!
    
    var messages = [Message]()
    var tapGesture: UITapGestureRecognizer?
    var userId:String!
    var receiverId:String!
    
    let bottomCVData = ["Sports","Sci-Fi","Children & Family","Action","Comedy","Drama","Music","News"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 50
       textFieldView.enableRoudedCorner()
//        MQTTClientManager.sharedInstance.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.newMessageReceived(notification:)), name: NSNotification.Name(rawValue: "NewMessage"), object: nil)
        
        userId = "3"
        receiverId = "4"
        
       let msg = "Welcome to Verizon Entertainment Bot. You can also ask questions like \"Whats on tonight?\", \"What Channel is ESPN\", \"comedies on HBO tonight\" or type \"support\" to get account help from a Verizon representative."
        
        let messageBot = Message(messageSenderID:receiverId, messageReceiverID: userId, messageText:msg, messageDate: NSDate(),messageType:.Text)
        messages.append(messageBot)
        
        MQTTClientManager.sharedInstance.subscribeUserforStatus(userID: receiverId)
        UserManager.sharedInstance.delegate = self
        UserManager.sharedInstance.userID = receiverId
        if UserManager.sharedInstance.getStatus(userId: receiverId!) {
        self.title = "online"
        } else {
            self.title = "offline"
        }
        chatType = .Bot
        bottomCollectionView.isHidden = true
        bottomCVHeightConstraint.constant = 0.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let buttonImage = #imageLiteral(resourceName: "send").withRenderingMode(.alwaysTemplate)
        sendButton.setImage(buttonImage, for: .normal)
        sendButton.tintColor = #colorLiteral(red: 0.5604494214, green: 0.7366504073, blue: 0.03677427396, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateStatus(status: Bool) {
        if status {
            self.title = "online"
        } else {
            self.title = "offline"

        }
    }
    
    @IBAction func removeButton(_ sender: Any) {
      let button = sender as! UIView
        button.removeFromSuperview()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func keyboardWillHide(sender: NSNotification) {
               self.bottomConstraint.constant = 8
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })

        chatTableView.removeGestureRecognizer(tapGesture!)

    }
    
    func keyboardWillShow(sender: NSNotification) {
//        if let userInfo = sender.userInfo {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
         keyboardHeight = keyboardRectangle.height
        
                self.bottomConstraint.constant = keyboardHeight + 16
                     UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
    
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.hideKeyboard))
        tapGesture?.cancelsTouchesInView = true
        chatTableView.addGestureRecognizer(tapGesture!)
        scrollToBottom()
}


    @IBAction func sendButtonAction(_ sender: Any) {
        if let text = sendTextView.text,text.characters.count > 0 {
        
            var message : Message!
            
            message = Message(messageSenderID:userId, messageReceiverID: receiverId, messageText: text, messageDate: NSDate(),messageType:.Text)
            
            messages.append(message)
            
            if bottomCollectionView.isHidden == false {
                hidecollectionView()
            }
            
            if text == "Whats on tonight?" {
            
                let messageBot = Message(messageSenderID:userId, messageReceiverID: receiverId, messageText: " ", messageDate: NSDate(),messageType:.Bot)
                messages.append(messageBot)

            } else if text == "Program category" {
                let msgString = "I can also sort my recommendations for you by genre. Type or tap below"
                
                let messageBot = Message(messageSenderID:receiverId, messageReceiverID: userId, messageText: msgString, messageDate: NSDate(),messageType:.Text)
                messages.append(messageBot)
                bottomCVHeightConstraint.constant = 50.0
                bottomCollectionView.isHidden = false
                view.bringSubview(toFront: bottomCollectionView)
                
            }
            
            
          
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                self.scrollToBottom()

            }
            MQTTClientManager.sharedInstance.publishMessageToTopicWithMessage(message: message, otherUserID: receiverId)
        }
        sendTextView.text = nil
        textViewHeight.constant = 30
        
//        MQTTClientManager.sharedInstance.publishImageToTopic(image: #imageLiteral(resourceName: "emotions"), otherUserID: "2")

    }
    
    
    @IBAction func sendImageAction(_ sender: Any) {
        
        let actionSheetController = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
        
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {action in self.openGallery()})
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in self.openCamera()})
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(galleryAction)
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }

}

//MARK: TableView Delegate and Datasource
extension ChatViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        switch message.messageType! {
        case .Bot:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCollectionTableViewCell", for: indexPath) as! ChatCollectionTableViewCell
            return cell
        case .Text:
            
            if message.messageReceiverID == userId{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatReceivedTableViewCell", for: indexPath) as! ChatReceivedTableViewCell
                cell.textMessageLabel.text = message.messageText
                cell.timeLabel.text = DateManager.get12HrTimeFromDate(date: message.messageDate as Date)
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSentTableViewCell", for: indexPath) as! ChatSentTableViewCell
                cell.textMessageLabel.text = message.messageText
                cell.timeLabel.text = DateManager.get12HrTimeFromDate(date: message.messageDate as Date)
                return cell
            }
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageTableViewCell", for: indexPath) as! ChatImageTableViewCell
            cell.chatImageView.image = message.messageImage
            
            return cell
        }

        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let type = self.chatType else {
//            return 0
//        }
//        switch type {
//        case .Bot:
//            return 1+messages.count
//        default:
//            return messages.count
//        }
                    return messages.count

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension

    }
    
    


}
extension ChatViewController {
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let text = textView.text , text.characters.count > 0 {
            if text == "Type a message" {
                textView.text = nil
            }
        
        
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth: CGFloat = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: min( chatTableView.bounds.size.height*CGFloat(0.5),CGFloat(newSize.height)))
        textViewHeight.constant = newFrame.height
        scrollToBottom()
    }
    
//    func newMessagReceived(message: Message) {
//        self.messages.append(message)
//        DispatchQueue.main.sync {
//            self.chatTableView.reloadData()
//            self.scrollToBottomWithAnimation()
//
//        }
//    }
//    
    func scrollToBottomWithAnimation() {
        if self.messages.count > 0 {
            chatTableView.setNeedsDisplay()
            chatTableView.layoutIfNeeded()
            let lastIndex = IndexPath(row: messages.count-1, section: 0)
            self.chatTableView.scrollToRow(at: lastIndex as IndexPath, at: UITableViewScrollPosition.none, animated: false)
        }
    }
    
    func scrollToBottom() {
        if self.messages.count > 0 {
            chatTableView.setNeedsDisplay()
            chatTableView.layoutIfNeeded()
            let height = self.chatTableView.contentSize.height - self.chatTableView.bounds.size.height
            let point  = CGPoint(x: 0, y: height)
            self.chatTableView.setContentOffset(point, animated: false)
            
        }
    }
    
    func newMessageReceived(notification:NSNotification){
        if let message = notification.object as? Message {
            self.messages.append(message)
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                self.scrollToBottomWithAnimation()
        }
       }
    }
    
    // MARK: ImagePicker Functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let message = Message(messageSenderID:userId, messageReceiverID: receiverId, messageText: "", messageDate: NSDate(),messageType:.Image,messageImage:pickedImage)
            messages.append(message)
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                self.scrollToBottom()
                
            }
        }
        //        hasChanged = true
        dismiss(animated: true, completion: nil)
    }
    
}
//MARK: Image Picker
extension ChatViewController {
    
    func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
  
}
//MARK: ColelctonView Datasource and Delegate
extension ChatViewController {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatBottomCVCell", for: indexPath) as! ChatBottomCVCell
        cell.titleLabel.text = bottomCVData[indexPath.row]
        cell.layer.cornerRadius = cell.frame.height/2.0
        cell.layer.masksToBounds = true
        cell.addBorder(withColor: cell.titleLabel.textColor, andBorderWidth: 1.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bottomCVData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: widthOfString(text: bottomCVData[indexPath.row])+16.0, height: collectionView.bounds.height-16)
    }
    
    func widthOfString(text:String) -> CGFloat {
        
            let fontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
            let size = (text as NSString).size(attributes: fontAttributes)
            return size.width
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       hidecollectionView()
        let message = Message(messageSenderID: userId, messageReceiverID: receiverId, messageText: bottomCVData[indexPath.row], messageDate: Date() as NSDate,messageType:.Text)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewMessage"), object: message, userInfo: nil)
    }
    
    func hidecollectionView () {
        
        view.sendSubview(toBack: bottomCollectionView)
        bottomCollectionView.isHidden = true
        bottomCVHeightConstraint.constant = 0.0
        
    }
    
    
}
