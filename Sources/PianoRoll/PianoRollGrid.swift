// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/PianoRoll/

import SwiftUI

/// Background grid for the piano roll.
///
/// We tried using Canvas but because a piano roll grid can be very large when inside a scroll
/// view, Canvas allocates too big of a texture for rendering.
struct PianoRollGrid: Shape {
    var gridSize: CGSize
    var length: Int
    var height: Int
    var layout: PianoRoll.Layout

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
