//
//  AlbumListPageView.swift
//  VariousAPIList
//
//  Created by Kentaro Terasaki on 2024/05/10.
//

// 参考URL https://terminus.wdkk.co.jp/shige-fuji/swiftui/3-4-1/

import SwiftUI

struct AlbumListPageView: View {
    @StateObject var viewModel: ViewModel
    @State var albumList: [Album] = []
//    let albumList: [Album] = Album.make()

        
    var body: some View {
        Text("AlbumListPageView!")
        List(albumList) {album in
            VStack{
                Text("id: \(album.id)")
                Text("userId: \(album.userId)")
                Text("title: \(album.title)")
            }
        }
        .onAppear {
            Task {
                albumList = await viewModel.getAlbumList()
            }
        }
    }
}

extension AlbumListPageView {
    class ViewModel: ObservableObject {
        func getAlbumList() async -> [Album] {
            let requestUrl = URL(string: "https://jsonplaceholder.typicode.com/albums")!
            let request = URLRequest(url: requestUrl)
            let result = try! await URLSession.shared.data(for: request)
            // .decodeメソッドには、型名とデコードするData型を指定。
            let json = try! JSONDecoder().decode([Album].self, from: result.0)

            return json
        }
    }
}

#Preview {
    AlbumListPageView(viewModel: .init())
}
