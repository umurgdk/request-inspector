//
//  Squad.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import Foundation

struct Squad: Codable {
    let squadName: String
    let homeTown: String
    let formed: Int
    let active: Bool
    let members: [Member]
    
    struct Member: Codable {
        let name: String
        let age: Int
        let secretIdentity: String
        let powers: [String]
    }
}

extension Squad.Member: Inspectable {
    var inspectableTree: InspectableTree {
        InspectableTree(name: "Member", children: [
            "name": .string(name),
            "age": .number(Float(age)),
            "secretIdentity": .string(secretIdentity),
            "powers": .array(InspectableArray(children: powers.map { InspectableValue(.string($0)) }))
        ])
    }
}

extension Squad: Inspectable {
    var inspectableTree: InspectableTree {
        InspectableTree(name: "Squad", children: [
            "squadName": .string(squadName),
            "homeTown": .string(homeTown),
            "formed": .number(Float(formed)),
            "active": .bool(active),
            "members": .array(InspectableArray(children: members.map { InspectableValue(.object($0.inspectableTree)) }))
        ])
    }
}

extension Squad {
    static var sample: Squad {
        Squad(squadName: "Super hero squad",
              homeTown: "Metro City",
              formed: 2016,
              active: true,
              members: [
                .init(name: "Molecule Man",
                      age: 29,
                      secretIdentity: "Dan Jukes",
                      powers: ["Radiation resistance", "Turning tiny", "Radiation blast"]),
                
                .init(name: "Madame Uppercut",
                      age: 39,
                      secretIdentity: "Jane Wilson",
                      powers: ["Million tonne punch", "Damage resistance", "Superhuman reflexes"]),
                
                .init(name: "Eternal Flame",
                      age: 1000000,
                      secretIdentity: "Unknown",
                      powers: ["Immortality", "Heat Immunity", "Inferno", "Teleportation", "Interdimensional travel"])
              ])
    }
}
