//
//  ThirdExampleView.swift
//  MetalShaders
//
//  Created by Davide Castaldi on 04/05/24.
//

import SwiftUI

struct ThirdExampleView: View {
    
    @State private var touch: CGPoint = CGPoint.zero
    
    var body: some View {
        TimelineView(.animation) { tl in
            Image("Image")
                .resizable()
                .scaledToFit()
                .background(.white)
            
            //MARK: let's introduce the last way to call metal shaders. This lets us use the View size directly:
                .visualEffect { content, geometryProxy in
                    content
                        .layerEffect(
                            ShaderLibrary.loupe(
                                .float2(geometryProxy.size),
                                .float2(touch)
                            ), maxSampleOffset: .zero)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            touch = value.location
                        }
                )
        }
        
    }
}

#Preview {
    ThirdExampleView()
}
