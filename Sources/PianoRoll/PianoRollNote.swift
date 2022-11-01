// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

/// Individual note displayed on the PianoRoll
public struct PianoRollNote: Equatable, Identifiable {
    /// Initialize the PianoRollNote with start time, duration, and pitch
    /// - Parameters:
    ///   - color: Individual note color. It will default to `noteColor` in `PianoRoll` if not set.
    ///   - start: The start step
    ///   - length: Duration, measured in steps
    ///   - pitch: Abstract pitch, not MIDI notes.
    ///   - text: Optional text shown on the note view.
    public init(color: Color? = nil, start: Double, length: Double, pitch: Int, text: String? = nil) {
        self.color = color
        self.start = start
        self.length = length
        self.pitch = pitch
        self.text = text
    }

    /// Unique Identifier
    public var id = UUID()

    /// Individual note color. It will default to `noteColor` in `PianoRoll` if not set.
    public var color: Color?

    /// The start step
    public var start: Double

    /// Duration, measured in steps
    public var length: Double

    /// Abstract pitch, not MIDI notes.
    public var pitch: Int

    /// Optional text shown on the note view
    public var text: String?
}
