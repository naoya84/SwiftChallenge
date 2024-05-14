//
//  AlbumListPageView.swift
//  VariousAPIList
//
//  Created by Kentaro Terasaki on 2024/05/10.
//

import SwiftUI

struct AlbumListPageView: View {
    let albumList: [Album] = Album.make()
    
    var body: some View {
        Text("AlbumListPageView!")
        List(albumList) {album in
            VStack{
                Text("id: \(album.id)")
                Text("userId: \(album.userId)")
                Text("title: \(album.title)")
            }
        }
    }
}

#Preview {
    AlbumListPageView()
}
