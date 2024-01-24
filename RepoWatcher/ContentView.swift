//
//  RepoWatcherAppUI.swift
//
//
//  Created by Sean Allen on 9/18/22.
//

import SwiftUI

struct ContentView: View {
    @State private var newRepo = ""
    @State private var repos: [String] = []
    @State private var showingAlert = false


    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Ex. sallen0400/swift-news", text: $newRepo)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    Button {
                        if !repos.contains(newRepo) && !newRepo.isEmpty {
                            repos.append(newRepo)
                            UserDefaults.standard.set(repos, forKey: "repos")
                            newRepo = ""
                        }else {
                            showingAlert = true
                        }
                        
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                    }
                    .alert("Something went wrong", isPresented: $showingAlert) {
                        Button("OK") { }
                    }

                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Saved Repos")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.leading)

                    List(repos, id: \.self) { repo in
                        Text(repo)
                            .swipeActions {
                                Button("Delete") {
                                    if repos.count > 1 {
                                        repos.removeAll { $0 == repo }
                                        UserDefaults.standard.setValue(repos, forKey: "repos")
                                    }
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle("Repo List")
            .onAppear{
                guard let retrievedRepos = UserDefaults.standard.value(forKey: "repos") as? [String] else {
                    let defaultValue = ["sallen0400/swift-news"]
                    UserDefaults.standard.setValue(defaultValue, forKey: "repos")
                    repos = defaultValue
                    return
                }
                
                repos = retrievedRepos
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

