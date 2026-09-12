//
//  RecordManager.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/10/26.
//

import Foundation
import Observation
import AVFAudio


@Observable
final class RecordingManager: NSObject {
	
	static let shared = RecordingManager()
	
	var voices: [Voice] = []
	var currentVoice: Voice? = nil
	
	var recorder: AVAudioRecorder? = nil
	var timer: Timer? = nil
	var currentTime: TimeInterval = 0
	var currentRecordingTime: String = "00:00"
	var isRecording: Bool = false
	var lastErrorMessage: String = ""
	var recordEventHandler = RecordEventHandler()
	
	private override init() {
		super.init()
		
		// AVAudioSession에 녹음할 것이라는 선언
		let recordSession = AVAudioSession.sharedInstance()
		do {
			try recordSession.setCategory(.record)
			try recordSession.setActive(true)
		} catch {
			self.lastErrorMessage = error.localizedDescription
		}
		// 녹음 끝나면 실행 코드 설정
		self.recordEventHandler.onFinish = { [weak self] in
			guard let self else {return}
			
			// isRecording 상태 false
			self.isRecording = false
			// Duration 저장
			self.currentVoice?.duration = self.currentTime
			// 배열에 저장
			if let voice = self.currentVoice {
				self.voices.append(voice)
			}
			self.currentVoice = nil
			self.currentTime = 0
		}
	}
	
	private func requestRecordAuthorization() async -> Bool {
		await withCheckedContinuation { continuation in
			AVAudioApplication.requestRecordPermission { [weak self] granted in
				guard let self else { return }
				if !granted {
					self.lastErrorMessage = "마이크 권한 거부"
					print(self.lastErrorMessage)
				} else {
					print("마이크 권한 허용")
				}
				continuation.resume(returning: granted)
			}
		}
		
	}
	
	func record() async {
		// 권한 확인
		let isAuthorized = await requestRecordAuthorization()
		if isAuthorized {
			// Voice 인스턴스 생성
			self.currentVoice = Voice()
			
			// url 생성
			guard let url = self.currentVoice?.fileURL else {
				self.lastErrorMessage = "URL 에러"
				print(self.lastErrorMessage)
				return
			}
			
			// recorder 객체 생성
			let settings: [String : Any] = [
				AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
				AVSampleRateKey: 12000,
				AVNumberOfChannelsKey: 1,
				AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
			]
			
			do {
				self.recorder = try AVAudioRecorder(url: url, settings: settings)
				self.recorder?.delegate = self.recordEventHandler
				
				self.recorder?.record()
				self.isRecording = true
				
			} catch {
				self.lastErrorMessage = "AVAudioSession 생성 실패"
			}
			
			self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
				guard let self else { return }
				self.currentTime = self.recorder?.currentTime ?? 0
				self.currentRecordingTime = self.currentTime.recordedTime
			})
		}
	}
	
	func stop() {
		// recorder 정지
		self.recorder?.stop()
		// 타이머 정지
		self.timer?.invalidate()
		self.timer = nil
	}
	
	func toggleRecordingState() async {
		if self.isRecording {
			self.stop()
		} else {
			await self.record()
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

