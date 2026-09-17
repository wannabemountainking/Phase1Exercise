//
//  PhotoView.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/12/26.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
	
	@State private var pm: PhotoManager = .shared
	@State private var rm: RecordingManager = .shared
	
	let currentVoiceID: UUID
	
    var body: some View {
        
		VStack(spacing: 5) {
			if let hasPhotoImage = rm.hasPhotoImage(for: currVoiceID),
			   hasPhotoImage {
				
			} else {
				PhotosPicker(
					selection: $pm.currentPhotosItem,
					matching: .images,
					label: {
						if let
					}
				)
				.onChange(of: pm.currentPhotosItem) {
					oldValue,
					newValue in
					if let url = rm.currentVoice?.imageDataURL,
					   newValue == nil || shouldChangeImage {
						Task {
							pm.selectedImage = putItemToPreviewImage(
								pm.currentPhotosItem,
								url: url
							)
						}
					} else {
						
					}
				}
			}
			
		} //:VSTACK
    }
	
	private func putItemToPreviewImage(_ item: PhotosPickerItem?, url: URL) async -> Image? {
		do {
			let imageData = try await pm.fetchImageData(item)
			guard let image = pm.DataToImage(data: imageData) else {
				rm.lastErrorMessage = "데이터 변환 실패"
				return nil
			}
			rm.writeImage(photoData: imageData, url: url)
			return image
				.resizable()
				.scaledToFit()
				.frame(width: 35, height: 35)
		} catch {
			rm.lastErrorMessage = error.localizedDescription
			return nil
		}
	}
}

#Preview {
	PhotoView()
}
