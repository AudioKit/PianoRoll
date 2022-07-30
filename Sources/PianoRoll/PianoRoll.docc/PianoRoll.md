# ``PianoRoll``

Touch-oriented piano roll.

## Overview

```swift
import SwiftUI
import PianoRoll

struct PianoRollDemoView: View {

    @State var model = PianoRollModel(notes: [
        PianoRollNote(start: 1, length: 2, pitch: 3),
        PianoRollNote(start: 5, length: 1, pitch: 4)
    ], length: 128, height: 128)

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            PianoRoll(model: $model, noteColor: .cyan)
        }.background(Color(white: 0.1))
    }
}
```

![Screenshot](screenshot)

Note: Requires macOS 12 / iOS 15 due to SwiftUI bug (crashes in SwiftUI when deleting notes). 
