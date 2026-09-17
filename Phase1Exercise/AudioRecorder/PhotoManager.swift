//
//  PhotoManager.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/12/26.
//

import Observation
import SwiftUI
import PhotosUI

@Observable
final class PhotoManager {
	
	static let shared = PhotoManager()
	
	var currentPhotosItem: PhotosPickerItem? = nil
	var selectedImage: Image? = nil
	
	private init() {}
	
	func fetchImageData(_ item: PhotosPickerItem?) async throws -> Data {
		// loadTransferable로 Data 뽑기
		guard let photoItem = item,
			  let data = try await photoItem.loadTransferable(type: Data.self) else {
			throw PhotoError.noData
		}
		return data
	}
	
	func DataToImage(data: Data) -> Image? {
		guard let uiImage = UIImage(data: data) else { return nil}
		return Image(uiImage: uiImage)
	}
	
	enum PhotoError: Error {
		case noData
	}
}



