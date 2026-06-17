// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

/// Layout orientation for the piano roll.
public enum PianoRollLayout: Sendable {
    case horizontal
    case vertical
}

/// Touch-oriented piano roll.
///
/// Note: Requires macOS 12 / iOS 15 due to SwiftUI bug (crashes in SwiftUI when deleting notes).
public struct PianoRoll<NoteContent: View>: View {
    public typealias Layout = PianoRollLayout

    @Binding var model: PianoRollModel
    var editable: Bool
    var gridColor: Color
    var gridSize: CGSize
    var noteColor: Color
    var noteLineOpacity: Double
    var layout: PianoRollLayout
    var rowBackgroundColor: (Int) -> Color?
    /// Length of the trailing drag handle used to resize a note (width in a horizontal
    /// layout, height in a vertical one). `nil` keeps the default of half a grid column.
    var resizeHandleLength: CGFloat?
    var noteContent: (PianoRollNote, Bool) -> NoteContent

    /// Initialize PianoRoll with a binding to a model, a color, and a custom note view builder
    /// - Parameters:
    ///   - editable: Disable edition of any note in piano roll
    ///   - model: PianoRoll data
    ///   - noteColor: Color to use for the note indicator, defaults to system accent color
    ///   - noteLineOpacity: Opacity of the note view vertical black line
    ///   - gridColor: Color of grid
    ///   - gridSize: Size of a grid cell
    ///   - layout: Horizontal or vertical layout
    ///   - rowBackgroundColor: Color for a pitch row, or nil to leave it transparent. The pitch is 1-based.
    ///   - resizeHandleLength: Length of the trailing drag handle used to resize a note. `nil` (default) uses half a grid column.
    ///   - noteContent: Custom view builder for note appearance. Receives the note and whether it is active (hovering/dragging).
    public init(
        editable: Bool = true,
        model: Binding<PianoRollModel>,
        noteColor: Color = .accentColor,
        noteLineOpacity: Double = 1,
        gridColor: Color = Color(red: 15.0 / 255.0, green: 17.0 / 255.0, blue: 16.0 / 255.0),
        gridSize: CGSize = CGSize(width: 80, height: 40),
        layout: PianoRollLayout = .horizontal,
        rowBackgroundColor: @escaping (Int) -> Color? = { _ in nil },
        resizeHandleLength: CGFloat? = nil,
        @ViewBuilder noteContent: @escaping (PianoRollNote, Bool) -> NoteContent
    ) {
        _model = model
        self.noteColor = noteColor
        self.noteLineOpacity = noteLineOpacity
        self.gridSize = gridSize
        self.gridColor = gridColor
        self.editable = editable
        self.layout = layout
        self.rowBackgroundColor = rowBackgroundColor
        self.resizeHandleLength = resizeHandleLength
        self.noteContent = noteContent
    }

    private var width: CGFloat {
        CGFloat(model.length) * gridSize.width
    }

    private var height: CGFloat {
        CGFloat(model.height) * gridSize.height
    }

    /// SwiftUI view with grid and ability to add, delete and modify notes
    public var body: some View {
        ZStack(alignment: .topLeading) {
            let dragGesture = DragGesture(minimumDistance: 0).onEnded { value in
                let location = value.location
                var note: PianoRollNote
                switch layout {
                case .horizontal:
                    let step = Double(Int(location.x / gridSize.width))
                    let pitch = model.height - Int(location.y / gridSize.height)
                    note = PianoRollNote(start: step, length: 1, pitch: pitch, color: noteColor)
                case .vertical:
                    let step = Double(Int(location.y / gridSize.width))
                    let pitch = Int(location.x / gridSize.height)
                    note = PianoRollNote(
                        start: Double(model.length) - step - 1,
                        length: 1,
                        pitch: pitch + 1,
                        color: noteColor
                    )
                }
                model.notes.append(note)
            }
            PianoRollRowBackground(
                gridSize: gridSize,
                length: model.length,
                height: model.height,
                layout: layout,
                rowBackgroundColor: rowBackgroundColor
            )
                .allowsHitTesting(false)
            PianoRollGrid(gridSize: gridSize, length: model.length, height: model.height, layout: layout)
                .stroke(lineWidth: 0.5)
                .foregroundColor(gridColor)
                .contentShape(Rectangle())
                .gesture(editable ? TapGesture().sequenced(before: dragGesture) : nil)
            ForEach($model.notes) { $note in
                switch layout {
                case .horizontal:
                    PianoRollNoteView(
                        note: $note,
                        gridSize: gridSize,
                        color: noteColor,
                        sequenceLength: model.length,
                        sequenceHeight: model.height,
                        isContinuous: true,
                        editable: editable,
                        resizeHandleLength: resizeHandleLength,
                        noteContent: noteContent
                    ).onTapGesture {
                        guard editable else { return }
                        model.notes.removeAll(where: { $0 == note })
                    }

                case .vertical:
                    VerticalPianoRollNoteView(
                        note: $note,
                        gridSize: gridSize,
                        color: noteColor,
                        sequenceLength: model.length,
                        sequenceHeight: model.height,
                        isContinuous: true,
                        editable: editable,
                        resizeHandleLength: resizeHandleLength,
                        noteContent: noteContent
                    ).onTapGesture {
                        guard editable else { return }
                        model.notes.removeAll(where: { $0 == note })
                    }
                }
            }
        }.frame(width: layout == .horizontal ? width : height,
                height: layout == .horizontal ? height : width)
    }
}

/// Backward-compatible initializer that uses the default note appearance.
extension PianoRoll where NoteContent == DefaultNoteView {
    public init(
        editable: Bool = true,
        model: Binding<PianoRollModel>,
        noteColor: Color = .accentColor,
        noteLineOpacity: Double = 1,
        gridColor: Color = Color(red: 15.0 / 255.0, green: 17.0 / 255.0, blue: 16.0 / 255.0),
        gridSize: CGSize = CGSize(width: 80, height: 40),
        layout: PianoRollLayout = .horizontal,
        rowBackgroundColor: @escaping (Int) -> Color? = { _ in nil },
        resizeHandleLength: CGFloat? = nil
    ) {
        self.init(
            editable: editable,
            model: model,
            noteColor: noteColor,
            noteLineOpacity: noteLineOpacity,
            gridColor: gridColor,
            gridSize: gridSize,
            layout: layout,
            rowBackgroundColor: rowBackgroundColor,
            resizeHandleLength: resizeHandleLength
        ) { note, isActive in
            DefaultNoteView(
                note: note,
                color: noteColor,
                isActive: isActive,
                lineOpacity: editable ? noteLineOpacity : 0,
                layout: layout
            )
        }
    }
}

struct PianoRollPreview: View {
    init() {}

    @State var model = PianoRollModel(notes: [
        PianoRollNote(start: 1, length: 2, pitch: 3),
        PianoRollNote(start: 5, length: 1, pitch: 4),
    ], length: 128, height: 128)

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            PianoRoll(model: $model, noteColor: .cyan)
        }.background(Color(white: 0.1))
    }
}

struct PianoRoll_Previews: PreviewProvider {
    static var previews: some View {
        PianoRollPreview()
    }
}
