//
//  NotificationService.swift
//  Notification Service Extension
//
//  Created by Mustafa Onur ILGAZ on 10.10.2019.
//  Copyright © 2019 Onur ILGAZ. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else { return }
        
        // Modify the notification content here...
        if let urlString = bestAttemptContent.userInfo["imageUrl"] as? String {
            if let imageUrl = URL.init(string: urlString) {
                let fileName = UUID().uuidString + ".jpg"
                if let urlData = try? Data.init(contentsOf: imageUrl, options: []) {
                    if let imageAttachment = UNNotificationAttachment.create(fileIdentifier: fileName, data: urlData, options: nil) {
                        bestAttemptContent.attachments.append(imageAttachment)
                    }
                }
            }
        }
        
        contentHandler(bestAttemptContent)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
