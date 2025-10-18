//
//  ChatView.swift
//  NutritionApp
//
//  Created by 49 on 18/10/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var vm = ChatViewModel()

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(vm.messages) { msg in
                            MessageBubble(message: msg)
                        }
                    }
                    .onChange(of: vm.messages.count) { _ in
                        if let last = vm.messages.last?.id {
                            withAnimation {
                                proxy.scrollTo(last, anchor: .bottom)
                            }
                        }
                    }
                }
            }

            HStack {
                TextField("Nhập tin nhắn...", text: $vm.userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 40)

                Button {
                    Task {
                        await vm.sendMessage()
                    }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.blue)
                }
                .disabled(vm.userInput.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
        }
        .navigationTitle("AI")
    }
}
