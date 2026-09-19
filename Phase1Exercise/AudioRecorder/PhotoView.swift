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
	@State private var isShowingAlert: Bool = false
	
	let currentVoiceID: UUID
	
    var body: some View {
        
		VStack(spacing: 5) {
			PhotosPicker(
				selection: $pm.currentPhotosItem,
				matching: .images,
				label: {
                    if let image = pm.selectedImage {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
					} else if pm.selectedImage == nil {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                    }
				}
			)
			.onChange(of: pm.currentPhotosItem) { _, newValue in
				if pm.selectedImage != nil {
					isShowingAlert = true
				} else {
					Task {
						await writeImageAction(item: newValue)
					}
				}
			}
			.alert(
				"이미지 교체",
				isPresented: $isShowingAlert,
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
			.onAppear {
				guard let currentVoicePathUrl = rm.getSelectedImageURL(for: currentVoiceID) else {
					rm.lastErrorMessage = "file 의 URL을 찾지 못했습니다"
					return
				}
				do {
					let urlString = try String(contentsOf: currentVoicePathUrl, encoding: .utf8)
					guard let imageData = FileManager.default.contents(atPath: urlString) else {
						rm.lastErrorMessage = "이미지 데이터가 없습니다"
						return
					}
					guard let image = pm.DataToImage(data: imageData) else {
						rm.lastErrorMessage = "Data를 Image로 변환할 수 없습니다"
						return
					}
					pm.selectedImage = image
				} catch {
					rm.lastErrorMessage = error.localizedDescription
					return
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
