# ``PianoRoll``

Touch-oriented piano roll.

## Overview

Code is hosted on Github: [](https://github.com/AudioKit/PianoRoll/)

![Screenshot](screenshot)

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

Use `rowBackgroundColor` to shade pitch rows, such as black keys and octave roots when pitch 1 is C:

```swift
PianoRoll(
    model: $model,
    noteColor: .cyan,
    rowBackgroundColor: { pitch in
        let pitchClass = (pitch - 1) % 12
        if [1, 3, 6, 8, 10].contains(pitchClass) {
            return .black.opacity(0.22)
        }
        if pitchClass == 0 {
            return .white.opacity(0.12)
        }
        return nil
    }
)
```

Note: Requires macOS 12 / iOS 15 due to SwiftUI bug (crashes in SwiftUI when deleting notes). 
