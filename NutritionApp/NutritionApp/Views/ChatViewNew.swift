//
//  ChatViewNew.swift
//  NutritionApp
//
//  Created by Chỉnh Trần on 4/11/25.
//

import SwiftUI
import AVFoundation
import PhotosUI

struct ChatViewNew: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Message
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.top, 10)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        if let lastID = viewModel.messages.last?.id {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()
                .padding(.vertical, 6)
            
            // MARK: - Message input bar
            HStack(spacing: 8) {
                // Photo capture button
                Button {
                    showImagePicker = true
                } label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                }
                .photosPicker(isPresented: $showImagePicker, selection: .constant(nil))
                .onChange(of: selectedImage) { _, image in
                    if let image = image {
                        Task { await viewModel.uploadImage(image) }
                    }
                }
                
                // Record button
                Button {
                    toggleRecording()
                } label: {
                    Image(systemName: isRecording ? "stop.circle.fill" : "mic.fill")
                        .font(.system(size: 22))
                        .foregroundColor(isRecording ? .red : .gray)
                }

                TextField("Nhập tin nhắn...", text: $viewModel.userInput)
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .foregroundColor(.primary)
                    .cornerRadius(18)
                    .submitLabel(.send)
                    .onSubmit {
                        Task { await viewModel.sendMessage() }
                    }

                // button send
                Button {
                    Task { await viewModel.sendMessage() }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                }
                .disabled(viewModel.userInput.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .navigationTitle("Trợ lý Sức khỏe 👩‍⚕️")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            stopRecording()
        }
    }
}

// MARK: - Recording processing
extension ChatViewNew {
    private func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true

            print("Started recording at \(fileURL)")
        } catch {
            print("Recording failed: \(error)")
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        if let url = audioRecorder?.url {
            Task { await viewModel.uploadAudio(url) }
        }
    }
    
    func speakText(_ text: String, language: String = "vi-VN", rate: Float = 0.5) {
        guard !text.isEmpty else { return }
        
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate // tốc độ đọc: 0.0 - 1.0
        
        synthesizer.speak(utterance)
    }
}

#Preview {
    NavigationStack {
        ChatViewNew()
    }
}
