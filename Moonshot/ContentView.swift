//
//  ContentView.swift
//  Moonshot
//
//  Created by slava bily on 21/3/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingLaunchDate = false
 
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                            .accessibility(label: Text("Mission \(mission.displayName). \(self.showingLaunchDate ? " Launch date " : " Crew members" )"))
                        HStack {
                            if self.showingLaunchDate {
                                Text(mission.formattedLaunchDate)
                            } else {
                                ForEach(self.crewNames(mission), id: \.self) {
                                    Text("\($0)")
                                }
                            }
                        }
                    }
                }
                .accessibility(removeTraits: .isButton)
                .accessibility(hint: Text("Double tap to open mission description"))
            }
            .navigationBarTitle("Moonshot", displayMode: .automatic)
            .navigationBarItems(trailing: Button(action: {
                self.showingLaunchDate.toggle()
            }, label: {
                if showingLaunchDate {
                    Text("Crew")
                } else {
                    Text("Launch Date")
                }
            }))
        }
    }
    
    func crewNames(_ mission: Mission) -> [String] {
        var crewNames = [String]()
        for crewMember in mission.crew {
            crewNames.append(crewMember.name)
        }
        return crewNames
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
