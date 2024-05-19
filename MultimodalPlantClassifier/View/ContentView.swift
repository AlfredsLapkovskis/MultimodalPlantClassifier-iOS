//
//  ContentView.swift
//  MultimodalPlantClassifier
//
//  Created by Alfred Lapkovsky on 06/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection: Tab = .classify
    
    private enum Tab {
        case classify
        case history
        
        var title: String {
            switch self {
            case .classify:
                "Classify"
            case .history:
                "History"
            }
        }
        
        var icon: String {
            switch self {
            case .classify:
                "eye"
            case .history:
                "list.star"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ClassificationView()
                .tabItem {
                    Label(Tab.classify.title, systemImage: Tab.classify.icon)
                }
                .tag(Tab.classify)
            HistoryView()
                .tabItem {
                    Label(Tab.history.title, systemImage: Tab.history.icon)
                }
                .tag(Tab.history)
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
