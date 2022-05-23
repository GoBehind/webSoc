//
//  ContentView.swift
//  WebSocketTest
//
//  Created by 王冠之 on 2022/5/20.
//

import SwiftUI

struct ContentView: View {
    
    let urlSession = URLSessionWebSocket()
    @State var message = ""
    
    var body: some View {
        NavigationView{
            VStack {
                
                TextView(text: $message)
                    .onChange(of: self.message, perform: { newValue in
                        
                    })
                    .padding(.horizontal)
                
                Button {
                    urlSession.receviedContent = { msg in
                        self.message += msg
                    }
                    urlSession.connect()
//                    if let msg = urlSession.receviedContent {
//                        msg(self.message)
//                    }
                } label: {
                    Text("傑哥你幹嘛")
                        .font(.system(.title2, design: .rounded))
                        .foregroundColor(.yellow)
                }.padding()
                
                Button {
                    urlSession.send(message: "我看你完全是不懂喔")
                } label: {
                    Text("我看你完全是不懂喔")
                        .font(.system(.title2, design: .rounded))
                        .foregroundColor(.pink)
                }
                
                Button {
                    urlSession.disconnect()
                } label: {
                    Text("這個彬彬就是遜啦")
                        .font(.system(.title2, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding()
            }

            
            .navigationTitle("WebSocketTest")
            .navigationBarTitleDisplayMode(.large)
        }
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public enum WebSocketEvent {
    case connected([String: String])  //!< 連接成功
    case disconnected(String, UInt16) //!< 連接斷開
    case text(String)                 //!< string通信
    case binary(Data)                 //!< data通信
    case pong(Data?)                  //!< 處理pong包（保活）
    case ping(Data?)                  //!< 處理ping包（保活）
    case error(Error?)                //!< 錯誤
    case viablityChanged(Bool)        //!< 可行性改變
    case reconnectSuggested(Bool)     //!< 重新連接
    case cancelled                    //!< 已取消
}
