import Foundation
import Models
import Services
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var stories: [Story] = []
    @Published var selectedStoryIndex: Int = 0
    @Published var isPresented: Bool = false
    @Published var isLoadingMore: Bool = false
    
    private let storiesManager: StoriesManager
    private let userService: UserService
    
    init(storiesManager: StoriesManager, userService: UserService) {
        self.storiesManager = storiesManager
        self.userService = userService
    }
    
    var currentUserID: UUID {
        userService.getCurrentUserId()
    }
    
    func loadStories() async {
        do {
            self.stories = try await storiesManager.loadPersistedStories()
        } catch {
            print("Failed to load stories: \(error)")
        }
    }
    
    func loadMoreStories() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        do {
            let newStories = try await storiesManager.getNewStories()
            stories.append(contentsOf: newStories)
        } catch {
            print("Failed to load more stories: \(error)")
        }
        isLoadingMore = false
    }
    
    func persistStories() async {
        do {
            try await storiesManager.persistStories(stories)
        } catch {
            print("Failed to persist stories: \(error)")
        }
    }
    
    func selectStory(at index: Int) {
        selectedStoryIndex = index
        withAnimation {
            isPresented = true
        }
    }
}
