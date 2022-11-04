// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

/// Value oriented data model for `PianoRoll`
///
/// The data model is abstracted away from MIDI so that it's up to you
/// to determine what pitch means (e.g. how it is scale quantized).
public struct PianoRollModel: Equatable {
    /// Initialize the PianoRollModel an array of PianoRollNotes, and dimensions
    /// - Parameters:
    ///   - notes: The sequence being edited
    ///   - length: Duration in steps
    ///   - height: The number of pitches representable
    public init(notes: [PianoRollNote], length: Int, height: Int) {
        self.notes = notes
        self.length = length
        self.height = height
    }

    /// The sequence being edited
    public var notes: [PianoRollNote]

    /// Duration in steps
    public var length: Int

    /// The number of pitches represented
    public var height: Int
}
