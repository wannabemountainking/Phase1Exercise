//
//  RecordManager.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/10/26.
//

import Foundation
import Observation


struct RecordManager: Identifiable {
	let id = UUID()
	let title: String
	var dateRecorded: Date?
	var duration: TimeInterval
	
	var fileURL: URL? {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	}
}

@Observable
final class RecordingManager: NSObject {
	
	static let shared = RecordingManager()
	
	
	
	private override init() {
		super.init()
	}
}



