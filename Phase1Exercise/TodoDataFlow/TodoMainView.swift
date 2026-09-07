//
//  MainView.swift
//  Phase1Exercise
//
//  Created by YoonieMac on 9/6/26.
//

import SwiftUI

struct TodoItem: Identifiable {
	let id = UUID()
	let title: String
	var isDone: Bool = false
}

struct TodoMainView: View {
	
	@State private var items: [TodoItem] = []
	
    var body: some View {
		VStack(spacing: 20) {
			// Header
			HStack(spacing: 20) {
				Text("나의 할 일")
				Text("( \(items.count(where: { $0.isDone == true })) / \(items.count) )")
					.font(.title)
					.fontWeight(.light)
			} //:HSTACK
			.font(.largeTitle)
			.fontWeight(.semibold)
			
			Divider()
			
			// Contents
			ScrollViewReader { proxy in
				ScrollView {
					LazyVStack(spacing: 10) {
						ForEach($items, id: \.id) { todoItem in
							TodoRowView(todo: todoItem)
								.id(todoItem.id)
						} //:LOOP
					} //:VSTACK
					.onChange(of: items.count, { numberOfOldItems, numberOfNewItems in
						if let id = items.last?.id,
						   numberOfOldItems < numberOfNewItems {
							proxy.scrollTo(id, anchor: .bottom)
						}
					})
				} //:SCROLL
			}
			
			Divider()
			
			// Footer
			TodoInputView { newTodoString in
				if newTodoString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
					let item = TodoItem(title: newTodoString)
					items.append(item)
				}
			}
			
			Divider()
			
			Button {
				// Action
				items.removeAll(where: { $0.isDone == true })
			} label: {
				Text("완료된 항목 지우기")
					.font(.title3)
					.fontWeight(.semibold)
					.foregroundStyle(.white)
					.frame(height: 35)
					.frame(maxWidth: .infinity)
					.background(Color.blue.opacity(0.8))
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.padding(.bottom, 20)
			}
			
		} //:VSTACK
		.padding(20)
		
    }
}

#Preview {
    TodoMainView()
}
