# PianoRoll
Touch oriented piano roll for iOS and macOS

<img src="Sources/PianoRoll/PianoRoll.docc/Resources/screenshot.png" alt="piano roll screenshot" style="width:75%;">

## Usage

```Swift
import SwiftUI
import PianoRoll

public struct PianoRollDemoView: View {

    public init() { }

    @State var model = PianoRollModel(notes: [
        PianoRollNote(start: 1, length: 2, pitch: 3),
        PianoRollNote(start: 5, length: 1, pitch: 4)
    ], length: 128, height: 128)

    public var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            PianoRoll(model: $model, noteColor: .cyan)
        }.background(Color(white: 0.1))
    }
}
```