//
//  GraphView.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//


import SwiftUI

struct GraphView: View {
    var jumpCount: Int

    var body: some View {
        GeometryReader { geo in
            Path { path in
                path.move(to: .zero)
                path.addLine(to: CGPoint(x: geo.size.width, y: CGFloat.random(in: 0...geo.size.height)))
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}
