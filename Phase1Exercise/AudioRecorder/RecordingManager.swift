//
//  RecordManager.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/10/26.
//

import Foundation
import Observation
import AVFAudio


struct Voice: Identifiable {
	let id = UUID()
	var title: String?
	var duration: TimeInterval? = nil
	let dateRecorded: Date = Date()
	
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
	
	init(title: String? = nil) {
		if let title {
			self.title = title
		} else {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy년 MM월 dd일 dd시"
			self.title = formatter.string(from: Date())
		}
	}
}

@Observable
final class RecordingManager: NSObject {
	
	static let shared = RecordingManager()
	
	var voices: [Voice] = []
	var currentVoice: Voice? = nil
	
	var recorder: AVAudioRecorder? = nil
	var timer: Timer? = nil
	var isRecording: Bool = false
	var lastErrorMessage: String = ""
	var recordEventHandler = RecordEventHandler()
	
	private override init() {
		super.init()
		requestRecordAuthorization()
	}
	
	func requestRecordAuthorization(title: String? = nil) {
		AVAudioApplication.requestRecordPermission { [weak self] granted in
			if !granted {
				guard let self else { return }
				self.lastErrorMessage = "마이크 권한 거부"
				print(self.lastErrorMessage)
				return
			} else {
				print("마이크 권한 허용")
			}
		}
	}
	
	func record() {
		guard let url = currentVoice?.fileURL else {return}
		
		let settings: [String : Any] = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVSampleRateKey: 12000,
			AVNumberOfChannelsKey: 1,
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
		]
		
		do {
			recorder = try AVAudioRecorder(url: url, settings: settings)
			self.isRecording = true
			recorder?.delegate = recordEventHandler
			recorder?.record()
		} catch {
			self.lastErrorMessage = "녹음 객체 생성 실패"
		}
	}
}

final class RecordEventHandler: NSObject, AVAudioRecorderDelegate {
	
	var onFinish: (() -> Void)?
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		print("녹음이 끝났습니다")
		onFinish?()
	}
}

