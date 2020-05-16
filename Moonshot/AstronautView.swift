//
//  AstronautView.swift
//  Moonshot
//
//  Created by slava bily on 24/3/20.
//  Copyright © 2020 slava bily. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    
    let missionsNames: [String]
    
    let astronaut: Astronaut
    
    init(astronaut: Astronaut, missions: [Mission]) {
        self.astronaut = astronaut
        
        var matches = [String]()
        
        for mission in missions {
            for crewMember in mission.crew {
                if crewMember.name == astronaut.id {
                     matches.append(mission.displayName)
                }
            }
        }
        self.missionsNames = matches
        print("\(astronaut.id): \(self.missionsNames)")
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .accessibility(removeTraits: .isImage)
                        .accessibility(label: Text("\(self.astronaut.id)'s image"))
                    
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    Text("Missions:")
                        .padding()
                        .layoutPriority(1)
                        .font(.headline)
                    VStack {
                        ForEach(self.missionsNames, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[7], missions: missions)
    }
}
