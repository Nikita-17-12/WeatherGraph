//
//  CircularDragProgressView.swift
//  WeatherGraph
//
//  Created by MTPC-206 on 15/12/23.
//

import SwiftUI

import SwiftUI

struct CircularDragProgressView: View {
    @State private var progress: CGFloat = 0.0
    @State private var startAngle: Angle = .degrees(-90)

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)

                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.blue)
                    .rotationEffect(startAngle)

                Text(String(format: "%.0f%%", progress * 100.0))
                    .font(.title)
                    .bold()
            }
            .padding(40)
            .gesture(DragGesture()
                        .onChanged { value in
                            updateProgress(with: value)
                        }
                        .onEnded { _ in
                            // Add any additional cleanup or completion logic here
                        }
            )
        }
    }

    private func updateProgress(with value: DragGesture.Value) {
        let center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        let vector = CGVector(dx: value.location.x - center.x, dy: value.location.y - center.y)
        let angle = atan2(vector.dy, vector.dx)
        let normalizedAngle = angle < 0 ? (2 * .pi + angle) : angle

        let progress = normalizedAngle / (2 * .pi)
        self.progress = progress
    }
}

struct CircularDragProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularDragProgressView()
    }
}
