//
//  RatingView.swift
//  TrantorBooks
//
//  Created by Julio César Fernández Muñoz on 26/11/25.
//

import SwiftUI

struct RatingView: View {
    let rating: Double
    let originalRating: Double
    let starSize = Font.title2
    
    private var originalRoundedRating: Double {
        (originalRating * 100).rounded() / 100
    }
    
    private var roundedRating: Double {
        (rating * 100).rounded() / 100
    }
    
    private var fullStars: Int {
        Int(roundedRating)
    }
    
    private var partialStar: Double {
        roundedRating - Double(fullStars)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            // Estrellas completas
            ForEach(0..<fullStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .font(starSize)
            }
            
            // Estrella parcial si hay
            if partialStar > 0 {
                ZStack(alignment: .leading) {
                    // Estrella gris de fondo
                    Image(systemName: "star.fill")
                        .foregroundStyle(.gray.opacity(0.5))
                        .font(starSize)
                    
                    // Estrella amarilla recortada
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(starSize)
                        .mask(alignment: .leading) {
                            GeometryReader { geometry in
                                Rectangle()
                                    .frame(width: geometry.size.width * partialStar)
                            }
                        }
                }
                .fixedSize()
            }            
            /*
            // Estrellas vacías para completar 5
            let emptyStars = 5 - fullStars - (partialStar > 0 ? 1 : 0) < 0 ? 0 : 5 - fullStars - (partialStar > 0 ? 1 : 0)
            
            if emptyStars < 0 {
                ForEach(0..<emptyStars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundStyle(.gray.opacity(0.3))
                }
            } else {
                ForEach(0..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundStyle(.gray.opacity(0.3))
                }
            }*/
            
            // Estrellas vacías para completar 5
            let emptyStars = 5 - fullStars - (partialStar > 0 ? 1 : 0)
            
            if emptyStars >= 0 {
                ForEach(0..<emptyStars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundStyle(.gray.opacity(0.5))
                        .font(starSize)
                }
            } else {
                ForEach(0..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundStyle(.gray.opacity(0.5))
                        .font(starSize)
                }
            }
                
            
            Text(originalRoundedRating.formatted(.number.precision(.fractionLength(2))))
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 10)
        }
        .font(.headline)
    }
}

#Preview {
    VStack(spacing: 20) {
        RatingView(rating: 0.0, originalRating: 5.25)
        RatingView(rating: 1.25, originalRating: 5.25)
        RatingView(rating: 2.5, originalRating: 5.25)
        RatingView(rating: 3.75, originalRating: 5.25)
        RatingView(rating: 4.0, originalRating: 5.25)
        RatingView(rating: 4.75, originalRating: 5.25)
        RatingView(rating: 5.0, originalRating: 5.25)
    }
    .padding()
}
