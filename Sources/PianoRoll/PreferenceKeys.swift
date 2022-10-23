import SwiftUI

/// For accumulating note view offsets.
public struct NoteOffsetsKey: PreferenceKey {
    public static var defaultValue: [NoteOffsetInfo] = []

    public static func reduce(value: inout [NoteOffsetInfo], nextValue: () -> [NoteOffsetInfo]) {
        value.append(contentsOf: nextValue())
    }
}

public struct NoteOffsetInfo: Equatable {
    public var offset: CGSize
    public var noteId: UUID
}
