// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKitUI/

import SwiftUI

/// Individual note displayed on the PianoRoll
public struct PianoRollNote: Equatable, Identifiable {
    public init(start: Double, length: Double, pitch: Int) {
        self.start = start
        self.length = length
        self.pitch = pitch
    }

    /// Unique Identifier
    public var id = UUID()

    /// The start step.
    var start: Double

    /// How many steps long?
    var length: Double

    /// Abstract pitch, not MIDI notes.
    var pitch: Int

}
