// Copyright AudioKit. All Rights Reserved.

@testable import PianoRoll
import XCTest

final class PianoRollTests: XCTestCase {

    func testEquatable() throws {

        let note1 = PianoRollNote(start: 0, length: 3, pitch: 40)
        let note2 = PianoRollNote(start: 1, length: 2, pitch: 43)
        let note3 = PianoRollNote(start: 2, length: 1, pitch: 47)

        let model = PianoRollModel(notes: [note1, note2, note3], length: 3, height: 12)
        let model1 = PianoRollModel(notes: [note1], length: 3, height: 12)
        let model2 = PianoRollModel(notes: [note1, note2], length: 3, height: 12)
        let model3 = PianoRollModel(notes: [note1, note2, note3], length: 3, height: 12)

        XCTAssert(model != model1)
        XCTAssert(model != model2)
        XCTAssert(model == model3)
    }



}
