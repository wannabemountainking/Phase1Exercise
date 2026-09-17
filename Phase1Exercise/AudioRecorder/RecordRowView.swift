//
//  RecordRowView.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/17/26.
//

import SwiftUI

struct RecordRowView: View {

	let voice: Voice
	var manager: RecordingManager
	
    var body: some View {
		HStack(spacing: 10) {
			PhotoView(currentVoiceID: voice.id)
			
			Text(voice.title ?? "No Title")
			
			Text((voice.duration ?? 0).recordedTime)
			Spacer()
		} //:HSTACK
		.font(.title3)
		.fontWeight(.semibold)
		.padding(.horizontal, 20)
    }
}

#Preview {
	RecordRowView(
		voiceID: UUID(),
		voice: Voice(),
		manager: RecordingManager.shared
	)
}
