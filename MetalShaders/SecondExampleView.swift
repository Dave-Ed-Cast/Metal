//
//  SecondExampleView.swift
//  MetalShaders
//
//  Created by Davide Castaldi on 04/05/24.
//

import SwiftUI

//MARK: Be sure to use the the other example view first!
struct SecondExampleView: View {
    
    @State private var start: Date = Date.now
    @State private var touch: CGPoint = CGPoint.zero
    var body: some View {
        TimelineView(.animation) { tl in
            
            let time = start.distance(to: tl.date)
            
            Image("Italy")
                .font(.system(size: 300))
                .foregroundStyle(.tint)
            
            //read the "relativeWave" function in the metal file
                .padding(.vertical, 20)
                .background(.white)
                .drawingGroup()
            
            //MARK: relative wave
//                .visualEffect { content, geometryProxy in
//                    content
//                        .distortionEffect(ShaderLibrary.relativeWave(.float(time), .float2(geometryProxy.size)), maxSampleOffset: .zero)
//                }
            
            
        }
    }
}

#Preview {
    SecondExampleView()
}
