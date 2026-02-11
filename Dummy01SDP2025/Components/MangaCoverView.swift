//
//  MangaCoverView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 22/1/26.
//

import SwiftUI

struct MangaCoverView: View {
    let urlString: String
    var standarHeight:CGFloat
    @State private var vm = CoverVM()
    
    init(urlString: String, standarHeight: CGFloat = 240) {
        self.urlString = urlString
        self.standarHeight = standarHeight
    }
    
    var body: some View {
        Group {
            
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: standarHeight)
                    .clipShape(Rectangle())
            } else {
                placeholder
            }
            
        }
        .onAppear {
            vm.getImage(cover: URL(string: .getStringMainPicture(mainPicture: urlString)))
        }
    }
    
    private var placeholder: some View {
        Image(systemName: "apple.books.pages.fill")
            .font(.largeTitle)
            .frame(width: 90, height: 140)
            //.clipShape(.circle)
            .background(.gray.opacity(0.3), in: .rect(cornerRadius: 11))
            //.background(.red.opacity(0.1), in: .circle)
    }
}

#Preview {
    MangaCoverView(urlString: "")
}
