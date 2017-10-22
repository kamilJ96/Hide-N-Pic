//
//  ChatViewController.swift
//  ChatFunctionality
//
//  Created by Karan Singh on 18/9/17.
//  Copyright © 2017 Karan Singh. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseDatabase

// Taken from this tutorial: https://www.raywenderlich.com/140836/firebase-tutorial-real-time-chat-2

class ChatViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    // Reference to Firebase
    var rootRef = Database.database().reference()
    var convoId = String()
    var receiverName = String()
    var receiverId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = receiverName
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let receiverIdFive = String(self.receiverId.characters.prefix(5))
        let senderIdFive = String(senderId.characters.prefix(5))
        
        
        if(senderIdFive > receiverIdFive) {
            self.convoId = senderIdFive + receiverIdFive
        } else {
            self.convoId = receiverIdFive + senderIdFive
        }
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    // Sets the message cell as a jsqmessenger cell and displays the message
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        
        // If the sender ID of the message equals the current users sender ID, display as outgoing
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        return
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = rootRef.child("messages").child("\(self.convoId)").childByAutoId()
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
    
    // Listens to the DB for when a new message is added
    private func observeMessages() {
        let messageQuery = rootRef.child("messages/\(self.convoId)").queryLimited(toLast: 25)
        messageQuery.observe(.childAdded, with: {
            snapshot in
            let messageData = snapshot.value as! Dictionary<String, String>
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()
            } else {
                print("Error! Couldnt decode")
            }
        })
    }
}
