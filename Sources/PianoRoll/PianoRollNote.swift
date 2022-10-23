// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

/// Individual note displayed on the PianoRoll
public struct PianoRollNote: Equatable, Identifiable {
    /// Initialize the PianoRollNote with start time, duration, and pitch
    /// - Parameters:
    ///   - start: The start step
    ///   - length: Duration, measured in steps
    ///   - pitch: Abstract pitch, not MIDI notes.
    ///   - text: Optional text shown on the note view.
    public init(start: Double, length: Double, pitch: Int, text: String? = nil) {
        self.start = start
        self.length = length
        self.pitch = pitch
        self.text = text
    }

    /// Unique Identifier
    public var id = UUID()

    /// The start step
    var start: Double

    /// Duration, measured in steps
    var length: Double

    /// Abstract pitch, not MIDI notes.
    var pitch: Int

    /// Optional text shown on the note view
    var text: String?
}
