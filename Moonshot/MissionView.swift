//
//  MissionView.swift
//  Moonshot
//
//  Created by slava bily on 23/3/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

struct MissionView: View {
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    let astronauts: [CrewMember]
    
    let mission: Mission
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: {
                $0.id == member.name
            }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
                
            } else {
                fatalError("Missing \(member)")
            }
        }
        self.astronauts = matches
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)
                        .accessibility(removeTraits: .isImage)
                        .accessibility(label: Text("\(self.mission.displayName) label"))
                    
                    // mission date code
                    Text(self.mission.formattedLaunchDate)
                        .padding()
                        .font(.headline)
                        .foregroundColor(.blue)
                        .accessibility(label: Text("Mission date \(self.mission.formattedLaunchDate)"))
                    
                    Text(self.mission.description)
                        .padding()
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut, missions: self.missions)) {
                            HStack {
                                if self.isCommander(crewMember) {
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .frame(width: 120, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.secondary, lineWidth: 2))
                                } else {
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .frame(width: 83, height: 60)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.secondary, lineWidth: 2))
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibility(removeTraits: .isButton)
                        .accessibility(hint: Text("Double click to open personal description"))
                    }
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    func isCommander(_ crewMember: CrewMember) -> Bool {
        
        if crewMember.role.hasPrefix("Command") {
            return true
        } else {
            return false
        }
    }
}



struct MissionView_Previews: PreviewProvider {
    
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[1], astronauts: astronauts)
    }
}
