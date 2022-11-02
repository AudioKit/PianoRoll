// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

/// A single note in the piano roll.
///
/// A note has half a grid column at the end for changing the length.
///
/// With each note as a separate view this might not be suitable for very large sequences, but
/// it makes it easier to implement.
struct VerticalPianoRollNoteView: View {
    @Binding var note: PianoRollNote
    var gridSize: CGSize
    var color: Color

    // Note: using @GestureState instead of @State here fixes a bug where the
    //       offset could get stuck when inside a ScrollView.
    @GestureState var offset = CGSize.zero
    @GestureState var startNote: PianoRollNote?

    @State var hovering = false

    // Note: using @GestureState instead of @State here fixes a bug where the
    //       lengthOffset could get stuck when inside a ScrollView.
    @GestureState var heightOffset: CGFloat = 0

    var sequenceLength: Int
    var sequenceHeight: Int
    var isContinuous = false
    var editable: Bool = false
    var lineOpacity: Double = 1

    var noteColor: Color {
        note.color ?? color
    }

    func snap(note: PianoRollNote, offset: CGSize, lengthOffset: CGFloat = 0.0) -> PianoRollNote {
        var note = note
        if isContinuous {
            note.start += offset.height / gridSize.width
        } else {
            note.start += round(offset.height / CGFloat(gridSize.width))
        }
        note.pitch -= Int(round(offset.width / CGFloat(gridSize.height)))
        note.pitch = max(1, note.pitch)
        note.pitch = min(sequenceHeight, note.pitch)
        if isContinuous {
            note.length += lengthOffset / gridSize.width
            note.start -= lengthOffset / gridSize.width
        } else {
            note.length += round(lengthOffset / gridSize.width)
        }
        note.start = max(0, note.start)
        note.start = min(Double(sequenceLength - 1), note.start)
        note.length = max(1, note.length)
        note.length = min(Double(sequenceLength), note.length)
        note.length = min(Double(sequenceLength) - note.start, note.length)
        return note
    }

    func noteOffset(note: PianoRollNote, dragOffset: CGSize = .zero) -> CGSize {
        CGSize(width: gridSize.height * CGFloat(note.pitch - 1) + dragOffset.width,
               height: gridSize.width * CGFloat(Double(sequenceLength) - note.start - note.length) + dragOffset.height)
    }

    var body: some View {
        // While dragging, show where the note will go.
        if offset != CGSize.zero {
            Rectangle()
                .foregroundColor(.black.opacity(0.2))
                .frame(width: gridSize.height,
                       height: gridSize.width * CGFloat(note.length))
                .offset(noteOffset(note: note))
                .zIndex(-1)
        }

        // Set the minimum distance so a note drag will override
        // the drag of a containing ScrollView.
        let minimumDistance: CGFloat = 2

        // We don't want to actually update the data model until
        // the drag is completed, so the entire drag is recorded
        // as a single undo.
        let noteDragGesture = DragGesture(minimumDistance: minimumDistance)
            .updating($offset) { value, state, _ in
                state = value.translation
            }
            .updating($startNote) { _, state, _ in
                if state == nil {
                    state = note
                }
            }
            .onChanged { value in
                if let startNote = startNote {
                    note = snap(
                        note: startNote,
                        offset: .init(width: -value.translation.width, height: -value.translation.height)
                    )
                }
            }

        let heightDragGesture = DragGesture(minimumDistance: minimumDistance)
            .updating($heightOffset) { value, state, _ in
                state = value.translation.height
            }
            .onEnded { value in
                note = snap(note: note, offset: CGSize.zero, lengthOffset: value.translation.height)
            }

        // Main note body.
        ZStack(alignment: .bottom) {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(noteColor.opacity((hovering || offset != .zero || heightOffset != 0) ? 1.0 : 0.8))
                Text(note.text ?? "")
                    .opacity(note.text == nil ? 0 : 1)
                    .padding(.bottom, 5)
            }
            Rectangle()
                .foregroundColor(.black)
                .padding(4)
                .frame(height: 10)
                .opacity(editable ? lineOpacity : 0)
        }
            .onHover { over in hovering = over }
            .padding(1) // so we can see consecutive notes
            .frame(width: gridSize.height,
                   height: max(gridSize.width, gridSize.width * CGFloat(note.length) + heightOffset))
            .offset(noteOffset(note: startNote ?? note, dragOffset: offset))
            .gesture(editable ? noteDragGesture : nil)
            .preference(key: NoteOffsetsKey.self,
                        value: [NoteOffsetInfo(offset: noteOffset(note: startNote ?? note, dragOffset: offset),
                                               noteId: note.id)])

        // Length tab at the end of the note.
        VStack {
            Spacer()
            Rectangle()
                .foregroundColor(.white.opacity(0.001))
                .frame(width: gridSize.height, height: gridSize.width * 0.5)
                .gesture(editable ? heightDragGesture : nil)

        }
        .frame(width: gridSize.height,
               height: gridSize.width * CGFloat(note.length))
        .offset(noteOffset(note: note, dragOffset: offset))
    }
}
