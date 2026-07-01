// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

/// A single note in the piano roll.
///
/// A note has half a grid column at the end for changing the length.
///
/// With each note as a separate view this might not be suitable for very large sequences, but
/// it makes it easier to implement.
struct PianoRollNoteView<NoteContent: View>: View {
    @Binding var note: PianoRollNote
    var gridSize: CGSize
    var color: Color

    // Note: using @GestureState instead of @State here fixes a bug where the
    //       offset could get stuck when inside a ScrollView.
    @GestureState var offset = CGSize.zero

    @State var hovering = false

    // Note: using @GestureState instead of @State here fixes a bug where the
    //       lengthOffset could get stuck when inside a ScrollView.
    @GestureState var lengthOffset: CGFloat = 0

    var sequenceLength: Int
    var sequenceHeight: Int
    var isContinuous = false
    var editable: Bool = false
    /// Width of the trailing drag handle used to change a note's length.
    /// `nil` keeps the default of half a grid column.
    var resizeHandleLength: CGFloat? = nil
    var noteContent: (PianoRollNote, Bool) -> NoteContent

    var isActive: Bool {
        hovering || offset != .zero || lengthOffset != 0
    }

    var noteColor: Color {
        note.color ?? color
    }

    private var lengthHandleWidth: CGFloat {
        resizeHandleLength ?? gridSize.width * 0.5
    }

    func snap(note: PianoRollNote, offset: CGSize, lengthOffset: CGFloat = 0.0) -> PianoRollNote {
        var n = note
        if isContinuous {
            n.start += offset.width / gridSize.width
        } else {
            n.start += round(offset.width / CGFloat(gridSize.width))
        }
        n.start = max(0, n.start)
        n.start = min(Double(sequenceLength - 1), n.start)
        n.pitch -= Int(round(offset.height / CGFloat(gridSize.height)))
        n.pitch = max(1, n.pitch)
        n.pitch = min(sequenceHeight, n.pitch)
        if isContinuous {
            n.length += lengthOffset / gridSize.width
        } else {
            n.length += round(lengthOffset / gridSize.width)
        }
        n.length = max(1, n.length)
        n.length = min(Double(sequenceLength), n.length)
        n.length = min(Double(sequenceLength) - n.start, n.length)
        return n
    }

    func noteOffset(note: PianoRollNote, dragOffset: CGSize = .zero) -> CGSize {
        CGSize(width: gridSize.width * CGFloat(note.start) + dragOffset.width,
               height: gridSize.height * CGFloat(sequenceHeight - note.pitch) + dragOffset.height)
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
                note = snap(note: note, offset: value.translation)
            }

        let lengthDragGesture = DragGesture(minimumDistance: 2)
            .updating($lengthOffset) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                note = snap(note: note, offset: CGSize.zero, lengthOffset: value.translation.width)
            }

        // Single root container so each ForEach element keeps a constant view
        // count; conditional children here made SwiftUI re-evaluate every note
        // body whenever any note changed.
        ZStack(alignment: .topLeading) {
            // While dragging, show where the note will land.
            Rectangle()
                .foregroundColor(.black.opacity(offset == .zero ? 0 : 0.2))
                .frame(width: gridSize.width * CGFloat(note.length),
                       height: gridSize.height)
                .offset(noteOffset(note: snap(note: note, offset: offset)))
                .zIndex(-1)

            // Main note body.
            noteContent(note, isActive)
                .onHover { over in hovering = over }
                .padding(1) // so we can see consecutive notes
                .frame(width: max(gridSize.width, gridSize.width * CGFloat(note.length) + lengthOffset),
                       height: gridSize.height)
                .offset(noteOffset(note: note, dragOffset: offset))
                .gesture(editable ? noteDragGesture : nil)
                .preference(key: NoteOffsetsKey.self,
                            value: [NoteOffsetInfo(offset: noteOffset(note: note, dragOffset: offset),
                                                   noteId: note.id)])

            // Length tab at the end of the note.
            HStack {
                Spacer()
                Rectangle()
                    .foregroundColor(.white.opacity(0.001))
                    .frame(width: lengthHandleWidth, height: gridSize.height)
                    .gesture(editable ? lengthDragGesture : nil)
            }
            .frame(width: gridSize.width * CGFloat(note.length),
                   height: gridSize.height)
            .offset(noteOffset(note: note, dragOffset: offset))
        }
    }
}
