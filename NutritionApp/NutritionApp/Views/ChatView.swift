//
//  ChatView.swift
//  NutritionApp
//
//  Created by 49 on 18/10/25.
//

import SwiftUI
import AVFoundation

struct ChatView: View {
    @StateObject private var vm = ChatViewModel()
    @EnvironmentObject var shared: SharedData  // dùng để nhận scrollToMessageID
    
    @State private var speechSynthesizer = AVSpeechSynthesizer()

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
        .onReceive(vm.$messages) { newMessages in
            guard let lastMessage = newMessages.last, lastMessage.role == "user" else { return }
            if lastMessage.content != ""  {
                speakText("Sau đây là câu trả lời của " + lastMessage.content)
            }
        }
    }
}

// MARK: - Text-to-Speech
extension ChatView {
    func speakText(_ text: String, language: String = "vi-VN", rate: Float = 0.5) {
        guard !text.isEmpty else { return }
        
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate
        
        speechSynthesizer.speak(utterance)
    }
}
