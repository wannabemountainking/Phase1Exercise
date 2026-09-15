//
//  VoiceModel.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/12/26.
//

import Foundation

struct Voice: Identifiable {
	let id = UUID()
	var title: String?
	var duration: TimeInterval? = nil
	var dateRecorded: Date = Date()
	var filename: String { "\(id.uuidString).m4a" }
	var fileURL: URL? {
		FileManager.default
			.urls(for: .documentDirectory, in: .userDomainMask)
			.first?
			.appending(
				path: filename,
				directoryHint: .notDirectory
			)
	}
	var imageDataURL: URL? {
		FileManager.default
			.urls(for: .applicationSupportDirectory, in: .userDomainMask)
			.first?
			.appending(path: "\(id)", directoryHint: .notDirectory)
	}
	
	init() {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy년_MM월_dd일_dd시"
		self.title = formatter.string(from: Date())
	}
}
