# PianoRoll
Touch oriented piano roll for iOS and macOS

![piano-roll-demo](https://user-images.githubusercontent.com/13122/188531653-d8abebeb-9ca6-4e00-ac5e-07e45a380acd.png)

## Documentation

Documentation appears [here](https://swiftpackageindex.com/AudioKit/PianoRoll/main/documentation/pianoroll).

You can also build documentation by choosing "Build Documentation" under the "Product" Menu in Xcode.

## Demos

The `Demo` directory contains project demos for iOS and macOS.

The `PianoRoll.playground` file is quick way to test the piano roll within Xcode.

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
