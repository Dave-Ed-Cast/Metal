//
//  MetalTesting.metal
//  MetalShaders
//
//  Created by Davide Castaldi on 04/05/24.
//

//MARK: Whenever we use metal there are two key rules to be followed
//MARK: 1st rule - SwiftUI (that does 95% of the work) looks for precise function signatures
//MARK: 2nd rule - Every metal function must be "Stitchable"

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/*
 stitchable is for the rule we said above, half is another variant of Float and Double, so it allocates a type to return, but half4 means a variant of Float and Double that corresponds to the RGB colors plus the alpha value. So that would be RGBA. then it needs a name, passthrough in our case, and a float2 which is x and y coordinates, again half4 color, and there is an option argument which is args, it can be a variadic functions that can have more values thanks to args
 
 Straight from documentation:
 
 where `position` is the user-space coordinates of the pixel
 /// applied to the shader and `color` its source color, as a
 /// pre-multiplied color in the destination color space. `args...`
 /// should be compatible with the uniform arguments bound to
 /// `shader`. The function should return the modified color value.
 ///
 /// > Important: Views backed by AppKit or UIKit views may not
 ///   render into the filtered layer. Instead, they log a warning
 ///   and display a placeholder image to highlight the error.
 ///
 /// - Parameters:
 ///   - shader: The shader to apply to `self` as a color filter.
 ///   - isEnabled: Whether the effect is enabled or not.
 ///
 /// - Returns: A new view that renders `self` with the shader
 ///   applied as a color filter.
 */

//MARK: one last thing: your metal shader cannot expand your view frame!

//this is a simple function decleration
[[stitchable]] half4 passthrough(float2 pos, half4 color) {
    return color;
}

//now we create a function that does a recolor by giving RGBA values.
[[stitchable]] half4 recolor(float2 pos, half4 color) {
    return half4(1, 0, 0, color.a);
    //the color.a means the current alpha value of the pixel reading. So it depends on what is reading
}

//this is converting alpha into its opposite. It means that if our image is a circle with a person all colored with blue, after using these 3 functions declared, we are going to take the red circle and person and color them white, and the thing that previously were the other color (so everything that was white) becomes red
//notice that of course we are talking about the size of the image, not the entire view!
[[stitchable]] half4 invertAlpha(float2 pos, half4 color) {
    return half4(1, 0, 0, 1 - color.a);
}

/*
 this should be easy to read, but let's comment it. Imagine a size 300x300, so we have up to 300 pixels on x and up to 300 pixels on y. By doing pos.x/pos.y, I am taking each and every x value and dividing for each and every y value.
 
 For example: 1x1, 1x2, 1x3, 1x4, ..., 1x300, 2x1, 2x2, 2x3, ...
 
 Then for the other field of the half4, simply do the opposite. Now look into the view and just appreciate how this simple math approach can work such magic
 */
[[stitchable]] half4 gradientFill(float2 pos, half4 color) {
    return half4(pos.x / pos.y, 0, pos.y / pos.x, color.a);
}

//MARK: Ok that was fairly easy, now let's use args and modifiers

/*
 We are going to use math and precisely atan2 to calculate the angular part of our view, so we can take the angular side of our image and color that part. Of coruse this is going to run in an animation, therefore by picking one angle, then summing numbers to that angle will result in a rainbow effect
 */
[[stitchable]] half4 rainbow(float2 pos, half4 color, float t) {
    
    float angle = atan2(pos.y, pos.x) + t;
    
    return half4(sin(angle), sin(angle + 2), sin(angle + 4), color.a);
}


//the wave effect is done creating a wave, but if you look at the output you will notice it working perfectly. Now, the reason I am highlighting this is because i took measures. Applying distortion could possibly mean that, while distorting, the image would go out of their bounds. To do so, we create a frame around the image that can contain it, so that it does not get clipped. Well it's easier done than said, trust me.
[[stitchable]] float2 wave(float2 pos, float t) {
    
    pos.y += sin(t * 5 + pos.y / 20) * 5;
    return pos;
}

//now there is a problem. Imagine a flag. The flag, with the waving effect, would be waving in a way that near the flagpole would be moving less, and the farther the piece of the flag is from the flagpole, the more it would move. To recreate this effect, we have to consider the distance between the flag pole, which will be our extra input, and divide it with pos in a way that is pos / s

//now there is one tiny problemino, which is... where the hell do we get the size? Well yes, it's an image so we can still tweak around it, but that is too complicated for something that should be easy to know. Plus, if it's a UI view element, we could not do it. But there is a modifier in swift which doesn't really tell us the size, but can let us use it anyway: .visualEffect comes with content, the view we are working with, and proxy, the geometry reader of the UI element giving us the size and the position of that.
[[stitchable]] float2 relativeWave(float2 pos, float t, float2 s) {
    
    float2 distance = pos / s;
    pos.y += sin(t * 5 + pos.y / 20) * distance.x * 5;
    return pos;
}

//MARK: this requires #include <SwiftUI/SwiftUI_Metal.h>
//this is another type of function that does
[[stitchable]] half4 loupe(float2 pos, SwiftUI::Layer l, float2 s, float2 touch) {
    
    //how much around our finger we want to zoom
    float maxDistance = 0.05;
    
    //the uv coordinate is a math graphic way to define axis... please do not let me expalin since i don't think i can in a few lines...
    float2 uv = pos / s;
    
    //self explained
    float2 center = touch / s;
    
    //another math concept. The little distance between two close points in a plane or space is called delta usually. We want to calculate the radius to zoom, therefore we need the distance
    float2 delta = uv - center;
    
    //self explained
    float aspectRatio = s.x / s.y;
    
    //good old Pythagoras that with a triangle literally created the basis of math
    //this was all to calculate the distance between our finger that touches from the actual pixel we are trying to draw with the function
    float distance = (delta.x * delta.x) + (delta.y * delta.y) / aspectRatio;
    
    float totalZoom = 1;
    
    //all because we need to say: if the distance we are touching is actually less than the maxDistance, redraw half of all the pixels around the finger. The result is that since we have an area around the finger, and we are halving the pixels, we are actually zooming because we are stretching the image
    if (distance < maxDistance) {
        totalZoom /= 2;
        
        //as the distance grows, undo the zoom
        totalZoom += distance * 2;
    }
    //with this i discovered i can play some sort of "discovery game". So this makes the image hidden, and when you click on the view it makes the zoomed area appear
    //        return l.sample(pos * s);
    
    //but the question arises: which pixels should be drawn inside the zoom, and which should be not? That's actually not hard. Remember we are pressing in one point of the screen, so we take the actual distance, multiply the zoom, and now the last problem is that the distance from the finger won't match, nothing that cannot be fixed by summing the actual center
    float2 newPos = delta * totalZoom + center;
    
    //to return the actual pixels we have to read, we simply do
    return l.sample(newPos * s);
}

//this is for fading images in a cool way
[[stitchable]] half4 circles(float2 pos, half4 color, float2 s, float amount) {
    
    //well first we get the positio
    float2 uv = pos / s;
    
    //we define the strength of it
    float strength = 20;
    
    //then we calculate the fractional part of these 2 values divided
    float2 f = fract(pos / strength);
    
    //then we define the distance, but this is the simple case where we use circles
    //float d = distance(f, 0.5);
    
    //we can use the diamond shape effect, which is simply, in a figurative way, moving first north then east, or north then west, or south then east etc..
    float d = abs (f.x - 0.5) + abs(f.y - 0.5);
    
    //then we check if the distance is less than the amount
    //if (d < amount) {
    
    //or for the diamond effect, plus we make it from top to bottom
    if (d + uv.x + uv.y < amount * 3) {
        //return the color
        return color;
    } else {
        //otherwise dont do anything
        return 0;
    }
}
