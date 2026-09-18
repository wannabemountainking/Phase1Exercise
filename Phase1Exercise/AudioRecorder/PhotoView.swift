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
	@State private var shouldChangeImage: Bool = false
	
	let currentVoiceID: UUID
	
    var body: some View {
        
		VStack(spacing: 5) {
			PhotosPicker(
				selection: $pm.currentPhotosItem,
				matching: .images,
				label: {
					switch rm.hasPhotoImage(for: currentVoiceID) {
					case .none:
						Image(systemName: "photo")
							.resizable()
							.scaledToFit()
							.frame(width: 35, height: 35)
					case .some(true):
						if let image = pm.selectedImage {
							image
								.resizable()
								.scaledToFit()
								.frame(width: 35, height: 35)
								.alert(
									"이미지 교체",
									isPresented: $shouldChangeImage,
									actions: {
										Button("교체") {
											// Action
											Task {
												await writeImageAction(item: pm.currentPhotosItem)
											}
										}
										Button("취소") {
											// Action
										}
									},
									message: {
										Text("이미지를 교체하시겠습니까?")
									}
								)
						}
					case .some(false):
						Image(systemName: "photo")
							.resizable()
							.scaledToFit()
							.frame(width: 35, height: 35)
					}
				}
			)
			.onChange(of: pm.currentPhotosItem) { _, newValue in
				Task {
					await writeImageAction(item: newValue)
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
		} catch {
			rm.lastErrorMessage = error.localizedDescription
			return nil
		}
	}
	
	private func writeImageAction(item: PhotosPickerItem?) async {
		guard let imageURL = rm.voices.first(where: { $0.id == currentVoiceID })?.imageDataURL else { return }
		Task {
			let image = await putItemToPreviewImage(item, url: imageURL)
			pm.selectedImage = image
		}
	}
}

#Preview {
	PhotoView(currentVoiceID: Voice().id)
}
