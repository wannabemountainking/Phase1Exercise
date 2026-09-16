//
//  PhotoView.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/12/26.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
	
	@State private var photoManager: PhotoManager = .shared
	@State private var recordManager: RecordingManager = .shared
	var selectedImage: Image? {
		Task {
			let data = try? await photoManager.fetchImageData(photoManager.currentPhotosItem)
		}
		guard let imageData = data,
			  let uiImage = UIImage(data: imageData),
			  let selectedImage = Image(uiImage: uiImage) else {return nil}
		return selectedImage
	
	}
	
    var body: some View {
        
		VStack(spacing: 5) {
			
			if let currVoice = recordManager.currentVoice,
			   let hasPhotoImage = recordManager.hasPhotoImage(for: currVoice.id),
			   hasPhotoImage {
				
			} else {
				
				if let currentImageUrl =
				   let image = UIImage(data: photoManager.fetchImageData(photoManager.currentPhotosItem)) {
					
				} else {
					Image(systemName: "photo")
						.resizable()
						.frame(width: 35, height: 35)
						.foregroundStyle(.gray)
				}
				PhotosPicker(
					selection: $photoManager.currentPhotosItem,
					matching: .images,
					label: { }
				)
			}
			
		} //:VSTACK
    }
}

#Preview {
	PhotoView()
}
