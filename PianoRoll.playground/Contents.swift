import PianoRoll
import PlaygroundSupport
import SwiftUI

struct PianoRollDemoView: View {
    @State var model = PianoRollModel(notes: [
        PianoRollNote(start: 1, length: 2, pitch: 9),
        PianoRollNote(start: 5, length: 1, pitch: 4),
    ], length: 12, height: 12)

    public var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            PianoRoll(model: $model, noteColor: .cyan)
        }.background(Color(white: 0.1))
    }
}

PlaygroundPage.current.setLiveView(PianoRollDemoView().frame(width: 500, height: 500))
PlaygroundPage.current.needsIndefiniteExecution = true
