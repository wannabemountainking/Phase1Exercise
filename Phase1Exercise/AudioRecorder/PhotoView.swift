//
//  PhotoView.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/12/26.
//

import SwiftUI

struct PhotoView: View {
	
	@State private var photoManager: PhotoManager = .shared
	@State private var recordManager: RecordingManager = .shared
	
    var body: some View {
        
		VStack(spacing: 5) {
			
			if let currVoice = recordManager.currentVoice,
			   let hasPhotoImage = recordManager.hasPhotoImage(for: currVoice.id),
			   hasPhotoImage {
				
			} else {
				
			}
			
		} //:VSTACK
    }
}

#Preview {
	PhotoView()
}
