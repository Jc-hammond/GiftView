//
//  SearchBar.swift
//  GiftView
//
//  Created by Connor Hammond on 10/19/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.buttonBlue)
                .frame(height: 55)
                
            
            if text.isEmpty {
                HStack {
                    Text("Search")
                        .fontDesign(.rounded)
                        .foregroundStyle(.accentBlue)
                        .padding(.leading, 45)
                    Spacer()
                }
            }
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.accentBlue)
                    .padding(.leading, 15)
                TextField("", text: $text)
                    .frame(height: 45)
                    .fontDesign(.rounded)
                    .foregroundColor(.accentBlue)
                    .submitLabel(.search)
                    .tint(.searchBackground)
                    .autocorrectionDisabled()
                Spacer()
            }
        }
        
        .padding(.horizontal, 20)
    }
}

