//
//  SwiftUIView.swift
//  
//
//  Created by Joschua Marz on 04.01.24.
//

import SwiftUI

struct SwiftUIView: View {
    @FocusState var isFocused
    @State var text: String = ""
    @State var placeholder: String = "test"
    var body: some View {
        VStack {
            DKTextField(
                placeholder: $placeholder,
                text: $text
            )
            .defaultConfiguration()
            .focusState($isFocused)
            .keyboardType(.numberPad)
            
            Button("change") {
                if placeholder == "test" {
                    placeholder = "hello"
                } else {
                    placeholder = "test"
                }
                isFocused.toggle()
            }
        }
        .padding()
    }
}

#Preview {
    SwiftUIView()
}
