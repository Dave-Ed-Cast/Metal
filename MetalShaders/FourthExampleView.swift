//
//  FourthExampleView.swift
//  MetalShaders
//
//  Created by Davide Castaldi on 04/05/24.
//

import SwiftUI
/*
 //MARK: This is what we want to achieve, but in SwiftUI
struct BlurTransition: ViewModifier {
    
    var progress: Double = 0.0
    
    func body(content: Content) -> some View {
        content
            .blur(radius: progress * 10)
            .opacity(1 - progress)
            .clipped()
    }
}

struct ZoomTransition: ViewModifier {
    
    var progress: Double = 0.0
    func body(content: Content) > some View {
        content
            .scaleEffect(1 + progress)
            .opacity(1 - progress)
            .clipped()
    }
}
extension AnyTransition {
    
    static let blur: AnyTransition = .modifier(
        active: BlurTransition(progress: 1),
        identity: BlurTransition(progress: 0)
    )
}
 */


//MARK: Understand how should i make this work
struct FourthExampleView: View {
    
    @State private var progress: Double = 0.0
    @State private var size: Double = 0.0
    var body: some View {
        TimelineView(.animation) { tl in
            Image("Image")
                .resizable()
                .scaledToFit()
                .background(.white)
                .colorEffect(ShaderLibrary.circles(
                    .float(progress),
                    .float(size)
                ))
        }
    }
}

#Preview {
    FourthExampleView()
}
