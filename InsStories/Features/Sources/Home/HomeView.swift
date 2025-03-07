import Models
import Services
import SwiftUI

@MainActor
public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    public init(
        storiesManager: StoriesManager,
        userService: UserService
    ) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(storiesManager: storiesManager, userService: userService))
    }
    
    public var body: some View {
        ZStack {
            VStack {
                header
                storyListView
            }
            
            if viewModel.isPresented {
                storyDetailView
            }
        }
        .task {
            await viewModel.loadStories()
        }
    }
    
    @ViewBuilder
    var header: some View {
        Text("Stories")
            .font(.largeTitle)
            .padding()
    }
    
    @ViewBuilder
    var storyListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 20) {
                ForEach(viewModel.stories.indices, id: \.self) { index in
                    let story = viewModel.stories[index]
                    
                    Button {
                        viewModel.selectStory(at: index)
                    } label: {
                        VStack {
                            AsyncImage(url: story.userIcon)
                                .frame(width: 60, height: 60)
                                .background(Color.gray)
                                .clipShape(Circle())
                            
                            Text(story.username)
                                .font(.caption)
                                .tint(.primary)
                                .lineLimit(1)
                        }
                    }
                    .onAppear {
                        if index == viewModel.stories.count - 1 {
                            Task {
                                await viewModel.loadMoreStories()
                            }
                        }
                    }
                }
                
                if viewModel.isLoadingMore {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    var storyDetailView: some View {
        Color.black.opacity(0.3)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation {
                    viewModel.isPresented = false
                }
            }
        
        StoryView(
            stories: $viewModel.stories,
            selectedStoryIndex: $viewModel.selectedStoryIndex,
            isPresented: $viewModel.isPresented,
            currentUserID: viewModel.currentUserID
        ) {
            Task {
                await viewModel.persistStories()
            }
        }
    }
}
