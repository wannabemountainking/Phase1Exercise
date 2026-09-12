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
	var recordManager = RecordingManager.shared
	
	var photosItems: [PhotosPickerItem] = []
	
	private init() {}
	
	func savePhoto(_ item: PhotosPickerItem, for id: UUID) async throws {
		guard let imageData = try await item.loadTransferable(type: Data.self) else {
			throw PhotoError.noData
		}
		
		guard let index = recordManager.voices.firstIndex(where: { $0.id == id }) else { print("매칭 id 없음")
			return
		}
		recordManager.voices[index].imageData = imageData
		guard let url = recordManager.voices[index].imageDataURL else {
			throw PhotoError.wrongURL
		}
		try imageData.write(to: url, options: .atomic)
	}
	
	enum PhotoError: Error {
		case noData
		case wrongURL
	}
}



