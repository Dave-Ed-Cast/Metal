//
//  FifthExampleView.swift
//  MetalShaders
//
//  Created by Davide Castaldi on 04/05/24.
//

import SwiftUI

struct FifthExampleView: View {
    
    @State private var start: Date = Date.now
    
    var body: some View {
        TimelineView(.animation) { tl in
            let time = start.distance(to: tl.date)
            Rectangle()
                .ignoresSafeArea()
            
            //MARK: sinebow
//                .visualEffect { content, geometryProxy in content.colorEffect(
//                    ShaderLibrary.sinebow(
//                        .float2(geometryProxy.size),
//                        .float (time)
//                    )
//                )
//            }
            //MARK: sineRainbow
//                .visualEffect{ content, geometryProxy in content.colorEffect(
//                    ShaderLibrary.sineRainbow(
//                        .float2(geometryProxy.size),
//                        .float (time)
//                    )
//                )
                    
            //MARK: newSineRainbow
//                .visualEffect{ content, geometryProxy in content.colorEffect(
//                    ShaderLibrary.newSineRainbow(
//                        .float2(geometryProxy.size),
//                        .float (time)
//                    )
//                )
                 
            //MARK: composedSineRainBow
//                .visualEffect{ content, geometryProxy in content.colorEffect(
//                    ShaderLibrary.composedSineRainbow(
//                        .float2(geometryProxy.size),
//                        .float (time)
//                    )
//                )
                  
            //MARK: another rainbow
                .visualEffect{ content, geometryProxy in content.colorEffect(
                    ShaderLibrary.rainbow(
                        .float2(geometryProxy.size),
                        .float (time)
                    )
                )
                }
        }
    }
}


#Preview {
    FifthExampleView()
}
