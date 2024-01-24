//
//  TabPagesModel.swift
//  DynamicTabPages
//
//  Created by Adrien Surugue on 01/04/2023.
//

import Foundation


struct TabPagesModel: Identifiable, Hashable{
    var id = UUID().uuidString
    var name: String
    var icon: String
    var minX  = 0.0
    var width = 0.0
}

var tabPages: [TabPagesModel] = [.init(name: "Principal", icon: "circle.grid.2x2"),
                                .init(name: "Catégories", icon: "folder"),
                                .init(name: "Favoris", icon: "heart.fill"),
                                .init(name: "Ventes", icon: "doc.plaintext.fill"),
                                .init(name: "Principal", icon: "circle.grid.2x2"),
]
