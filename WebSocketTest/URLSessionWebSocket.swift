//
//  URLSessionWebSocket.swift
//  WebSocketTest
//
//  Created by 王冠之 on 2022/5/20.
//

import Foundation
import Starscream
import SwiftUI

class URLSessionWebSocket: NSObject {
    
    var webSocketTask: URLSessionWebSocketTask?
    var receviedContent: ((String) -> ())? = nil
    
    init(receviedContent:((String) -> ())? = nil) {
        super.init()
        self.receviedContent = receviedContent
    }

    func connect() {
        guard let url = URL(string: "ws://192.168.20.75:1337/") else {
            print("Error: can not create URL")
            return
        }

        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: .main)

        webSocketTask = urlSession.webSocketTask(with: url, protocols: ["chat"])
        receive()
        webSocketTask?.resume()
    }

    private func receive() {
        webSocketTask?.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received string: \(text)")
                    self.receviedContent?(text)
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError()
                }

            case .failure(let error):
                print(error)
            }

            self.receive()
        }
    }

    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print(error)
            }
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func deCodeToModel(str: String?) -> Any {
        guard let str = str else {
            return ""
        }

        var messageType: messageType = .history
        if let data = str.data(using: .utf8) {
            let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:AnyObject]
            if let json = json{
                let type = json["type"] as? String ?? ""
                switch type{
                case "history":
                    messageType = .history
                    var datasModel: [MessageDataModel] = []
                    let datas = json["data"] as? [Dictionary<String,Any>] ?? []
                    
                    for i in datas {
                        let name = i["author"] as? String ?? ""
                        let message = i["text"] as? String ?? ""
                        let color = i["color"] as? String ?? ""
                        let time = i["time"] as? String ?? ""
                        datasModel.append(.init(author: name, text: message, color: color.converToColor(), time: time))
                    }
                    
                    return MessageModel(type: messageType, data: datasModel)
                case "message":
                    messageType = .message
                    let messageData = json["data"] as? Dictionary<String,Any> ?? [:]
                    let name = messageData["author"] as? String ?? ""
                    let message = messageData["text"] as? String ?? ""
                    let color = messageData["color"] as? String ?? ""
                    let time = messageData["time"] as? String ?? ""
                    return MessageModel(type: messageType, data: [.init(author: name, text: message, color: color.converToColor(), time: time)])
                case "color":
                    messageType = .color
                    let colorString = json["data"] as? String ?? ""
                    return OnlyColorModel(type: .color, color: colorString.converToColor())
                default:
                    return ""
                }

            }

        }
        return ""
        
    }
    
}

extension URLSessionWebSocket: URLSessionWebSocketDelegate {
    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didOpenWithProtocol protocol: String?) {
        print("URLSessionWebSocketTask is connected")
    }

    public func urlSession(_ session: URLSession,
                           webSocketTask: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?) {
        let reasonString: String
        if let reason = reason, let string = String(data: reason, encoding: .utf8) {
            reasonString = string
        } else {
            reasonString = ""
        }

        print("URLSessionWebSocketTask is closed: code=\(closeCode), reason=\(reasonString)")
    }
}

extension URLSessionWebSocket: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
