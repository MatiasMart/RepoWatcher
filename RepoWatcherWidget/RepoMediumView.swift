//
//  RepoMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Matias Martinelli on 24/12/2023.
//

import SwiftUI
import WidgetKit


struct RepoMediumView: View {
    let repo: Repository
    let formatter = ISO8601DateFormatter() //This formatter let us work with string dates
    var daysSinceLastActivity: Int {
        calculateDatSinceLastActivity(from: repo.pushedAt)
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                HStack{
                    Image(uiImage: UIImage(data: repo.avatarData) ?? UIImage(named: "avatar")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text(repo.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                }
                .padding(.bottom, 6)
                
                HStack{
                    StartLabel(value: repo.watchers, systemImageName: "star.fill")
                    StartLabel(value: repo.forks, systemImageName: "tuningfork")
                    if repo.hasIssues {
                        StartLabel(value: repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                    }
                    
                }
                .padding(.leading, 8)
            }
            
            Spacer()
            
            VStack{
                Text("\(daysSinceLastActivity)")
                    .bold()
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundStyle(daysSinceLastActivity > 50 ? .pink : .green)
                
                Text("Days ago")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
        }
        
    }
    
    //Function to calculate how many day past since the last update
    func calculateDatSinceLastActivity(from dateString: String) -> Int {
        let lastActivityDate = formatter.date(from: dateString) ?? .now
        //calcutaion of days since last Activity to now
        let daySinceLastActity = Calendar.current.dateComponents([.day], from: lastActivityDate, to: .now).day ?? 0
        return daySinceLastActity
    }
}

#Preview {
    RepoMediumView(repo: Repository.placeholder)
}

fileprivate struct StartLabel: View {
    
    let value: Int
    let systemImageName: String
    
    var body: some View {
        Label{
            Text("\(value)")
                .font(.footnote)
        } icon: {
            Image(systemName: systemImageName)
                .foregroundStyle(.green)
        }
        .fontWeight(.medium)
    }
}

