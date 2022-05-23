//
//  URLSessionWebSocket.swift
//  WebSocketTest
//
//  Created by 王冠之 on 2022/5/20.
//

import Foundation
import Starscream

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
