// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

/// Per-pitch background rows for the piano roll.
struct PianoRollRowBackground: View {
    var gridSize: CGSize
    var length: Int
    var height: Int
    var layout: PianoRollLayout
    var rowBackgroundColor: (Int) -> Color?

    private var pitches: [Int] {
        guard height > 0 else { return [] }
        return Array(1 ... height)
    }

    private var size: CGSize {
        switch layout {
        case .horizontal:
            return CGSize(width: CGFloat(length) * gridSize.width,
                          height: CGFloat(height) * gridSize.height)
        case .vertical:
            return CGSize(width: CGFloat(height) * gridSize.height,
                          height: CGFloat(length) * gridSize.width)
        }
    }

    private func rowSize() -> CGSize {
        switch layout {
        case .horizontal:
            return CGSize(width: CGFloat(length) * gridSize.width, height: gridSize.height)
        case .vertical:
            return CGSize(width: gridSize.height, height: CGFloat(length) * gridSize.width)
        }
    }

    private func rowOffset(for pitch: Int) -> CGSize {
        switch layout {
        case .horizontal:
            return CGSize(width: 0, height: CGFloat(height - pitch) * gridSize.height)
        case .vertical:
            return CGSize(width: CGFloat(pitch - 1) * gridSize.height, height: 0)
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
                .frame(width: size.width, height: size.height)
            ForEach(pitches, id: \.self) { pitch in
                if let color = rowBackgroundColor(pitch) {
                    Rectangle()
                        .fill(color)
                        .frame(width: rowSize().width, height: rowSize().height)
                        .offset(rowOffset(for: pitch))
                }
            }
        }
        .frame(width: size.width, height: size.height, alignment: .topLeading)
    }
}

/// Background grid for the piano roll.
///
/// We tried using Canvas but because a piano roll grid can be very large when inside a scroll
/// view, Canvas allocates too big of a texture for rendering.
struct PianoRollGrid: Shape {
    var gridSize: CGSize
    var length: Int
    var height: Int
    var layout: PianoRollLayout

    func path(in rect: CGRect) -> Path {
        let size = rect.size
        var path = Path()

        func drawHorizontal(count: Int, width: CGFloat) {
            for column in 0 ... count {
                let anchor = CGFloat(column) * width
                path.move(to: CGPoint(x: anchor, y: 0))
                path.addLine(to: CGPoint(x: anchor, y: size.height))
            }
        }

        func drawVertical(count: Int, height: CGFloat) {
            for row in 0 ... count {
                let anchor = CGFloat(row) * height
                path.move(to: CGPoint(x: 0, y: anchor))
                path.addLine(to: CGPoint(x: size.width, y: anchor))
            }
        }

        switch layout {
        case .horizontal:
            drawHorizontal(count: length, width: gridSize.width)
            drawVertical(count: height, height: gridSize.height)
        case .vertical:
            drawHorizontal(count: height, width: gridSize.height)
            drawVertical(count: length, height: gridSize.width)
        }

        return path
    }
}
