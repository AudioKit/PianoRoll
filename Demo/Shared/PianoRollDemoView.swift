// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKitUI/

import PianoRoll
import SwiftUI

public struct PianoRollDemoView: View {
    public init() {}

    @State var model = PianoRollModel(notes: [
        PianoRollNote(start: 1, length: 2, pitch: 3),
        PianoRollNote(start: 5, length: 1, pitch: 4),
    ], length: 16, height: 16)

    static let pitchColors: [Color] = [
        .red, .orange, .yellow, .green, .mint, .cyan,
        .blue, .indigo, .purple, .pink, .red, .orange,
        .yellow, .green, .mint, .cyan,
    ]

    static func pianoKeyRowBackground(pitch: Int) -> Color? {
        let pitchClass = (pitch - 1) % 12
        if [1, 3, 6, 8, 10].contains(pitchClass) {
            return .black.opacity(0.22)
        }
        if pitchClass == 0 {
            return .white.opacity(0.12)
        }
        return nil
    }

    @State var customModel = PianoRollModel(notes: [
        PianoRollNote(start: 0, length: 2, pitch: 3, text: "C"),
        PianoRollNote(start: 2, length: 2, pitch: 5, text: "E"),
        PianoRollNote(start: 4, length: 3, pitch: 7, text: "G"),
        PianoRollNote(start: 4, length: 1, pitch: 10, text: "B♭"),
        PianoRollNote(start: 7, length: 1, pitch: 8, text: "A♭"),
        PianoRollNote(start: 8, length: 4, pitch: 5, text: "E"),
        PianoRollNote(start: 8, length: 2, pitch: 12, text: "D"),
        PianoRollNote(start: 10, length: 1, pitch: 9, text: "A"),
        PianoRollNote(start: 12, length: 3, pitch: 6, text: "F"),
        PianoRollNote(start: 12, length: 1, pitch: 14, text: "F"),
        PianoRollNote(start: 13, length: 2, pitch: 11, text: "C♯"),
    ], length: 16, height: 16)

    public var body: some View {
        VStack(spacing: 20) {
            Text("Default Note Style")
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                PianoRoll(
                    model: $model,
                    noteColor: .cyan,
                    layout: .horizontal,
                    rowBackgroundColor: Self.pianoKeyRowBackground
                )
            }.background(Color(white: 0.4))

            Text("Custom Neon Pill Notes")
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                PianoRoll(
                    model: $customModel,
                    noteColor: .cyan,
                    layout: .horizontal,
                    rowBackgroundColor: Self.pianoKeyRowBackground
                ) { note, isActive in
                    let color = Self.pitchColors[(note.pitch - 1) % Self.pitchColors.count]
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [color, color.opacity(0.6)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .opacity(isActive ? 1.0 : 0.85)
                            .shadow(color: color.opacity(isActive ? 0.9 : 0.5), radius: isActive ? 8 : 4)
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(.white.opacity(0.4), lineWidth: 1)
                        Text(note.text ?? "")
                            .font(.system(.caption, design: .rounded).bold())
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                    }
                    .scaleEffect(isActive ? 1.05 : 1.0)
                    .animation(.easeOut(duration: 0.15), value: isActive)
                }
            }.background(Color(white: 0.12))
        }
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        PianoRollDemoView()
    }
}
