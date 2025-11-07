//
//  Camera.swift
//  NutritionApp
//
//  Created by hung on 5/11/25.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @State private var showPhotoPicker = false
    @State private var showCamera = false
    @Binding var selectedImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(12)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .foregroundColor(.gray)
            }
            
            // Button to show options
            Button {
                showActionSheet()
            } label: {
                Label("Upload or Take Picture", systemImage: "camera.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem)
        .onChange(of: photoPickerItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(selectedImage: $selectedImage)
        }
    }
    
    private func showActionSheet() {
        // Just toggles options using UIKit alert style
        let alert = UIAlertController(title: "Select Option", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
            showCamera = true
        })
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { _ in
            showPhotoPicker = true
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present manually
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(alert, animated: true)
        }
    }
}

// MARK: - Camera View using UIKit
struct CameraView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
