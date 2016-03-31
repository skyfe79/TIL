//
//  Shader.fsh
//  RGBAShader
//
//  Created by Moses DeJong on 7/31/13.
//  This software has been placed in the public domain.
//
//  Simple pass through shader to render a texture

varying highp vec2 coordinate;
uniform sampler2D videoframe;
void main()
{
  gl_FragColor = texture2D(videoframe, coordinate);
}
