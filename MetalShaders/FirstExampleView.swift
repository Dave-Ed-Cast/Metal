//
//  ContentView.swift
//  MetalShaders
//
//  Created by Davide Castaldi on 04/05/24.
//

import SwiftUI

struct FirstExampleView: View {
    
    @State private var start: Date = Date.now
    var body: some View {
        VStack {
            //ignore this until the mark that says "easy part is over"
            
            TimelineView(.animation) { tl in
                //if you are here again, remember that the iphone can go up to 120Hz on the 15 pro max. So it's going to redraw 60 (or 120) times per second. To use that we need to create the timeline view with an animation
                
                let time = start.distance(to: tl.date)
                
                
                //normal image we want to change
                Image(systemName: "figure.walk.circle")
                    .font(.system(size: 300))
                    .foregroundStyle(.tint)
                
                //generally we can use the metal shader by saying .colorEffect(ShaderLibrary.function())
                //we use the color effect modifier, go through ShaderLibrary and look all the functions that match the name provided after the "."
                
                //MARK: uncomment what you want to see happen in the view, also keep in mind that the code is structured from easiest to hardest, plus you can use them all together
                
                //MARK: simply call a function that does nothing
//                    .colorEffect(ShaderLibrary.passthrough())
                
                //MARK: recolor the image
//                    .colorEffect(ShaderLibrary.recolor())
                
                //MARK: invert alpha the image
//                    .colorEffect(ShaderLibrary.invertAlpha())
                
                //MARK: gradientFill
//                    .colorEffect(ShaderLibrary.gradientFill())
                
                
                //MARK: *Easy part is over* now let's use more stuff
                
                //MARK: rainbow effect
//                    .colorEffect(ShaderLibrary.rainbow(.float(time)))
                
                //MARK: I lied, we can also call the metal library through another modifier:
//                    .distortionEffect(ShaderLibrary.wave(.float(time)), maxSampleOffset: .zero)
                
                //MARK: I lied, we can also call the metal library through another modifier:
                //read the "wave" function in the metal file
                    .padding(.vertical, 20)
                    .background(.white)
                    .drawingGroup()
                    .distortionEffect(ShaderLibrary.wave(.float(time)), maxSampleOffset: .zero)
            }
        }
    }
}

#Preview {
    FirstExampleView()
}
