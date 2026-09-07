//
//  RowView.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/6/26.
//

import SwiftUI

struct TodoRowView: View {
	
	@Binding var todo: TodoItem
	
    var body: some View {
		HStack(spacing: 20) {
			Image(systemName: todo.isDone ? "checkmark.app" : "app")
				.resizable()
				.scaledToFit()
				.frame(width: 20, height: 20)
				.foregroundStyle(todo.isDone ? Color.pink : .gray)
			
			Text(todo.title)
				.font(.title3)
				.fontWeight(.medium)
            Spacer()
		} //:HSTACK
		.frame(maxWidth: .infinity)
		.contentShape(Rectangle())
		.onTapGesture {
			withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
				todo.isDone.toggle()
			}
		}
    }
}

#Preview {
	TodoRowView(todo: .constant(TodoItem(title: "우유사기", isDone: false)))
}
