import Nimble
import SwiftUI
import ViewInspector
import XCTest

@testable import VariousAPIList

final class PhotoListPageViewTests: XCTestCase {
    func test_sampleで用意したphotoListの内容がtextで表示される() throws {
        //Given
        let view = PhotoListPageView()
        
        //When
        let idText1 = try view.inspect().find(text: "id: 1")
        let albumIdText1 = try view.inspect().find(text: "albumId: 1")
        let titleText1 = try view.inspect().find(text: "title: sample photo1")
        let idText2 = try view.inspect().find(text: "id: 2")
        let albumIdText2 = try view.inspect().find(text: "albumId: 1")
        let titleText2 = try view.inspect().find(text: "title: sample photo2")
        let image = try view.inspect().findAll(ViewType.Image.self)
        
        //Then
        expect(idText1).toNot(beNil())
        expect(albumIdText1).toNot(beNil())
        expect(titleText1).toNot(beNil())
        expect(idText2).toNot(beNil())
        expect(albumIdText2).toNot(beNil())
        expect(titleText2).toNot(beNil())
        expect(image.isEmpty).toNot(beTrue())
    }
}
