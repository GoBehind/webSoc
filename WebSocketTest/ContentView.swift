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
    @Binding var userName: String
    @State var okToGo: Bool = false
    @State var datas = MessageModel(data: [])
    @State var contentView = [AnyView]()
    
    var body: some View {
        VStack (alignment: .leading){
            ScrollView(.vertical, showsIndicators: true) {
                ScrollViewReader { value in
                    ForEach(self.contentView.indices, id: \.self) { i in
                        self.contentView[i]
                    }
                    .onChange(of: self.contentView.count){ _ in
                        value.scrollTo(self.contentView.count - 1)
                    }
                }
               
            }
            .frame(width: UIScreen.main.bounds.width )
            .padding(5)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    Button {
                        urlSession.send(message: "我看你完全是不懂喔")
                        UIApplication.shared.endEditing()
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
                        UIApplication.shared.endEditing()
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
                        UIApplication.shared.endEditing()
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
                        UIApplication.shared.endEditing()
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
                TextField("請輸入訊息內容", text: $message)                   .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    urlSession.send(message: self.message)
                    self.message = ""
                    UIApplication.shared.endEditing()
                } label: {
                    Text("傳送")
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
        .onAppear{
            urlSession.receviedContent = { msg in
                if let models = urlSession.deCodeToModel(str: msg) as? MessageModel{
                    self.datas = models
                    self.setupViews()
                }
            }
            urlSession.connect()
            urlSession.send(message: self.userName)
        }
        .onDisappear{
            urlSession.disconnect()
        }
        
    }
    
    
    func setupViews() {
        for item in self.datas.data {
            guard !item.text.isEmpty else { return }
            self.contentView.append(AnyView(MsgView(name: item.author,
                                                    content: item.text,
                                                    dateString: String(item.time),
                                                    textColor: item.color,
                                                    isSelf: item.author == self.userName)))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userName: .constant("user"))
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
