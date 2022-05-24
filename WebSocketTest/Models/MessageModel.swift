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
    case color
}

extension String{
    func converToColor() -> Color{
        switch self{
        case "red" :
            return .red
        case "blue" :
            return .blue
        case "green" :
            return .green
        case "magenta" :
            return .init(uiColor: UIColor(red: 1, green: 0, blue: 1, alpha: 1))
        case "purple" :
            return .purple
        case "plum" :
            return .init(uiColor: UIColor(red: 142/255, green: 69/255, blue: 113/255, alpha: 1))
        case "orange":
            return .orange
        default :
            return .black
        }
    }
}
class MessageDataModel{
    
    //姓名
    var author: String = ""
    
    //內容
    var text: String = ""
    
    //顏色
    var color: Color = .black
    
    //時間
    var time: Int = 0
    
    init(
        author: String = "",
        text: String = "",
        color: Color = .black,
        time: Int = 0
    ){
        self.author = author
        self.text = text
        self.color = color
        self.time = time
    }
    
}

class MessageModel{
    
    //回傳訊息類別
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
