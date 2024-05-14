//
//  PhotoListPageView.swift
//  VariousAPIList
//
//  Created by Kentaro Terasaki on 2024/05/09.
//

// 参考URL https://terminus.wdkk.co.jp/shige-fuji/swiftui/3-4-1/

import SwiftUI

struct PhotoListPageView: View {
    @StateObject var viewModel: ViewModel
    @State var photoList: [Photo] = []
//    let photoList: [Photo] = Photo.make()
    
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
        .onAppear {
            Task {
                photoList = await viewModel.getPhotoList()
            }
        }
    }
}

extension PhotoListPageView {
    class ViewModel: ObservableObject {
        func getPhotoList() async -> [Photo] {
            let requestUrl = URL(string: "https://jsonplaceholder.typicode.com/photos?albumId=1")!
            let request = URLRequest(url: requestUrl)
            let result = try! await URLSession.shared.data(for: request)
            // .decodeメソッドには、型名とデコードするData型を指定。
            let json = try! JSONDecoder().decode([Photo].self, from: result.0)

            return json
        }
    }
}

#Preview {
    PhotoListPageView(viewModel: .init())
}
