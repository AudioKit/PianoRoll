// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKitUI/

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
    ///   - height: The number of pitches represented
    public init(notes: [PianoRollNote], length: Int, height: Int) {
        self.notes = notes
        self.length = length
        self.height = height
    }

    /// The sequence being edited
    var notes: [PianoRollNote]

    /// Duration in steps
    var length: Int

    /// The number of pitches represented
    var height: Int
}
