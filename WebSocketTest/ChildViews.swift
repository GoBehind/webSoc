//
//  ChildViews.swift
//  WebSocketTest
//
//  Created by 王冠之 on 2022/5/23.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {

    @Binding var text: String
    let textView = UITextView()

    func makeUIView(context: Context) -> UITextView {
        
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.dataDetectorTypes = .link
        textView.isEditable = false
        textView.autocapitalizationType = .allCharacters
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        let bottomOffset = CGPoint(x: 0, y: uiView.contentSize.height - uiView.bounds.size.height)
        uiView.setContentOffset(bottomOffset, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var text: Binding<String>
        
        init(_ text: Binding<String>) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
    
    
}

struct MsgView: View {
    
    var name: String
    var content: String
    var dateString: String
    var textColor: Color
    
    var body: some View {
        HStack (alignment: .top){
            Text(self.name)
                .foregroundColor(self.textColor)
                .font(.headline)
            
            VStack(alignment: .leading){
                Text(self.content)
                    .foregroundColor(self.textColor)
                    .font(.body)
                Text(self.dateString)
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
        }
    }
}

struct MsgView_Previews: PreviewProvider {
    static var previews: some View {
        MsgView(name: "User", content: "1234", dateString: "20220505", textColor: .blue)
    }
}
