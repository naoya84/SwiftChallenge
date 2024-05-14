//
//  PhotoListPageView.swift
//  VariousAPIList
//
//  Created by Kentaro Terasaki on 2024/05/09.
//

import SwiftUI

struct PhotoListPageView: View {
    let photoList: [Photo] = Photo.make()
    
    var body: some View {
        Text("PhotoListPageView!")
        List(photoList) {photo in
            VStack{
                AsyncImage(url: photo.thumbnailUrl)
                Text("id: \(photo.id)")
                Text("albumId: \(photo.albumId)")
                Text("title: \(photo.title)")
            }
        }
    }
}

#Preview {
    PhotoListPageView()
}
