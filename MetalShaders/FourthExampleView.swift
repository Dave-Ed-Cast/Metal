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


//MARK: Now let's do it in metal
struct FourthExampleView: View {
    var body: some View {
        Image("Image")
            .resizable()
            .scaledToFit()
            .background(.white)
    }
}

#Preview {
    FourthExampleView()
}
