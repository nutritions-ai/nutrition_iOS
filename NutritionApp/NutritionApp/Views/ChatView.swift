//
//  ChatView.swift
//  NutritionApp
//
//  Created by 49 on 18/10/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var vm = ChatViewModel()
    @EnvironmentObject var shared: SharedData  // dùng để nhận scrollToMessageID

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(vm.messages) { msg in
                            MessageBubble(message: msg)
                                .id(msg.id)  // dùng id để scroll
                        }
                    }
                    .onChange(of: vm.messages.count) { _, _ in
                        if let last = vm.messages.last?.id {
                            withAnimation {
                                proxy.scrollTo(last, anchor: .bottom)
                            }
                        }
                    }
                }
                .onAppear {
                    // scroll tới message nếu tới từ History
                    if let targetID = shared.scrollToMessageID {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                proxy.scrollTo(targetID, anchor: .center)
                            }
                            shared.scrollToMessageID = nil
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
        .navigationTitle("Chatbot AI")
        .navigationBarTitleDisplayMode(.inline)
    }
}
