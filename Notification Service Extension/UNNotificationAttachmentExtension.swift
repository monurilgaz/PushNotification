//
//  UNNotificationAttachmentExtension.swift
//  Notification Service Extension
//
//  Created by Mustafa Onur ILGAZ on 10.10.2019.
//  Copyright © 2019 Onur ILGAZ. All rights reserved.
//

import UserNotifications

extension UNNotificationAttachment {
    
    static func create(fileIdentifier: String, data: Data, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tempFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tempFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tempFolderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: tempFolderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tempFolderURL.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL, options: [])
            return try self.init(identifier: fileIdentifier, url: fileURL, options: options)
        } catch let error {
            print("error \(error)")
        }
        
        return nil
    }
}
