import Models
import SwiftUI

public struct StoryView: View {
    @Binding var stories: [Story]
    @Binding var selectedStoryIndex: Int
    @Binding var isPresented: Bool
    
    let currentUserID: UUID
    
    let onStoriesChange: () -> Void
    
    @State private var currentIndex = 0
    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    @State private var likeButtonScale: CGFloat = 1.0
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                let currentStory = stories[selectedStoryIndex]
                let currentImage = currentStory.images[currentIndex]
                
                AsyncImage(url: currentImage.imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .offset(y: offset)
                            .gesture(
                                DragGesture(minimumDistance: 10)
                                    .onChanged { value in
                                        isDragging = true
                                        offset = max(value.translation.height, 0)
                                    }
                                    .onEnded { value in
                                        if value.translation.height > 300 {
                                            withAnimation {
                                                isPresented = false
                                            }
                                        } else {
                                            withAnimation {
                                                offset = 0
                                            }
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            isDragging = false
                                        }
                                    }
                            )
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onEnded { value in
                                        if !isDragging {
                                            let tapLocation = value.location
                                            handleTap(location: tapLocation, width: geometry.size.width)
                                        }
                                    }
                            )
                    } else if phase.error != nil {
                        Color.red
                    } else {
                        ProgressView()
                    }
                }
                
                gradientView
                
                VStack {
                    HStack {
                        AsyncImage(url: currentStory.userIcon)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        
                        Text(currentStory.username)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                isPresented = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 6) {
                        ForEach(0..<currentStory.images.count, id: \.self) { index in
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(index == currentIndex ? .white : .gray)
                        }
                    }
                    .padding(.top, 8)
                    Spacer()
                }
                
                likeView
            }
            .opacity(isPresented ? 1.0 : 0.0)
            .animation(.easeIn(duration: 0.3), value: isPresented)
            .task {
                await runTimer()
            }
        }
    }
    
    @ViewBuilder
    var likeView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        toggleLike(storyIndex: selectedStoryIndex, imageIndex: currentIndex)
                        likeButtonScale = 1.5
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.easeOut(duration: 0.15)) {
                            likeButtonScale = 1.0
                        }
                    }
                } label: {
                    Image(systemName: isImageLiked(storyIndex: selectedStoryIndex, imageIndex: currentIndex) ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(isImageLiked(storyIndex: selectedStoryIndex, imageIndex: currentIndex) ? .red : .white)
                        .scaleEffect(likeButtonScale)
                }
                .padding()
            }
            .padding(.bottom, 30)
            .padding(.trailing, 20)
        }
    }

    
    @ViewBuilder
    var gradientView: some View {
        VStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.9), Color.clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
            Spacer()
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.9)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
        }
        .ignoresSafeArea()
    }
}

extension StoryView {
    private func handleTap(location: CGPoint, width: CGFloat) {
        if offset == 0 {
            if location.x < width / 2 {
                previousImage()
            } else {
                nextImageOrStory()
            }
        }
    }
    
    private func previousImage() {
        if currentIndex > 0 {
            currentIndex -= 1
        } else if selectedStoryIndex > 0 {
            selectedStoryIndex -= 1
            currentIndex = stories[selectedStoryIndex].images.count - 1
        }
    }
    
    private func nextImageOrStory() {
        if currentIndex < stories[selectedStoryIndex].images.count - 1 {
            currentIndex += 1
        } else if selectedStoryIndex < stories.count - 1 {
            selectedStoryIndex += 1
            currentIndex = 0
        } else {
            withAnimation {
                isPresented = false
            }
        }
    }
    
    private func toggleLike(storyIndex: Int, imageIndex: Int) {
        var newStories = stories
        var updatedStory = newStories[storyIndex]
        var updatedImages = updatedStory.images
        var updatedImage = updatedImages[imageIndex]
        if let i = updatedImage.likedByUsers.firstIndex(of: currentUserID) {
            updatedImage.likedByUsers.remove(at: i)
        } else {
            updatedImage.likedByUsers.append(currentUserID)
        }
        updatedImages[imageIndex] = updatedImage
        updatedStory.images = updatedImages
        newStories[storyIndex] = updatedStory
        stories = newStories
        // persist changes
        onStoriesChange()
    }
    
    private func isImageLiked(storyIndex: Int, imageIndex: Int) -> Bool {
        return stories[storyIndex].images[imageIndex].likedByUsers.contains(currentUserID)
    }
    
    private func runTimer() async {
        for await _ in Timer.publish(every: 5, on: .main, in: .default).autoconnect().values {
            nextImageOrStory()
        }
    }
}
