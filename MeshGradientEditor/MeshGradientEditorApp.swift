//
//  MeshGradientEditorApp.swift
//  MeshGradientEditor
//
//  Created by Remy Jourde on 17/06/2024.
//

import SwiftUI

@main
struct MeshGradientEditorApp: App {
    var body: some Scene {
        WindowGroup {
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
    }
}
