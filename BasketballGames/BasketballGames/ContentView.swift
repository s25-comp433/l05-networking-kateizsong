//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var games: [Game]
}

struct Game: Codable {
    var isHomeGame: Bool
    var date: String
    var score: Score
    var team: String
    var opponent: String
    var id: Int
    
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var games = [Game]()
    
    var body: some View {
        NavigationStack {
            List(games, id: \.id) { game in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(game.team) vs \(game.opponent)")
                        Text("\(game.date)")
                            .font(.caption)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(game.score.unc) - \(game.score.opponent)")
                        Text(game.isHomeGame ? "Home": "Away")
                    }
                }
            }
            
            .navigationTitle("UNC Basketball")
            .task {
                await loadData()
            }
            
            
        }
    }
        
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data) {
                games = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
