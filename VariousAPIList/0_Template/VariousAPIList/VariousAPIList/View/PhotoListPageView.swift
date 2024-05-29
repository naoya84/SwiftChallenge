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
    
    var body: some View {
        Text("PhotoListPageView!")
        List {
            ForEach(photoList, id: \.self) { photo in
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
        let apiClient = APIClientImpl(
            defaultBaseURL: URL(string: "https://jsonplaceholder.typicode.com")!
        )
                
        func getPhotoList() async -> [Photo] {
            let request = GetPhotosRequest(parameters: ["albumId" : "1"])
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
    PhotoListPageView(viewModel: .init())
}
