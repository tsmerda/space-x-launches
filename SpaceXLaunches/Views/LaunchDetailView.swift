//
//  LaunchDetailView.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 01.08.2023.
//

import SwiftUI
import SDWebImage

struct LaunchDetailView: View {
    let launch: Launch?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text((launch?.name ?? "Name").uppercased())
                        .font(.system(size: 20).weight(.bold))
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Text(((launch?.success ?? false) ? "Success" : "Failure").uppercased())
                        .font(.system(size: 14).bold())
                        .foregroundColor((launch?.success ?? false) ? .green : .red)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.secondary.opacity(0.1))
                        .cornerRadius(24)
                }
                
                Text("\(dateFromString(launch?.dateUtc ?? ""))")
                    .font(.system(size: 14).bold())
                                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(launch?.links?.flickr?.original ?? [], id: \.self) { item in
                            AsyncImage(url: URL(string: item)){ image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(8)
                            } placeholder: { Color.gray }
                                .frame(width: 150, height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding(.top)
                
                GroupBox() {
                    DisclosureGroup("Detailed information") {
                        DetailRowView(displayType: .info(title: "Rocket", text: launch?.rocket ?? ""))
                        
                        DetailRowView(displayType: .info(title: "Flight number", text: "\(launch?.flightNumber ?? 0)"))
                        
                        if let crew = launch?.crew, !crew.isEmpty {
                            DetailRowView(displayType: .crew(crew: launch?.crew ?? []))
                        }
                    }
                }
                .font(.system(size: 15, weight: .semibold))
                .padding(.vertical)
                
                Text(launch?.details ?? "No detailed description")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                
            }
            .padding()
        }
    }
    
    private func dateFromString(_ dateString: String) -> String {
        if let date = DateFormatter.launchDateFormatter.date(from: dateString) {
            return DateFormatter.displayDateFormatter.string(from: date)
        } else {
            return ""
        }
    }
}

struct LaunchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchDetailView(launch: Launch.example)
    }
}
