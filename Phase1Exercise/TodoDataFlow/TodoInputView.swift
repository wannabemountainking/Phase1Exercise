//
//  TodoInputVIew.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/6/26.
//

import SwiftUI

struct TodoInputView: View {
	
	@State private var todoString: String = ""
	let onAdd: (String) -> Void
	
    var body: some View {
        VStack(spacing: 10) {
            TextField("새 할 일 입력 ...", text: $todoString)
                .font(.title3)
                .fontWeight(.semibold)
                .textFieldStyle(.roundedBorder)
            Button {
                // Action
                onAdd(todoString)
                todoString = ""
            } label: {
                Text("추가")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(height: 35)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        } //:VSTACK
    }
}

#Preview {
	TodoInputView(onAdd: {_ in })
}
