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
	
    var body: some View {
        
		VStack(spacing: 5) {
			
			if let currVoice = rm.currentVoice,
			   let hasPhotoImage = rm.hasPhotoImage(for: currVoice.id),
			   hasPhotoImage {
				
			} else {
				
				
				PhotosPicker(
					selection: $pm.currentPhotosItem,
					matching: .images,
					label: {
						if
					}
				)
				.onChange(of: pm.selectedImage) { oldValue, newValue in
					if newValue == nil {
						
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
		} catch error {
			rm.lastErrorMessage = error.localizedDescription
			return nil
		}
	}
}

#Preview {
	PhotoView()
}
