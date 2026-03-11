// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

/// The default note appearance used by PianoRoll when no custom noteContent closure is provided.
public struct DefaultNoteView: View {
    var note: PianoRollNote
    var color: Color
    var isActive: Bool
    var lineOpacity: Double
    var layout: PianoRollLayout

    public var body: some View {
        switch layout {
        case .horizontal:
            ZStack(alignment: .trailing) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor((note.color ?? color).opacity(isActive ? 1.0 : 0.8))
                    Text(note.text ?? "")
                        .opacity(note.text == nil ? 0 : 1)
                        .padding(.leading, 5)
                }
                Rectangle()
                    .foregroundColor(.black)
                    .padding(4)
                    .frame(width: 10)
                    .opacity(lineOpacity)
            }
        case .vertical:
            ZStack(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .foregroundColor((note.color ?? color).opacity(isActive ? 1.0 : 0.8))
                    Text(note.text ?? "")
                        .opacity(note.text == nil ? 0 : 1)
                        .padding(.bottom, 5)
                }
                Rectangle()
                    .foregroundColor(.black)
                    .padding(4)
                    .frame(height: 10)
                    .opacity(lineOpacity)
            }
        }
    }
}
