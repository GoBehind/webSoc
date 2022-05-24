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
    @State var userName: String = ""
    @State var okToGo: Bool = false
    @State var datas = MessageModel(data: [])
    @State var contentView = [AnyView]()
    
    var body: some View {
        NavigationView{
            VStack {
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(self.contentView.indices, id: \.self) { i in
                        self.contentView[i]
                    }
                }.onAppear(perform: self.setupViews)
//                TextView(text: $message)
//                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        Button {
                            urlSession.send(message: "我看你完全是不懂喔")
                        } label: {
                            Text("我看你完全是不懂喔")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.white)
                                .padding(5)
                        }
                        .background(Color.pink)
                        .cornerRadius(6.0)
                        
                        Button {
                            urlSession.send(message: "都幾歲了還這麼害羞")
                        } label: {
                            Text("都幾歲了還這麼害羞")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.white)
                                .padding(5)
                        }
                        .background(Color.gray)
                        .cornerRadius(6.0)
                        
                        Button {
                            urlSession.send(message: "那個彬彬就是遜啦！")
                        } label: {
                            Text("那個彬彬就是遜啦！")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.white)
                                .padding(5)
                        }
                        .background(Color.blue)
                        .cornerRadius(6.0)
                        
                        Button {
                            urlSession.send(message: "聽話！讓我看看")
                        } label: {
                            Text("聽話！讓我看看")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.white)
                                .padding(5)
                        }
                        .background(Color.orange)
                        .cornerRadius(6.0)
                    }
                    .padding(2.5)
                }
                .padding(.horizontal, 5)
                
                HStack {
                    TextField("使用者名稱", text: $userName)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                        .disabled(self.okToGo)
                    Button {
                        if !self.okToGo {
                            urlSession.receviedContent = { msg in
                                self.datas = urlSession.deCodeToModel(str: msg) as! MessageModel
//                                self.message += msg
                            }
                            urlSession.connect()
                            urlSession.send(message: self.userName)
                            self.okToGo = true
                        } else {
                            urlSession.disconnect()
                            self.okToGo = false
                        }
                        
                    } label: {
                        Text(self.okToGo ? "離線" : "連結")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.white)
                            .padding(5)
                    }
                    .background(Color.yellow)
                    .cornerRadius(6.0)
                }
                .padding([.bottom, .horizontal])
                .frame(width: UIScreen.main.bounds.width)
            
            }
            .navigationTitle("WebSocketTest")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func outputText(user: String, content: String) -> String {
        return "\("text"):\(content),\("author"):\(user)"
    }
    
    func setupViews() {
        for item in self.datas.data {
            self.contentView.append(AnyView(MsgView(name: item.author,
                                                    content: item.text,
                                                    dateString: String(item.time),
                                                    textColor: item.color)))
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
