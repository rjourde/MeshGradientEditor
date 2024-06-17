//
//  ContentView.swift
//  MeshGradientEditor
//
//  Created by Remy Jourde on 17/06/2024.
//

import SwiftUI

struct ContentView: View {

    @State var rowCount: Int
    @State var columnCount: Int

    @State var controlPoints: [SIMD2<Float>]

    @State var colors: [Color] = [
        .blue, .blue, .blue,
        .green, .green, .green,
        .red, .red, .red
    ]

    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    MeshGradient(
                        width: columnCount,
                        height: rowCount,
                        points: controlPoints,
                        colors: colors
                    )
                    ForEach(Array(controlPoints.enumerated()), id: \.offset) { index, point in
                        Circle()
                            .fill(.thinMaterial)
                            .frame(width: 40, height: 40)
                            .position(pointPosition(for: point, in: geometry.size))
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        controlPoints[index] = updatedPosition(
                                            at: gesture.location,
                                            in: geometry.size
                                        )
                                    }
                            )
                    }
                }
            }
            .padding()
            .padding()
        }
        HStack {
            HStack {
                Text("Rows")
                Button {
                    rowCount = max(2, rowCount - 1)
                    updateControlPoints()
                    updateParameters()
                } label: {
                    Image(systemName: "minus")
                        .frame(height: 16)
                }
                Button {
                    rowCount += 1
                    updateControlPoints()
                    updateParameters()
                } label: {
                    Image(systemName: "plus")
                }
            }
            Spacer()
            HStack {
                Text("Columns")
                Button {
                    columnCount = max(2, columnCount - 1)
                    updateParameters()
                } label: {
                    Image(systemName: "minus")
                        .frame(height: 16)
                }
                Button {
                    columnCount += 1
                    updateParameters()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }

    private func updateParameters() {
        updateControlPoints()
        updateColours()
    }

    private func updateControlPoints() {
        var points: [SIMD2<Float>] = []
        
        let rowSpacing = rowCount > 1 ? 1.0 / Float(rowCount - 1) : 0
        let columnSpacing = columnCount > 1 ? 1.0 / Float(columnCount - 1) : 0

        for row in 0...rowCount - 1 {
            let y = Float(row) * rowSpacing
            
            for column in 0...columnCount - 1 {
                let x = Float(column) * columnSpacing
                points.append([x, y])
            }
        }
        
        controlPoints = points
    }

    private func updateColours() {
        var colors: [Color] = []

        for _ in 0...columnCount - 1 {
            let rowColor = randomColor()

            for _ in 0...rowCount - 1  {
                colors.append(rowColor)
            }
        }

        self.colors = colors
    }

    private func pointPosition(for point:SIMD2<Float>, in containerSize: CGSize) -> CGPoint {
        CGPoint(x: containerSize.width * CGFloat(point.x), y: containerSize.height * CGFloat(point.y))
    }

    private func updatedPosition(at location: CGPoint, in containerSize: CGSize) -> SIMD2<Float> {
        [
            Float(min(max(0, location.x / containerSize.width), 1)),
            Float(min(max(0, location.y / containerSize.height), 1)),
        ]
    }

    private func randomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}

#Preview {
    ContentView(
        rowCount: 3,
        columnCount: 3, 
        controlPoints: [
            [0, 0], [0.5, 0], [1, 0],
            [0, 0.5], [0.5, 0.5], [1, 0.5],
            [0, 1], [0.5, 1], [1, 1]
        ]
    )
}
