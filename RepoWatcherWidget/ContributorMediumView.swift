//
//  ContributorMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Matias Martinelli on 28/12/2023.
//

import SwiftUI
import WidgetKit

struct ContributorMediumView: View {
    var body: some View {
        VStack{
            HStack{
                Text("Top Contributors")
                    .font(.caption).bold()
                    .foregroundStyle(.secondary)
                Spacer()
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), alignment: .leading, spacing: 20) {
                ForEach(0..<4) { i in
                    HStack{
                        Image(uiImage: UIImage(named: "avatar")!)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                        VStack(alignment: .leading){
                            Text("Sean Allen")
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                            Text("44")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContributorMediumView()
}
