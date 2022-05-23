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
        textView.autocapitalizationType = .sentences
        textView.isSelectable = false
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    }
    
}
