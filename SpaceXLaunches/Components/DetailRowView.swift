//
//  DetailRowView.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 01.08.2023.
//

import SwiftUI

enum DisplayType {
    case info(title: String, text: String)
    case crew(crew: [Crew])
}

struct DetailRowView: View {
    
    var displayType: DisplayType
    
    var body: some View {
        switch displayType {
        case .info(let title, let text):
            Divider()
                .padding(.vertical, 2)
            
            HStack {
                Group {
                    Image(systemName: "info.circle")
                    Text(title)
                }
                .foregroundColor(.accentColor)
                
                Spacer(minLength: 25)
                
                Text(text)
                    .multilineTextAlignment(.trailing)
            }
            
        case .crew(let crew):
            if !crew.isEmpty {
                Divider()
                    .padding(.vertical, 2)
                
                HStack(alignment: .top) {
                    Group {
                        Image(systemName: "info.circle")
                        Text("Crew")
                    }
                    .foregroundColor(.accentColor)
                    
                    Spacer(minLength: 25)
                    
                    VStack(alignment: .trailing) {
                        ForEach(crew, id: \.crew) { member in
                            Text(member.role ?? "")
                        }
                    }
                }
            }
        }
    }
}

struct DetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        DetailRowView(displayType: .info(title: "Rocket", text: "94"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
