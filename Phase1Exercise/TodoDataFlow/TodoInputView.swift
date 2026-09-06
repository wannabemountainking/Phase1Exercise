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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
	TodoInputView(onAdd: {_ in })
}
