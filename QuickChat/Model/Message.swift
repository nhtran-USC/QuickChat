//
//  Message.swift
//  QuickChat
//
//  Created by Nguyen Tran on 7/14/22.
//

import Foundation

struct Message {
    let sender:String
    let message:String
    
    init(sender:String, message:String) {
        self.sender = sender
        self.message = message
    }
}
