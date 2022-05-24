//
//  MessageModel.swift
//  WebSocketTest
//
//  Created by 陳逸煌 on 2022/5/23.
//

import Foundation
import SwiftUI

enum messageType {
    case history
    case message
    case color
}

extension String{
    func converToColor() -> Color {
        switch self{
        case "red" :
            return .red
        case "blue" :
            return .blue
        case "green" :
            return .green
        case "purple" :
            return .purple
        case "orange":
            return .orange
        default :
            return .pink
        }
    }
}

class MessageDataModel {
    
    //姓名
    var author: String = ""
    
    //內容
    var text: String = ""
    
    //顏色
    var color: Color = .black
    
    //時間
    var time: String = ""
    
    init(
        author: String = "",
        text: String = "",
        color: Color = .black,
        time: String = ""
    ){
        self.author = author
        self.text = text
        self.color = color
        self.time = time
    }
    
}



//回傳訊息類別
class MessageModel {
    var type: messageType = .history
    
    //訊息陣列(歷史訊息跟新的訊息都用這個)
    var data: [MessageDataModel] = [MessageDataModel()]
    
    init(
        type: messageType = .history,
        data: [MessageDataModel]
    ){
        self.type = type
        self.data = data
    }
}

class OnlyColorModel{
    
    var type: messageType = .color
    
    var color: Color = .black
    
    init(
        type: messageType = .history,
        color: Color = .black
    ){
        self.type = type
        self.color = color
        
    }
}
