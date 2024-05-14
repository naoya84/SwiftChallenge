import Nimble
import SwiftUI
import ViewInspector
import XCTest

@testable import VariousAPIList

final class AlbumListPageViewTests: XCTestCase {
    func test_sampleで用意したalubumListの内容がtextで表示される() throws {
        //Given
        let view = AlbumListPageView()
        
        //When
        let userIdText1 = try view.inspect().find(text: "userId: 1")
        let idText1 = try view.inspect().find(text: "id: 1")
        let titleText1 = try view.inspect().find(text: "title: dummy1")
        let userIdText2 = try view.inspect().find(text: "userId: 1")
        let idText2 = try view.inspect().find(text: "id: 2")
        let titleText2 = try view.inspect().find(text: "title: dummy2")
        
        //Then
        expect(userIdText1).toNot(beNil())
        expect(idText1).toNot(beNil())
        expect(titleText1).toNot(beNil())
        expect(userIdText2).toNot(beNil())
        expect(idText2).toNot(beNil())
        expect(titleText2).toNot(beNil())
    }
}
