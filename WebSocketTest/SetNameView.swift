//
//  SetNameView.swift
//  WebSocketTest
//
//  Created by 陳逸煌 on 2022/5/24.
//

import Foundation
import SwiftUI
struct SetNameView: View {
    @State var name: String  = ""
    @State var isPush: Bool = false
    @State var roomID: String = ""
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center){
                TextField("輸入你的姓名", text: $name)
                    .padding()
                    .frame(width: 200, height:40, alignment: .center)
                    .border(.gray, width: 1)
                TextField("輸入聊天室關鍵字", text: $roomID)
                    .padding()
                    .frame(width: 200, height:40, alignment: .center)
                    .border(.gray, width: 1)
                Button {
                    self.isPush = true
                } label: {
                    NavigationLink(destination: ContentView(userName: $name,
                                                            isPush: $isPush,
                                                            roomID: $roomID),
                                   isActive: $isPush) {
                        Text("確定")
                    }
                }
            }
            .navigationTitle("WebSocketTest")
            .navigationBarTitleDisplayMode(.large)
        }
        
    }
}

struct SetNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNameView(name: "")
    }
}
