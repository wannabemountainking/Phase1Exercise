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
	
	var photosItems: [PhotosPickerItem] = []
	
	private init() {}
	
	func fetchImageData(_ item: PhotosPickerItem) async throws -> Data {
		// loadTransferable로 Data 뽑기
		guard let data = try await item.loadTransferable(type: Data.self) else {
			throw PhotoError.noData
		}
		return data
	}
	
	enum PhotoError: Error {
		case noData
	}
}



