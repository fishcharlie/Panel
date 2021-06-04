/**
*  Panel
*  Copyright (c) Florian Mielke 2021
*  MIT license, see LICENSE file for details
*/

import SwiftUI

struct Panel<Content: View> : View {
    @Binding var anchor: PanelAnchor
    let insets: EdgeInsets
    @ViewBuilder var content: () -> Content
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @GestureState private var dragState = DragState.inactive
    
    private let shadowColor = Color(.sRGBLinear, white: 0, opacity: 0.13)
    
    var body: some View {
        GeometryReader { geometry in
            let environment = PanelEnvironment(anchor: anchor, geometry: geometry, insets: insets, sizeClass: horizontalSizeClass, dragState: dragState)
            
            VStack(spacing: 0) {
                if environment.isCompact {
                    Handle()
                    content()
                } else {
                    content()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    Handle()
                }
            }
            .frame(maxWidth: environment.width, maxHeight: environment.height, alignment: .top)
            .background(BlurView(style: .systemChromeMaterial))
            .cornerRadius(10.0)
            .shadow(color: shadowColor, radius: 10.0)
            .frame(maxHeight: .infinity, alignment: environment.alignment)
            .padding(environment.padding)
            .animation(environment.animation)
            .gesture(
                DragGesture()
                    .updating($dragState) { drag, state, transaction in
                        state = .dragging(translation: drag.translation)
                    }
                    .onEnded { value in
                        onDragEnded(drag: value, environment: environment)
                    }
            )
        }
        .edgesIgnoringSafeArea(.vertical)
    }
    
    private func onDragEnded(drag: DragGesture.Value, environment: PanelEnvironment) {
        anchor = environment.anchor(for: drag)
    }
}

struct Panel_Previews: PreviewProvider {
    static var content: some View {
        List {
            ForEach(0..<100, id: \.self) {
                Text("Element \($0)")
            }
        }
    }

    static var previews: some View {
        Group {
            Panel(anchor: .constant(.medium), insets: EdgeInsets(top: 10.0, leading: 0.0, bottom: 0.0, trailing: 0.0)) {
                content
            }
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            
            Panel(anchor: .constant(.small), insets: EdgeInsets(top: 10.0, leading: 0.0, bottom: 0.0, trailing: 0.0)) {
                content
            }
            .previewDevice("iPhone 12 mini")
        }
    }
}