//
//  Photo.swift
//  VariousAPIList
//
//  Created by Kentaro Terasaki on 2024/05/08.
//

import Foundation

struct Photo: Codable, Identifiable {
    var albumId: Int64
    var id: Int64
    var title: String
    var url: URL
    var thumbnailUrl: URL
    
    static func make()->[Photo]{
        return [
            Photo(
                albumId: 1,
                id: 1,
                title: "sample photo1",
                url: URL(string: "https://placehold.jp/3697c7/ffffff/200x200.png?text=dummy")!,
                thumbnailUrl: URL(string: "https://placehold.jp/3697c7/ffffff/200x200.png?text=dummy1")!
            ),
            Photo(
                albumId: 1,
                id: 2,
                title: "sample photo2",
                url: URL(string: "https://placehold.jp/326622/ffffff/200x200.png?text=dummy")!,
                thumbnailUrl: URL(string: "https://placehold.jp/326622/ffffff/200x200.png?text=dummy2")!
            )
        ]
    }
}
