//
//  Home.swift
//  Bckg
//
//  Created by Jesus Antonio Gil on 31/1/25.
//

import SwiftUI


struct GradientCarousel: View {
    @State private var topInset: CGFloat = 0
    @State private var scrollOffsetY: CGFloat = 0
    @State private var scrollProgressX: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                HeaderView()
                
                CarouselView()
                    .zIndex(-1)
            }
        }
        .safeAreaPadding(15)
        .background {
            Rectangle()
                .fill(.black.gradient)
                .scaleEffect(y: -1)
                .ignoresSafeArea()
        }
        .onScrollGeometryChange(for: ScrollGeometry.self) {
            $0
        } action: { oldValue, newValue in
            topInset = newValue.contentInsets.top + 100
            scrollOffsetY = newValue.contentOffset.y + newValue.contentInsets.top
        }
        .preferredColorScheme(.dark)
    }
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Image(systemName: "xbox.logo")
                .font(.system(size: 35))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("iJustine")
                    .font(.callout)
                    .fontWeight(.semibold)
                
                HStack(spacing: 6) {
                    Image(systemName: "g.circle.fill")
                    
                    Text("36,990")
                        .font(.caption)
                }
            }
            
            Spacer(minLength: 0)
            
            Image(systemName: "square.and.arrow.up.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white, .fill)
            
            Image(systemName: "bell.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white, .fill)
        }
        .padding(.bottom, 15)
    }
    
    
    @ViewBuilder
    func CarouselView() -> some View {
        let spacing: CGFloat = 10
        
        ScrollView(.horizontal) {
            LazyHStack(spacing: spacing) {
                ForEach(images) { model in
                    Image(model.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .containerRelativeFrame(.horizontal)
                        .frame(height: 380)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(color:.black.opacity(0.4), radius: 5, x: 5, y: 5)
                }
            }
            .scrollTargetLayout()
        }
        .frame(height: 380)
        .background(BackdropCarousel())
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .onScrollGeometryChange(for: CGFloat.self) {
            let offsetX = $0.contentOffset.x + $0.contentInsets.leading
            let width = $0.contentSize.width + spacing
            return offsetX / width
        } action: { oldValue, newValue in
            let maxValue = CGFloat(images.count - 1)
            scrollProgressX = min(max(newValue, 0), maxValue)
        }
    }
    
    
    @ViewBuilder
    func BackdropCarousel() -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach(images.reversed()) { model in
                    let index = CGFloat(images.firstIndex(where: {$0.id == model.id}) ?? 0) + 1
                    
                    Image(model.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .opacity(index - scrollProgressX)
                }
            }
            .compositingGroup()
            .blur(radius: 30, opaque: true)
            .overlay {
                Rectangle()
                    .fill(.black.opacity(0.35))
            }
            .mask {
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .black,
                        .black,
                        .black,
                        .black,
                        .black.opacity(0.5),
                        .clear
                    ], startPoint: .top, endPoint: .bottom))
            }
        }
        .containerRelativeFrame(.horizontal)
        .padding(.bottom, -60)
        .padding(.top, -topInset)
        .offset(y: scrollOffsetY < 0 ? scrollOffsetY : 0)
    }
}


#Preview {
    GradientCarousel()
}


