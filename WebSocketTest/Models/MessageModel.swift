//
//  MessageModel.swift
//  WebSocketTest
//
//  Created by 陳逸煌 on 2022/5/23.
//

import Foundation
import SwiftUI

enum messageType{
    case history
    case message
}

extension String{
    func converToColor() -> Color{
        switch self{
        case "red":
            return .red
        case "blue":
            return .blue
        default :
            return .black
        }
    }
}

class MessageDataModel{
    
    var author: String = ""
    
    var text: String = ""
    
    var color: Color = .black
    
    var time: Int = 0
    
    init(
        author: String = "",
        text: String = "",
        color: Color = .black,
        time: Int = 0
    ){
        self.text = text
        self.color = color
    }
    
}

class MessageModel{
    var type: messageType = .history
    var data: [MessageDataModel] = [MessageDataModel()]
    init(
        type: messageType = .history,
        data: [MessageDataModel]
    ){
        self.type = type
        self.data = data
    }
}
