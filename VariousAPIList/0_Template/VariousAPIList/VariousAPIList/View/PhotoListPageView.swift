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
        let apiClient = APIClientImpl()
        
        func getPhotoList() async -> [Photo] {
            let request = GetPhotosRequest()
            var result: [Photo] = []
            
            do {
                result = try await apiClient.executeWithCompletion(request) { response, error in
                    if let response = response {
//                        print(response)
                    } else if let error {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
            return result
        }
    }
}

#Preview {
    PhotoListPageView(viewModel: .init())
}
