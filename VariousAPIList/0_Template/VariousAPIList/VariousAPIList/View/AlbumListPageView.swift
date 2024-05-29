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
        
    var body: some View {
        Text("AlbumListPageView!")
        List {
            ForEach(albumList, id: \.self) { album in
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
        
        let apiClient = APIClientImpl(
            defaultBaseURL: URL(string: "https://jsonplaceholder.typicode.com")!
        )
        
        func getAlbumList() async -> [Album] {
            let request = GetAlbumsRequest()
            
            return await withCheckedContinuation { continuation in
                apiClient.executeWithCompletion(request) { response, error in
                    if let response = response {
                        continuation.resume(returning: response)
                    } else if let error {
                        print(error)
                        continuation.resume(returning: [])
                    }
                }
            }
        }
    }
}

#Preview {
    AlbumListPageView(viewModel: .init())
}
