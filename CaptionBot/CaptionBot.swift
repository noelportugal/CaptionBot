//
//  CaptionBot.swift
//  CaptionBot
//
//  Created by Noel Portugal on 10/2/16.
//  Copyright © 2016 theiotlabs. All rights reserved.
//

import Foundation
import UIKit

public func captionBot(url: String, completion: @escaping (String?, Error?) -> Void) {
    
    getConversationId(){ conversationId, error in
        if let conversationId = conversationId {
            analyzeImage(conversationId: conversationId, userMessage: url){ message, error in
                if message != nil {
                    getCaption(conversationId: conversationId){ caption, error in
                        if let caption = caption {
                            completion(caption, nil)
                            return
                        }else{
                            completion(nil, error)
                            return
                        }
                    }
                }else{
                    completion(nil, error)
                    return
                }
            }            
        }else{
            completion(nil, error)
            return
        }
    }
    
}

public func captionBot(image: UIImage, completion: @escaping (String?, Error?) -> Void){

    getConversationId(){ conversationId, error in
        if let conversationId = conversationId {
            getImageUrl(conversationId: conversationId, image: image ) { imageUrl , error in
                if let imageUrl = imageUrl {
                    analyzeImage(conversationId: conversationId, userMessage: imageUrl){ message, error in
                        if message != nil {
                            getCaption(conversationId: conversationId){ caption, error in
                                if let caption = caption {
                                    completion(caption, nil)
                                    return
                                }else{
                                    completion(nil, error)
                                    return
                                }
                            }
                        }else{
                            completion(nil, error)
                            return
                        }
                    }
                }else{
                    completion(nil, error)
                    return
                }
            }
        }else{
            completion(nil, error)
            return
        }
    }
    
    
}

private let baseUrl = "https://www.captionbot.ai/"

private func getConversationId(completion: @escaping (String?, Error?) -> Void){
    httpGet(url: baseUrl + "api/init") { conversationId, error in
        if let conversationId = conversationId?.replacingOccurrences(of: "\"", with: "") {
            completion(conversationId, nil)
            return
        }else {
            completion(nil, error)
            return
        }
    }
}


private func getImageUrl(conversationId: String, image: UIImage, completion: @escaping (String?, Error?) -> Void){
    httpPostImage(url: baseUrl + "api/upload", image: image) {imageUrl, error in
        if let imageUrl = imageUrl?.replacingOccurrences(of: "\"", with: "") {
            completion(imageUrl, nil)
            return
        }else {
            completion(nil, error)
            return
        }
    }
}


private func analyzeImage(conversationId: String, userMessage: String, completion: @escaping (String?, Error?) -> Void){
    let jsonDic = ["conversationId": conversationId, "userMessage" : userMessage] as Dictionary<String, String>
    httpPostJson(url: baseUrl + "api/message", jsonDict: jsonDic) { result, error in
        if result != nil {
            completion("Success", nil)
            return
        }else {
            completion(nil, error)
            return
        }
    }
}

private func getCaption(conversationId: String, completion: @escaping (String?, Error?) -> Void){
    let captionUrl = baseUrl + "api/message?waterMark=&conversationId=" + conversationId
    httpGet(url: captionUrl) { html, error in
        if let html = html {
            var jsonString = html
            
            jsonString.remove(at: jsonString.startIndex)
            jsonString.remove(at: jsonString.index(before: jsonString.endIndex))
            jsonString = jsonString.replacingOccurrences(of: "\\", with: "", options: .caseInsensitive, range: nil)
            
            let jsonDict = convertStringToDictionary(text: jsonString)
            let botMessages = jsonDict?["BotMessages"] as? [String]
            let message = (botMessages?[1])! as String
            completion(message, nil)
            return
            
        }else {
            completion(nil, error)
            return
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


private func httpGet(url: String, completion: @escaping (String?, NSError?) -> Void ) {
    
    let myUrl = URL(string: url)
    var request = URLRequest(url:myUrl!)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        guard error == nil else {
            completion(nil, error as NSError?)
            return
        }
        guard let data = data else {
            completion(nil, nil)
            return
        }
        
        let result = String(data: data, encoding: String.Encoding.utf8)
        completion(result, nil)
        return
    }
    task.resume()
}


private func httpPostImage(url: String, image: UIImage, completion: @escaping (String?, NSError?) -> Void ) {
    
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
            completion(nil, error as NSError?)
            return
        }
        guard let data = data else {
            completion(nil, nil)
            return
        }
        
        let result = String(data: data, encoding: String.Encoding.utf8)
        completion(result, nil)
        return
    }
    
    task.resume()
    
}

private func httpPostJson(url: String, jsonDict: Dictionary<String, String>, completion: @escaping (String?, NSError?) -> Void ){
    
    let nsUrl = URL(string: url)
    var request = URLRequest(url:nsUrl!)
    request.httpMethod = "POST"
    
    request.httpBody = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        guard error == nil else {
            completion(nil, error as NSError?)
            return
        }
        guard let data = data else {
            completion(nil, nil)
            return
        }
        
        let result = String(data: data, encoding: String.Encoding.utf8)
        completion(result, nil)
        return
    }
    task.resume()
}

private func generateBoundaryString() -> String
{
    return "Boundary-\(UUID().uuidString)"
}
