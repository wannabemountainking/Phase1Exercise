//
//  RecordView.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/11/26.
//

import SwiftUI


struct RecordView: View {
	
	@State private var manager: RecordingManager = .shared
	
    var body: some View {
		VStack(spacing: 20) {
			
			// 녹음 단말기
			VStack(spacing: 30) {
				Text(manager.isRecording ? manager.currentTime.recordedTime : "")
					.font(.title)
					.fontWeight(.light)
				Button {
					// Action
					Task {
						await manager.toggleRecordingState()
					}
				} label: {
					Image(systemName: manager.isRecording ? "stop.circle": "record.circle")
						.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50)
						.foregroundStyle(manager.isRecording  ? Color.red : Color.green)
				}
			} //:VSTACK
			
			Divider()
			
			// 녹음 목록
			ScrollView {
				VStack(alignment: .leading, spacing: 10) {
					ForEach(manager.voices) { voice in
						HStack(spacing: 10) {
							PhotoView()
							
							Text(voice.title ?? "No Title")
							
							Text((voice.duration ?? 0).recordedTime)
							Spacer()
						} //:HSTACK
						.font(.title3)
						.fontWeight(.semibold)
						.onTapGesture {
							manager.currentVoice = voice
							print("재생")
						}
						.padding(.horizontal, 20)
					} //:LOOP
				} //:VSTACK
			} //:SCROLL
		} //:VSTACK
    }
}

extension TimeInterval {
	var recordedTime: String {
		let f = DateComponentsFormatter()
		f.allowedUnits = [.minute, .second]
		f.unitsStyle = .positional
		f.zeroFormattingBehavior = .pad
		return f.string(from: self) ?? "00:00"
	}
}

#Preview {
    RecordView()
}
