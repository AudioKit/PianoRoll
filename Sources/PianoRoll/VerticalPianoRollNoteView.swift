// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

/// A single note in the piano roll.
///
/// A note has half a grid column at the end for changing the length.
///
/// With each note as a separate view this might not be suitable for very large sequences, but
/// it makes it easier to implement.
struct VerticalPianoRollNoteView<NoteContent: View>: View {
    @Binding var note: PianoRollNote
    var gridSize: CGSize
    var color: Color

    // Note: using @GestureState instead of @State here fixes a bug where the
    //       offset could get stuck when inside a ScrollView.
    @GestureState var offset = CGSize.zero

    @State var hovering = false

    // Note: using @GestureState instead of @State here fixes a bug where the
    //       lengthOffset could get stuck when inside a ScrollView.
    @GestureState var heightOffset: CGFloat = 0

    var sequenceLength: Int
    var sequenceHeight: Int
    var isContinuous = false
    var editable: Bool = false
    /// Height of the trailing drag handle used to change a note's length.
    /// `nil` keeps the default of half a grid column.
    var resizeHandleLength: CGFloat? = nil
    var noteContent: (PianoRollNote, Bool) -> NoteContent

    var isActive: Bool {
        hovering || offset != .zero || heightOffset != 0
    }

    var noteColor: Color {
        note.color ?? color
    }

    private var lengthHandleHeight: CGFloat {
        // Never let the handle cover more than half the note, so short notes
        // keep a grabbable area for moving.
        min(resizeHandleLength ?? gridSize.width * 0.5,
            gridSize.width * CGFloat(note.length) * 0.5)
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
        // The minimum distance a note drag needs before it starts: high enough
        // that a tap-to-delete with slight finger movement isn't misread as a
        // drag, while still overriding the drag of a containing ScrollView.
        let minimumDistance: CGFloat = 8

        // The model is only written when the drag completes, so the entire
        // drag is a single model change (and a single undo step). While the
        // drag is in flight the note is rendered from local gesture state.
        let noteDragGesture = DragGesture(minimumDistance: minimumDistance)
            .updating($offset) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                note = snap(
                    note: note,
                    offset: .init(width: -value.translation.width, height: -value.translation.height)
                )
            }

        let heightDragGesture = DragGesture(minimumDistance: 2)
            .updating($heightOffset) { value, state, _ in
                state = value.translation.height
            }
            .onEnded { value in
                note = snap(note: note, offset: CGSize.zero, lengthOffset: value.translation.height)
            }

        // Single root container so each ForEach element keeps a constant view
        // count; conditional children here made SwiftUI re-evaluate every note
        // body whenever any note changed.
        ZStack(alignment: .topLeading) {
            // While dragging, show where the note will land.
            Rectangle()
                .foregroundColor(.black.opacity(offset == .zero ? 0 : 0.2))
                .frame(width: gridSize.height,
                       height: gridSize.width * CGFloat(note.length))
                .offset(noteOffset(note: snap(note: note, offset: .init(width: -offset.width, height: -offset.height))))
                .zIndex(-1)

            // Main note body.
            noteContent(note, isActive)
                .onHover { over in hovering = over }
                .padding(1) // so we can see consecutive notes
                .frame(width: gridSize.height,
                       height: max(gridSize.width, gridSize.width * CGFloat(note.length) + heightOffset))
                .offset(noteOffset(note: note, dragOffset: offset))
                .gesture(editable ? noteDragGesture : nil)
                .preference(key: NoteOffsetsKey.self,
                            value: [NoteOffsetInfo(offset: noteOffset(note: note, dragOffset: offset),
                                                   noteId: note.id)])

            // Length tab at the end of the note.
            VStack {
                Spacer()
                Rectangle()
                    .foregroundColor(.white.opacity(0.001))
                    .frame(width: gridSize.height, height: lengthHandleHeight)
                    .gesture(editable ? heightDragGesture : nil)

            }
            .frame(width: gridSize.height,
                   height: gridSize.width * CGFloat(note.length))
            .offset(noteOffset(note: note, dragOffset: offset))
        }
    }
}
