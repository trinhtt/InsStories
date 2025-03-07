//
//  InsStoriesApp.swift
//  InsStories
//
//  Created by Thanh on 07/03/2025.
//

import Features
import Services
import SwiftUI

@main
struct InsStoriesApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(
                storiesManager: MockStoriesManager(),
                userService: MockUserService()
            )
        }
    }
}
