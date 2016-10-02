//
//  CaptionBot.swift
//  CaptionBot
//
//  Created by Noel Portugal on 10/2/16.
//  Copyright © 2016 theiotlabs. All rights reserved.
//

import Foundation
import UIKit

public func CaptionBot(urlImage: String) -> String {
    return ""
}

private let initUrl = "https://www.captionbot.ai/api/init"
private let uploadUrl = "https://www.captionbot.ai/api/upload"
private let messageUrl = "https://www.captionbot.ai/api/message"


private func getConversationId(){
    httpGet(url: initUrl) { conversationId, error in
        if let conversationId = conversationId?.replacingOccurrences(of: "\"", with: "") {
            getImageUrl(conversationId: conversationId)
        }else {
            print("Error \(error)")
        }
    }
}


private func getImageUrl(conversationId: String){
    let image = UIImage(named: "dog")
    httpPostImage(url: uploadUrl, image: image!) {imageUrl, error in
        if let imageUrl = imageUrl?.replacingOccurrences(of: "\"", with: "") {
            analyzeImage(conversationId: conversationId, userMessage: imageUrl)
        }else {
            print("Error \(error)")
        }
    }
}

private func analyzeImage(conversationId: String, userMessage: String){
    let jsonDic = ["conversationId": conversationId, "userMessage" : userMessage] as Dictionary<String, String>
    httpPostJson(url: "https://www.captionbot.ai/api/message", jsonDict: jsonDic) { result, error in
        if result != nil {
            getCaption(conversationId: conversationId)
        }else {
            print("Error \(error)")
        }
    }
}

private func getCaption(conversationId: String){
    let captionUrl = "https://www.captionbot.ai/api/message?waterMark=&conversationId=" + conversationId
    httpGet(url: captionUrl) { html, error in
        if let html = html {
            var jsonString = html
            
            jsonString.remove(at: jsonString.startIndex)
            jsonString.remove(at: jsonString.index(before: jsonString.endIndex))
            jsonString = jsonString.replacingOccurrences(of: "\\", with: "", options: .caseInsensitive, range: nil)
            
            let jsonDict = convertStringToDictionary(text: jsonString)
            let botMessages = jsonDict?["BotMessages"] as? [String]
            let message = (botMessages?[1])! as String
            print("Caption: \(message)")
            
        }else {
            print("Error \(error)")
        }
    }
}



private func convertStringToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.data(using: String.Encoding.utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
        } catch let error as NSError {
            print(error)
        }
    }
    return nil
}


private func httpGet(url: String, completionHandler: @escaping (String?, NSError?) -> Void ) {
    
    let myUrl = URL(string: url)
    var request = URLRequest(url:myUrl!)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        guard error == nil else {
            completionHandler(nil, error as NSError?)
            return
        }
        guard let data = data else {
            completionHandler(nil, nil)
            return
        }
        
        let result = String(data: data, encoding: String.Encoding.utf8)
        completionHandler(result, nil)
        return
    }
    task.resume()
}


private func httpPostImage(url: String, image: UIImage, completionHandler: @escaping (String?, NSError?) -> Void ) {
    
    let myUrl = URL(string: url)
    var request = URLRequest(url:myUrl!)
    request.httpMethod = "POST"
    request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
    let imageData = UIImageJPEGRepresentation(image, 0.5)!
    let boundary = generateBoundaryString()
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let body = NSMutableData()
    let fname = "caption.png"
    let mimetype = "image/png"
    
    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
    body.append("Content-Disposition:form-data; name=\"image1\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
    body.append(imageData)
    body.append("\r\n".data(using: String.Encoding.utf8)!)
    
    body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
    
    request.httpBody = body as Data
    
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        guard error == nil else {
            completionHandler(nil, error as NSError?)
            return
        }
        guard let data = data else {
            completionHandler(nil, nil)
            return
        }
        
        let result = String(data: data, encoding: String.Encoding.utf8)
        completionHandler(result, nil)
        return
    }
    
    task.resume()
    
}

private func httpPostJson(url: String, jsonDict: Dictionary<String, String>, completionHandler: @escaping (String?, NSError?) -> Void ){
    
    let myUrl = URL(string: url)
    var request = URLRequest(url:myUrl!)
    request.httpMethod = "POST"
    
    request.httpBody = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        guard error == nil else {
            completionHandler(nil, error as NSError?)
            return
        }
        guard let data = data else {
            completionHandler(nil, nil)
            return
        }
        
        let result = String(data: data, encoding: String.Encoding.utf8)
        completionHandler(result, nil)
        return
    }
    task.resume()
}

private func generateBoundaryString() -> String
{
    return "Boundary-\(UUID().uuidString)"
}
