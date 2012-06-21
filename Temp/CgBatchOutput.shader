Shader "VertexLitWithVertColor" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 300
	
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 7 to 67
//   d3d9 - ALU: 7 to 67
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 32 ALU
PARAM c[19] = { { 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[9].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[13];
DP4 R2.y, R0, c[12];
DP4 R2.x, R0, c[11];
MUL R0.y, R3.w, R3.w;
MAD R0.y, R0.x, R0.x, -R0;
MOV result.texcoord[1].x, R0;
DP4 R3.z, R1, c[16];
DP4 R3.y, R1, c[15];
DP4 R3.x, R1, c[14];
MUL R1.xyz, R0.y, c[17];
ADD R2.xyz, R2, R3;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, R2, R1;
MOV result.color, vertex.color;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
ADD result.texcoord[3].xyz, -R0, c[10];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 32 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [_MainTex_ST]
"vs_2_0
; 32 ALU
def c18, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r1.xyz, v1, c8.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c18.x
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r3.w, r3.w
mad r0.y, r0.x, r0.x, -r0
mov oT1.x, r0
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
mul r1.xyz, r0.y, c16
add r2.xyz, r2, r3
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT2.xyz, r2, r1
mov oD0, v3
mov oT1.z, r2.w
mov oT1.y, r3.w
add oT3.xyz, -r0, c9
mad oT0.xy, v2, c17, c17.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (xlv_TEXCOORD3);
  mediump vec3 viewDir;
  viewDir = tmpvar_6;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_7;
  tmpvar_7 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, normalize ((_WorldSpaceLightPos0.xyz + viewDir))));
  nh = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_10;
  tmpvar_10 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_7) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_9)) * 2.0);
  c_i0.xyz = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = (tmpvar_5 + ((_LightColor0.w * _SpecColor.w) * tmpvar_9));
  c_i0.w = tmpvar_11;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (xlv_TEXCOORD3);
  mediump vec3 viewDir;
  viewDir = tmpvar_6;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_7;
  tmpvar_7 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, normalize ((_WorldSpaceLightPos0.xyz + viewDir))));
  nh = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_10;
  tmpvar_10 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_7) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_9)) * 2.0);
  c_i0.xyz = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = (tmpvar_5 + ((_LightColor0.w * _SpecColor.w) * tmpvar_9));
  c_i0.w = tmpvar_11;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [_MainTex_ST]
"agal_vs
c18 1.0 0.0 0.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaaiaaaappabaaaaaa mul r1.xyz, a1, c8.w
bcaaaaaaadaaaiacabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r1.xyzz, c5
bcaaaaaaacaaaiacabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c6
bcaaaaaaaaaaabacabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r0.x, r1.xyzz, c4
aaaaaaaaaaaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r3.w
aaaaaaaaaaaaaeacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.z, r2.w
adaaaaaaabaaapacaaaaaakeacaaaaaaaaaaaacjacaaaaaa mul r1, r0.xyzz, r0.yzzx
aaaaaaaaaaaaaiacbcaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c18.x
bdaaaaaaacaaaeacaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 r2.z, r0, c12
bdaaaaaaacaaacacaaaaaaoeacaaaaaaalaaaaoeabaaaaaa dp4 r2.y, r0, c11
bdaaaaaaacaaabacaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r2.x, r0, c10
adaaaaaaaaaaacacadaaaappacaaaaaaadaaaappacaaaaaa mul r0.y, r3.w, r3.w
adaaaaaaaeaaacacaaaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r4.y, r0.x, r0.x
acaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaffacaaaaaa sub r0.y, r4.y, r0.y
aaaaaaaaabaaabaeaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r0.x
bdaaaaaaadaaaeacabaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r3.z, r1, c15
bdaaaaaaadaaacacabaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r3.y, r1, c14
bdaaaaaaadaaabacabaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r3.x, r1, c13
adaaaaaaabaaahacaaaaaaffacaaaaaabaaaaaoeabaaaaaa mul r1.xyz, r0.y, c16
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
abaaaaaaacaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r2.xyzz, r1.xyzz
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
aaaaaaaaabaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r2.w
aaaaaaaaabaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r3.w
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
abaaaaaaadaaahaeaeaaaakeacaaaaaaajaaaaoeabaaaaaa add v3.xyz, r4.xyzz, c9
adaaaaaaaeaaadacadaaaaoeaaaaaaaabbaaaaoeabaaaaaa mul r4.xy, a3, c17
abaaaaaaaaaaadaeaeaaaafeacaaaaaabbaaaaooabaaaaaa add v0.xy, r4.xyyy, c17.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
"!!ARBvp1.0
# 7 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
MOV result.color, vertex.color;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 7 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_2_0
; 7 ALU
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_color0 v4
mov oD0, v4
mad oT0.xy, v2, c9, c9.zwzw
mad oT1.xy, v3, c8, c8.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = (tmpvar_2 * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz));
  c.w = (tmpvar_3.w * _Color.w);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  c.xyz = (tmpvar_2 * ((8.0 * tmpvar_5.w) * tmpvar_5.xyz));
  c.w = (tmpvar_3.w * _Color.w);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"agal_vs
[bc]
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
adaaaaaaaaaaadacadaaaaoeaaaaaaaaajaaaaoeabaaaaaa mul r0.xy, a3, c9
abaaaaaaaaaaadaeaaaaaafeacaaaaaaajaaaaooabaaaaaa add v0.xy, r0.xyyy, c9.zwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaaiaaaaoeabaaaaaa mul r0.xy, a4, c8
abaaaaaaabaaadaeaaaaaafeacaaaaaaaiaaaaooabaaaaaa add v1.xy, r0.xyyy, c8.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 20 ALU
PARAM c[17] = { { 1 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
MOV R0.xyz, c[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[13].w, -vertex.position;
DP3 result.texcoord[2].y, R0, R1;
DP3 result.texcoord[2].z, vertex.normal, R0;
DP3 result.texcoord[2].x, R0, vertex.attrib[14];
MOV result.color, vertex.color;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_2_0
; 21 ALU
def c16, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
mov r0.xyz, c13
mov r0.w, c16.x
dp4 r2.z, r0, c10
dp4 r2.x, r0, c8
dp4 r2.y, r0, c9
mad r0.xyz, r2, c12.w, -v0
dp3 oT2.y, r0, r1
dp3 oT2.z, v2, r0
dp3 oT2.x, r0, v1
mov oD0, v5
mad oT0.xy, v3, c15, c15.zwzw
mad oT1.xy, v4, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp mat3 tmpvar_3;
  tmpvar_3[0] = tmpvar_1.xyz;
  tmpvar_3[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_3[2] = tmpvar_2;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (tmpvar_4 * (((_World2Object * tmpvar_5).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  mediump vec4 tmpvar_6;
  mediump vec3 viewDir;
  viewDir = tmpvar_5;
  mediump vec3 specColor_i0;
  highp float nh;
  mediump vec3 scalePerBasisVector_i0;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_i0 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD1).xyz);
  scalePerBasisVector_i0 = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (vec3(0.0, 0.0, 1.0), normalize ((normalize ((((scalePerBasisVector_i0.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_i0.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_i0.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = pow (nh, (_Shininess * 128.0));
  highp vec3 tmpvar_11;
  tmpvar_11 = (((lm_i0 * _SpecColor.xyz) * tmpvar_3.w) * tmpvar_10);
  specColor_i0 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = lm_i0;
  tmpvar_12.w = tmpvar_10;
  tmpvar_6 = tmpvar_12;
  c.xyz = specColor_i0;
  mediump vec3 tmpvar_13;
  tmpvar_13 = (c.xyz + (tmpvar_2 * tmpvar_6.xyz));
  c.xyz = tmpvar_13;
  c.w = (tmpvar_3.w * _Color.w);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp mat3 tmpvar_3;
  tmpvar_3[0] = tmpvar_1.xyz;
  tmpvar_3[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_3[2] = tmpvar_2;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (tmpvar_4 * (((_World2Object * tmpvar_5).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (unity_LightmapInd, xlv_TEXCOORD1);
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (xlv_TEXCOORD2);
  mediump vec4 tmpvar_8;
  mediump vec3 viewDir;
  viewDir = tmpvar_7;
  mediump vec3 specColor_i0;
  highp float nh;
  mediump vec3 scalePerBasisVector_i0;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((8.0 * tmpvar_5.w) * tmpvar_5.xyz);
  lm_i0 = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((8.0 * tmpvar_6.w) * tmpvar_6.xyz);
  scalePerBasisVector_i0 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (vec3(0.0, 0.0, 1.0), normalize ((normalize ((((scalePerBasisVector_i0.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_i0.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_i0.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir))));
  nh = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = pow (nh, (_Shininess * 128.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (((lm_i0 * _SpecColor.xyz) * tmpvar_3.w) * tmpvar_12);
  specColor_i0 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = lm_i0;
  tmpvar_14.w = tmpvar_12;
  tmpvar_8 = tmpvar_14;
  c.xyz = specColor_i0;
  mediump vec3 tmpvar_15;
  tmpvar_15 = (c.xyz + (tmpvar_2 * tmpvar_8.xyz));
  c.xyz = tmpvar_15;
  c.w = (tmpvar_3.w * _Color.w);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"agal_vs
c16 1.0 0.0 0.0 0.0
[bc]
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaacaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r2.xyz, a1.yzxw, r0.zxyy
acaaaaaaaaaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaakeacaaaaaaafaaaappaaaaaaaa mul r1.xyz, r0.xyzz, a5.w
aaaaaaaaaaaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, c13
aaaaaaaaaaaaaiacbaaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c16.x
bdaaaaaaacaaaeacaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r2.z, r0, c10
bdaaaaaaacaaabacaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r2.x, r0, c8
bdaaaaaaacaaacacaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r2.y, r0, c9
adaaaaaaacaaahacacaaaakeacaaaaaaamaaaappabaaaaaa mul r2.xyz, r2.xyzz, c12.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bcaaaaaaacaaacaeaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 v2.y, r0.xyzz, r1.xyzz
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 v2.z, a1, r0.xyzz
bcaaaaaaacaaabaeaaaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v2.x, r0.xyzz, a5
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
adaaaaaaaaaaadacadaaaaoeaaaaaaaaapaaaaoeabaaaaaa mul r0.xy, a3, c15
abaaaaaaaaaaadaeaaaaaafeacaaaaaaapaaaaooabaaaaaa add v0.xy, r0.xyyy, c15.zwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r0.xy, a4, c14
abaaaaaaabaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v1.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Vector 12 [unity_SHAr]
Vector 13 [unity_SHAg]
Vector 14 [unity_SHAb]
Vector 15 [unity_SHBr]
Vector 16 [unity_SHBg]
Vector 17 [unity_SHBb]
Vector 18 [unity_SHC]
Vector 19 [_MainTex_ST]
"!!ARBvp1.0
# 37 ALU
PARAM c[20] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..19] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal, c[10].w;
DP3 R3.w, R0, c[6];
DP3 R2.w, R0, c[7];
DP3 R1.w, R0, c[5];
MOV R1.x, R3.w;
MOV R1.y, R2.w;
MOV R1.z, c[0].x;
MUL R0, R1.wxyy, R1.xyyw;
DP4 R2.z, R1.wxyz, c[14];
DP4 R2.y, R1.wxyz, c[13];
DP4 R2.x, R1.wxyz, c[12];
DP4 R1.z, R0, c[17];
DP4 R1.y, R0, c[16];
DP4 R1.x, R0, c[15];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[18];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MOV result.position, R0;
MUL R1.y, R1, c[9].x;
MOV result.texcoord[4].zw, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.color, vertex.color;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R1.w;
ADD result.texcoord[3].xyz, -R0, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[19], c[19].zwzw;
END
# 37 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [unity_SHAr]
Vector 13 [unity_SHAg]
Vector 14 [unity_SHAb]
Vector 15 [unity_SHBr]
Vector 16 [unity_SHBg]
Vector 17 [unity_SHBb]
Vector 18 [unity_SHC]
Vector 19 [_MainTex_ST]
"vs_2_0
; 37 ALU
def c20, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r0.xyz, v1, c10.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c20.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c14
dp4 r2.y, r1.wxyz, c13
dp4 r2.x, r1.wxyz, c12
dp4 r1.z, r0, c17
dp4 r1.y, r0, c16
dp4 r1.x, r0, c15
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c18
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c20.y
mov oPos, r0
mul r1.y, r1, c8.x
mov oT4.zw, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT2.xyz, r3, r2
mad oT4.xy, r1.z, c9.zwzw, r1
mov oD0, v3
mov oT1.z, r2.w
mov oT1.y, r3.w
mov oT1.x, r1.w
add oT3.xyz, -r0, c11
mad oT0.xy, v2, c19, c19.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (xlv_TEXCOORD3);
  mediump vec3 viewDir;
  viewDir = tmpvar_7;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize ((_WorldSpaceLightPos0.xyz + viewDir))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_10)) * (tmpvar_6.x * 2.0));
  c_i0.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_10) * tmpvar_6.x));
  c_i0.w = tmpvar_12;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (xlv_TEXCOORD3);
  mediump vec3 viewDir;
  viewDir = tmpvar_7;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize ((_WorldSpaceLightPos0.xyz + viewDir))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_10)) * (tmpvar_6.x * 2.0));
  c_i0.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_10) * tmpvar_6.x));
  c_i0.w = tmpvar_12;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [unity_SHAr]
Vector 13 [unity_SHAg]
Vector 14 [unity_SHAb]
Vector 15 [unity_SHBr]
Vector 16 [unity_SHBg]
Vector 17 [unity_SHBb]
Vector 18 [unity_SHC]
Vector 19 [_MainTex_ST]
"agal_vs
c20 1.0 0.5 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaoeaaaaaaaaakaaaappabaaaaaa mul r0.xyz, a1, c10.w
bcaaaaaaadaaaiacaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r0.xyzz, c5
bcaaaaaaacaaaiacaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r0.xyzz, c6
bcaaaaaaabaaaiacaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r1.w, r0.xyzz, c4
aaaaaaaaabaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.w
aaaaaaaaabaaacacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r2.w
aaaaaaaaabaaaeacbeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.z, c20.x
adaaaaaaaaaaapacabaaaafdacaaaaaaabaaaaneacaaaaaa mul r0, r1.wxyy, r1.xyyw
bdaaaaaaacaaaeacabaaaajdacaaaaaaaoaaaaoeabaaaaaa dp4 r2.z, r1.wxyz, c14
bdaaaaaaacaaacacabaaaajdacaaaaaaanaaaaoeabaaaaaa dp4 r2.y, r1.wxyz, c13
bdaaaaaaacaaabacabaaaajdacaaaaaaamaaaaoeabaaaaaa dp4 r2.x, r1.wxyz, c12
bdaaaaaaabaaaeacaaaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r1.z, r0, c17
bdaaaaaaabaaacacaaaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r1.y, r0, c16
bdaaaaaaabaaabacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r1.x, r0, c15
adaaaaaaadaaabacadaaaappacaaaaaaadaaaappacaaaaaa mul r3.x, r3.w, r3.w
adaaaaaaaeaaabacabaaaappacaaaaaaabaaaappacaaaaaa mul r4.x, r1.w, r1.w
acaaaaaaaaaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa sub r0.x, r4.x, r3.x
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaaaaacaaaaaabcaaaaoeabaaaaaa mul r1.xyz, r0.x, c18
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaadaaahacaaaaaapeacaaaaaabeaaaaffabaaaaaa mul r3.xyz, r0.xyww, c20.y
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
abaaaaaaacaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r2.xyzz, r1.xyzz
aaaaaaaaaeaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, r0.wwzw
adaaaaaaabaaacacadaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r3.y, c8.x
aaaaaaaaabaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.x
abaaaaaaabaaadacabaaaafeacaaaaaaadaaaakkacaaaaaa add r1.xy, r1.xyyy, r3.z
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
adaaaaaaaeaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v4.xy, r1.xyyy, c9
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
aaaaaaaaabaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r2.w
aaaaaaaaabaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r3.w
aaaaaaaaabaaabaeabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r1.w
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
abaaaaaaadaaahaeaeaaaakeacaaaaaaalaaaaoeabaaaaaa add v3.xyz, r4.xyzz, c11
adaaaaaaaeaaadacadaaaaoeaaaaaaaabdaaaaoeabaaaaaa mul r4.xy, a3, c19
abaaaaaaaaaaadaeaeaaaafeacaaaaaabdaaaaooabaaaaaa add v0.xy, r4.xyyy, c19.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 12 ALU
PARAM c[12] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV result.color, vertex.color;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 12 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_2_0
; 12 ALU
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_color0 v4
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mul r1.y, r1, c8.x
mad oT2.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oD0, v4
mov oT2.zw, r0
mad oT0.xy, v2, c11, c11.zwzw
mad oT1.xy, v3, c10, c10.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = (tmpvar_2 * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz), vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x * 2.0))));
  c.w = (tmpvar_3.w * _Color.w);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((8.0 * tmpvar_6.w) * tmpvar_6.xyz);
  c.xyz = (tmpvar_2 * max (min (tmpvar_7, ((tmpvar_5.x * 2.0) * tmpvar_6.xyz)), (tmpvar_7 * tmpvar_5.x)));
  c.w = (tmpvar_3.w * _Color.w);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"agal_vs
c12 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaabaaahacaaaaaapeacaaaaaaamaaaaaaabaaaaaa mul r1.xyz, r0.xyww, c12.x
adaaaaaaabaaacacabaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r1.y, c8.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
adaaaaaaacaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v2.xy, r1.xyyy, c9
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
aaaaaaaaacaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, r0.wwzw
adaaaaaaaaaaadacadaaaaoeaaaaaaaaalaaaaoeabaaaaaa mul r0.xy, a3, c11
abaaaaaaaaaaadaeaaaaaafeacaaaaaaalaaaaooabaaaaaa add v0.xy, r0.xyyy, c11.zwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r0.xy, a4, c10
abaaaaaaabaaadaeaaaaaafeacaaaaaaakaaaaooabaaaaaa add v1.xy, r0.xyyy, c10.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Vector 13 [_ProjectionParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"!!ARBvp1.0
# 25 ALU
PARAM c[18] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R0.xyz, R0, vertex.attrib[14].w;
MOV R1.xyz, c[15];
MOV R1.w, c[0].x;
DP4 R0.w, vertex.position, c[4];
DP4 R2.z, R1, c[11];
DP4 R2.x, R1, c[9];
DP4 R2.y, R1, c[10];
MAD R2.xyz, R2, c[14].w, -vertex.position;
DP3 result.texcoord[2].y, R2, R0;
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, R2, vertex.attrib[14];
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.color, vertex.color;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[16], c[16].zwzw;
END
# 25 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"vs_2_0
; 26 ALU
def c18, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r0.xyz, r0, v1.w
mov r1.xyz, c15
mov r1.w, c18.x
dp4 r0.w, v0, c3
dp4 r2.z, r1, c10
dp4 r2.x, r1, c8
dp4 r2.y, r1, c9
mad r2.xyz, r2, c14.w, -v0
dp3 oT2.y, r2, r0
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c18.y
mul r1.y, r1, c12.x
dp3 oT2.z, v2, r2
dp3 oT2.x, r2, v1
mad oT3.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov oD0, v5
mov oT3.zw, r0
mad oT0.xy, v3, c17, c17.zwzw
mad oT1.xy, v4, c16, c16.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_8 + tmpvar_7.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (tmpvar_5 * (((_World2Object * tmpvar_6).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize (xlv_TEXCOORD2);
  mediump vec4 tmpvar_6;
  mediump vec3 viewDir;
  viewDir = tmpvar_5;
  mediump vec3 specColor_i0;
  highp float nh;
  mediump vec3 scalePerBasisVector_i0;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_i0 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD1).xyz);
  scalePerBasisVector_i0 = tmpvar_8;
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (vec3(0.0, 0.0, 1.0), normalize ((normalize ((((scalePerBasisVector_i0.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_i0.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_i0.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = pow (nh, (_Shininess * 128.0));
  highp vec3 tmpvar_11;
  tmpvar_11 = (((lm_i0 * _SpecColor.xyz) * tmpvar_3.w) * tmpvar_10);
  specColor_i0 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = lm_i0;
  tmpvar_12.w = tmpvar_10;
  tmpvar_6 = tmpvar_12;
  c.xyz = specColor_i0;
  lowp vec3 tmpvar_13;
  tmpvar_13 = vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x * 2.0));
  mediump vec3 tmpvar_14;
  tmpvar_14 = (c.xyz + (tmpvar_2 * min (tmpvar_6.xyz, tmpvar_13)));
  c.xyz = tmpvar_14;
  c.w = (tmpvar_3.w * _Color.w);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp mat3 tmpvar_4;
  tmpvar_4[0] = tmpvar_1.xyz;
  tmpvar_4[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_4[2] = tmpvar_2;
  mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_4[0].x;
  tmpvar_5[0].y = tmpvar_4[1].x;
  tmpvar_5[0].z = tmpvar_4[2].x;
  tmpvar_5[1].x = tmpvar_4[0].y;
  tmpvar_5[1].y = tmpvar_4[1].y;
  tmpvar_5[1].z = tmpvar_4[2].y;
  tmpvar_5[2].x = tmpvar_4[0].z;
  tmpvar_5[2].y = tmpvar_4[1].z;
  tmpvar_5[2].z = tmpvar_4[2].z;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec4 o_i0;
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7.x;
  tmpvar_8.y = (tmpvar_7.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_8 + tmpvar_7.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (tmpvar_5 * (((_World2Object * tmpvar_6).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_LightmapInd, xlv_TEXCOORD1);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD2);
  mediump vec4 tmpvar_9;
  mediump vec3 viewDir;
  viewDir = tmpvar_8;
  mediump vec3 specColor_i0;
  highp float nh;
  mediump vec3 scalePerBasisVector_i0;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((8.0 * tmpvar_6.w) * tmpvar_6.xyz);
  lm_i0 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((8.0 * tmpvar_7.w) * tmpvar_7.xyz);
  scalePerBasisVector_i0 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (vec3(0.0, 0.0, 1.0), normalize ((normalize ((((scalePerBasisVector_i0.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_i0.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_i0.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir))));
  nh = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = pow (nh, (_Shininess * 128.0));
  highp vec3 tmpvar_14;
  tmpvar_14 = (((lm_i0 * _SpecColor.xyz) * tmpvar_3.w) * tmpvar_13);
  specColor_i0 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = lm_i0;
  tmpvar_15.w = tmpvar_13;
  tmpvar_9 = tmpvar_15;
  c.xyz = specColor_i0;
  mediump vec3 tmpvar_16;
  tmpvar_16 = (c.xyz + (tmpvar_2 * max (min (tmpvar_9.xyz, ((tmpvar_5.x * 2.0) * tmpvar_6.xyz)), (tmpvar_9.xyz * tmpvar_5.x))));
  c.xyz = tmpvar_16;
  c.w = (tmpvar_3.w * _Color.w);
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [unity_NPOTScale]
Vector 14 [unity_Scale]
Vector 15 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 16 [unity_LightmapST]
Vector 17 [_MainTex_ST]
"agal_vs
c18 1.0 0.5 0.0 0.0
[bc]
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaacaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r2.xyz, a1.yzxw, r0.zxyy
acaaaaaaaaaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaafaaaappaaaaaaaa mul r0.xyz, r0.xyzz, a5.w
aaaaaaaaabaaahacapaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c15
aaaaaaaaabaaaiacbcaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c18.x
bdaaaaaaacaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r2.z, r1, c10
bdaaaaaaacaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r2.x, r1, c8
bdaaaaaaacaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r2.y, r1, c9
adaaaaaaadaaahacacaaaakeacaaaaaaaoaaaappabaaaaaa mul r3.xyz, r2.xyzz, c14.w
acaaaaaaabaaahacadaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r3.xyzz, a0
bcaaaaaaacaaacaeabaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 v2.y, r1.xyzz, r0.xyzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bcaaaaaaacaaaeaeabaaaaoeaaaaaaaaabaaaakeacaaaaaa dp3 v2.z, a1, r1.xyzz
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaacaaahacaaaaaapeacaaaaaabcaaaaffabaaaaaa mul r2.xyz, r0.xyww, c18.y
bcaaaaaaacaaabaeabaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v2.x, r1.xyzz, a5
adaaaaaaabaaacacacaaaaffacaaaaaaamaaaaaaabaaaaaa mul r1.y, r2.y, c12.x
aaaaaaaaabaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r2.x
abaaaaaaabaaadacabaaaafeacaaaaaaacaaaakkacaaaaaa add r1.xy, r1.xyyy, r2.z
adaaaaaaadaaadaeabaaaafeacaaaaaaanaaaaoeabaaaaaa mul v3.xy, r1.xyyy, c13
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
aaaaaaaaadaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, r0.wwzw
adaaaaaaadaaadacadaaaaoeaaaaaaaabbaaaaoeabaaaaaa mul r3.xy, a3, c17
abaaaaaaaaaaadaeadaaaafeacaaaaaabbaaaaooabaaaaaa add v0.xy, r3.xyyy, c17.zwzw
adaaaaaaadaaadacaeaaaaoeaaaaaaaabaaaaaoeabaaaaaa mul r3.xy, a4, c16
abaaaaaaabaaadaeadaaaafeacaaaaaabaaaaaooabaaaaaa add v1.xy, r3.xyyy, c16.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Vector 26 [_MainTex_ST]
"!!ARBvp1.0
# 61 ALU
PARAM c[27] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[9].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[12];
DP3 R4.z, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[11];
DP4 R4.xy, vertex.position, c[7];
MUL R2, R2, R2;
MOV R5.z, R3.x;
MOV R5.y, R4.z;
MOV R5.w, c[0].x;
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[13];
MAD R2, R1, R1, R2;
MAD R0, R3.x, R1, R0;
MUL R1, R2, c[14];
ADD R1, R1, c[0].x;
MOV result.texcoord[1].z, R3.x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[21];
DP4 R2.y, R5, c[20];
DP4 R2.x, R5, c[19];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[16];
MAD R1.xyz, R0.x, c[15], R1;
MAD R0.xyz, R0.z, c[17], R1;
MAD R1.xyz, R0.w, c[18], R0;
MUL R0, R5.xyzz, R5.yzzx;
MUL R1.w, R4.z, R4.z;
DP4 R5.w, R0, c[24];
DP4 R5.z, R0, c[23];
DP4 R5.y, R0, c[22];
MAD R1.w, R5.x, R5.x, -R1;
MUL R0.xyz, R1.w, c[25];
ADD R2.xyz, R2, R5.yzww;
ADD R0.xyz, R2, R0;
MOV R3.x, R4.w;
MOV R3.y, R4;
ADD result.texcoord[2].xyz, R0, R1;
MOV result.color, vertex.color;
MOV result.texcoord[1].y, R4.z;
MOV result.texcoord[1].x, R5;
ADD result.texcoord[3].xyz, -R3.wxyw, c[10];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[26], c[26].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 61 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [_MainTex_ST]
"vs_2_0
; 61 ALU
def c26, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r3.xyz, v1, c8.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c11
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c10
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c26.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c12
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c13
add r1, r1, c26.x
mov oT1.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c20
dp4 r2.y, r5, c19
dp4 r2.x, r5, c18
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c26.y
mul r0, r0, r1
mul r1.xyz, r0.y, c15
mad r1.xyz, r0.x, c14, r1
mad r0.xyz, r0.z, c16, r1
mad r1.xyz, r0.w, c17, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c23
dp4 r5.z, r0, c22
dp4 r5.y, r0, c21
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c24
add r2.xyz, r2, r5.yzww
add r0.xyz, r2, r0
mov r3.x, r4.w
mov r3.y, r4
add oT2.xyz, r0, r1
mov oD0, v3
mov oT1.y, r4.z
mov oT1.x, r5
add oT3.xyz, -r3.wxyw, c9
mad oT0.xy, v2, c25, c25.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosX0 - tmpvar_16.x);
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosY0 - tmpvar_16.y);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosZ0 - tmpvar_16.z);
  highp vec4 tmpvar_20;
  tmpvar_20 = (((tmpvar_17 * tmpvar_17) + (tmpvar_18 * tmpvar_18)) + (tmpvar_19 * tmpvar_19));
  highp vec4 tmpvar_21;
  tmpvar_21 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_17 * tmpvar_4.x) + (tmpvar_18 * tmpvar_4.y)) + (tmpvar_19 * tmpvar_4.z)) * inversesqrt (tmpvar_20))) * (1.0/((1.0 + (tmpvar_20 * unity_4LightAtten0)))));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_21.x) + (unity_LightColor[1].xyz * tmpvar_21.y)) + (unity_LightColor[2].xyz * tmpvar_21.z)) + (unity_LightColor[3].xyz * tmpvar_21.w)));
  tmpvar_2 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (xlv_TEXCOORD3);
  mediump vec3 viewDir;
  viewDir = tmpvar_6;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_7;
  tmpvar_7 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, normalize ((_WorldSpaceLightPos0.xyz + viewDir))));
  nh = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_10;
  tmpvar_10 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_7) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_9)) * 2.0);
  c_i0.xyz = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = (tmpvar_5 + ((_LightColor0.w * _SpecColor.w) * tmpvar_9));
  c_i0.w = tmpvar_11;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosX0 - tmpvar_16.x);
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosY0 - tmpvar_16.y);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosZ0 - tmpvar_16.z);
  highp vec4 tmpvar_20;
  tmpvar_20 = (((tmpvar_17 * tmpvar_17) + (tmpvar_18 * tmpvar_18)) + (tmpvar_19 * tmpvar_19));
  highp vec4 tmpvar_21;
  tmpvar_21 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_17 * tmpvar_4.x) + (tmpvar_18 * tmpvar_4.y)) + (tmpvar_19 * tmpvar_4.z)) * inversesqrt (tmpvar_20))) * (1.0/((1.0 + (tmpvar_20 * unity_4LightAtten0)))));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_21.x) + (unity_LightColor[1].xyz * tmpvar_21.y)) + (unity_LightColor[2].xyz * tmpvar_21.z)) + (unity_LightColor[3].xyz * tmpvar_21.w)));
  tmpvar_2 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize (xlv_TEXCOORD3);
  mediump vec3 viewDir;
  viewDir = tmpvar_6;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_7;
  tmpvar_7 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, normalize ((_WorldSpaceLightPos0.xyz + viewDir))));
  nh = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_10;
  tmpvar_10 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_7) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_9)) * 2.0);
  c_i0.xyz = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = (tmpvar_5 + ((_LightColor0.w * _SpecColor.w) * tmpvar_9));
  c_i0.w = tmpvar_11;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [_MainTex_ST]
"agal_vs
c26 1.0 0.0 0.0 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaaaiaaaappabaaaaaa mul r3.xyz, a1, c8.w
bcaaaaaaafaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.x, r3.xyzz, c4
bdaaaaaaaeaaamacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r4.zw, a0, c5
bfaaaaaaacaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r2.z, r4.z
abaaaaaaacaaapacacaaaakkacaaaaaaalaaaaoeabaaaaaa add r2, r2.z, c11
bcaaaaaaaeaaaeacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.z, r3.xyzz, c5
bcaaaaaaadaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.x, r3.xyzz, c6
bdaaaaaaadaaaiacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r3.w, a0, c4
adaaaaaaaaaaapacaeaaaakkacaaaaaaacaaaaoeacaaaaaa mul r0, r4.z, r2
bfaaaaaaabaaaiacadaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r3.w
abaaaaaaabaaapacabaaaappacaaaaaaakaaaaoeabaaaaaa add r1, r1.w, c10
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
aaaaaaaaafaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r5.z, r3.x
aaaaaaaaafaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.y, r4.z
aaaaaaaaafaaaiacbkaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r5.w, c26.x
adaaaaaaagaaapacafaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r5.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaaamaaaaoeabaaaaaa add r1, r1.x, c12
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
adaaaaaaagaaapacadaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r3.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaabaaapacacaaaaoeacaaaaaaanaaaaoeabaaaaaa mul r1, r2, c13
abaaaaaaabaaapacabaaaaoeacaaaaaabkaaaaaaabaaaaaa add r1, r1, c26.x
aaaaaaaaabaaaeaeadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r3.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
bdaaaaaaacaaaeacafaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r2.z, r5, c20
bdaaaaaaacaaacacafaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r2.y, r5, c19
bdaaaaaaacaaabacafaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r2.x, r5, c18
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaabkaaaaffabaaaaaa max r0, r0, c26.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaaapaaaaoeabaaaaaa mul r1.xyz, r0.y, c15
adaaaaaaagaaahacaaaaaaaaacaaaaaaaoaaaaoeabaaaaaa mul r6.xyz, r0.x, c14
abaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r6.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaabaaaaaoeabaaaaaa mul r0.xyz, r0.z, c16
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabbaaaaoeabaaaaaa mul r1.xyz, r0.w, c17
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacafaaaakeacaaaaaaafaaaacjacaaaaaa mul r0, r5.xyzz, r5.yzzx
adaaaaaaabaaaiacaeaaaakkacaaaaaaaeaaaakkacaaaaaa mul r1.w, r4.z, r4.z
bdaaaaaaafaaaiacaaaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r5.w, r0, c23
bdaaaaaaafaaaeacaaaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r5.z, r0, c22
bdaaaaaaafaaacacaaaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r5.y, r0, c21
adaaaaaaagaaaiacafaaaaaaacaaaaaaafaaaaaaacaaaaaa mul r6.w, r5.x, r5.x
acaaaaaaabaaaiacagaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r6.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabiaaaaoeabaaaaaa mul r0.xyz, r1.w, c24
abaaaaaaacaaahacacaaaakeacaaaaaaafaaaapjacaaaaaa add r2.xyz, r2.xyzz, r5.yzww
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.y
abaaaaaaacaaahaeaaaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r0.xyzz, r1.xyzz
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
aaaaaaaaabaaacaeaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r4.z
aaaaaaaaabaaabaeafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r5.x
bfaaaaaaagaaalacadaaaapdacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyw, r3.wxww
abaaaaaaadaaahaeagaaaafdacaaaaaaajaaaaoeabaaaaaa add v3.xyz, r6.wxyy, c9
adaaaaaaagaaadacadaaaaoeaaaaaaaabjaaaaoeabaaaaaa mul r6.xy, a3, c25
abaaaaaaaaaaadaeagaaaafeacaaaaaabjaaaaooabaaaaaa add v0.xy, r6.xyyy, c25.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Vector 12 [unity_4LightPosX0]
Vector 13 [unity_4LightPosY0]
Vector 14 [unity_4LightPosZ0]
Vector 15 [unity_4LightAtten0]
Vector 16 [unity_LightColor0]
Vector 17 [unity_LightColor1]
Vector 18 [unity_LightColor2]
Vector 19 [unity_LightColor3]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Vector 27 [_MainTex_ST]
"!!ARBvp1.0
# 67 ALU
PARAM c[28] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..27] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[10].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[13];
DP3 R4.z, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[12];
DP4 R4.xy, vertex.position, c[7];
MUL R2, R2, R2;
MOV R5.z, R3.x;
MOV R5.y, R4.z;
MOV R5.w, c[0].x;
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[14];
MAD R2, R1, R1, R2;
MAD R0, R3.x, R1, R0;
MUL R1, R2, c[15];
ADD R1, R1, c[0].x;
MOV result.texcoord[1].z, R3.x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[22];
DP4 R2.y, R5, c[21];
DP4 R2.x, R5, c[20];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[17];
MAD R1.xyz, R0.x, c[16], R1;
MAD R0.xyz, R0.z, c[18], R1;
MAD R1.xyz, R0.w, c[19], R0;
MUL R0, R5.xyzz, R5.yzzx;
MUL R1.w, R4.z, R4.z;
DP4 R5.w, R0, c[25];
DP4 R5.z, R0, c[24];
DP4 R5.y, R0, c[23];
MAD R1.w, R5.x, R5.x, -R1;
MUL R0.xyz, R1.w, c[26];
ADD R2.xyz, R2, R5.yzww;
ADD R5.yzw, R2.xxyz, R0.xxyz;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[2].xyz, R5.yzww, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[9].x;
MOV R3.x, R4.w;
MOV R3.y, R4;
ADD result.texcoord[4].xy, R1, R2.z;
MOV result.position, R0;
MOV result.color, vertex.color;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[1].y, R4.z;
MOV result.texcoord[1].x, R5;
ADD result.texcoord[3].xyz, -R3.wxyw, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[27], c[27].zwzw;
END
# 67 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [unity_4LightPosX0]
Vector 13 [unity_4LightPosY0]
Vector 14 [unity_4LightPosZ0]
Vector 15 [unity_4LightAtten0]
Vector 16 [unity_LightColor0]
Vector 17 [unity_LightColor1]
Vector 18 [unity_LightColor2]
Vector 19 [unity_LightColor3]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Vector 27 [_MainTex_ST]
"vs_2_0
; 67 ALU
def c28, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r3.xyz, v1, c10.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c13
dp3 r4.z, r3, c5
dp3 r3.x, r3, c6
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c12
dp4 r4.xy, v0, c6
mul r2, r2, r2
mov r5.z, r3.x
mov r5.y, r4.z
mov r5.w, c28.x
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c14
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c15
add r1, r1, c28.x
mov oT1.z, r3.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c22
dp4 r2.y, r5, c21
dp4 r2.x, r5, c20
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c28.y
mul r0, r0, r1
mul r1.xyz, r0.y, c17
mad r1.xyz, r0.x, c16, r1
mad r0.xyz, r0.z, c18, r1
mad r1.xyz, r0.w, c19, r0
mul r0, r5.xyzz, r5.yzzx
mul r1.w, r4.z, r4.z
dp4 r5.w, r0, c25
dp4 r5.z, r0, c24
dp4 r5.y, r0, c23
mad r1.w, r5.x, r5.x, -r1
mul r0.xyz, r1.w, c26
add r2.xyz, r2, r5.yzww
add r5.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c28.z
add oT2.xyz, r5.yzww, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mov r3.x, r4.w
mov r3.y, r4
mad oT4.xy, r2.z, c9.zwzw, r1
mov oPos, r0
mov oD0, v3
mov oT4.zw, r0
mov oT1.y, r4.z
mov oT1.x, r5
add oT3.xyz, -r3.wxyw, c11
mad oT0.xy, v2, c27, c27.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_17;
  tmpvar_17 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosX0 - tmpvar_17.x);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosY0 - tmpvar_17.y);
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_4LightPosZ0 - tmpvar_17.z);
  highp vec4 tmpvar_21;
  tmpvar_21 = (((tmpvar_18 * tmpvar_18) + (tmpvar_19 * tmpvar_19)) + (tmpvar_20 * tmpvar_20));
  highp vec4 tmpvar_22;
  tmpvar_22 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_18 * tmpvar_5.x) + (tmpvar_19 * tmpvar_5.y)) + (tmpvar_20 * tmpvar_5.z)) * inversesqrt (tmpvar_21))) * (1.0/((1.0 + (tmpvar_21 * unity_4LightAtten0)))));
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_22.x) + (unity_LightColor[1].xyz * tmpvar_22.y)) + (unity_LightColor[2].xyz * tmpvar_22.z)) + (unity_LightColor[3].xyz * tmpvar_22.w)));
  tmpvar_2 = tmpvar_23;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (xlv_TEXCOORD3);
  mediump vec3 viewDir;
  viewDir = tmpvar_7;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize ((_WorldSpaceLightPos0.xyz + viewDir))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_10)) * (tmpvar_6.x * 2.0));
  c_i0.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_10) * tmpvar_6.x));
  c_i0.w = tmpvar_12;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_17;
  tmpvar_17 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosX0 - tmpvar_17.x);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosY0 - tmpvar_17.y);
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_4LightPosZ0 - tmpvar_17.z);
  highp vec4 tmpvar_21;
  tmpvar_21 = (((tmpvar_18 * tmpvar_18) + (tmpvar_19 * tmpvar_19)) + (tmpvar_20 * tmpvar_20));
  highp vec4 tmpvar_22;
  tmpvar_22 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_18 * tmpvar_5.x) + (tmpvar_19 * tmpvar_5.y)) + (tmpvar_20 * tmpvar_5.z)) * inversesqrt (tmpvar_21))) * (1.0/((1.0 + (tmpvar_21 * unity_4LightAtten0)))));
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_22.x) + (unity_LightColor[1].xyz * tmpvar_22.y)) + (unity_LightColor[2].xyz * tmpvar_22.z)) + (unity_LightColor[3].xyz * tmpvar_22.w)));
  tmpvar_2 = tmpvar_23;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD4 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4);
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (xlv_TEXCOORD3);
  mediump vec3 viewDir;
  viewDir = tmpvar_7;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize ((_WorldSpaceLightPos0.xyz + viewDir))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_10)) * (tmpvar_6.x * 2.0));
  c_i0.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_10) * tmpvar_6.x));
  c_i0.w = tmpvar_12;
  c = c_i0;
  c.xyz = (c_i0.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Vector 12 [unity_4LightPosX0]
Vector 13 [unity_4LightPosY0]
Vector 14 [unity_4LightPosZ0]
Vector 15 [unity_4LightAtten0]
Vector 16 [unity_LightColor0]
Vector 17 [unity_LightColor1]
Vector 18 [unity_LightColor2]
Vector 19 [unity_LightColor3]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Vector 27 [_MainTex_ST]
"agal_vs
c28 1.0 0.0 0.5 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaaakaaaappabaaaaaa mul r3.xyz, a1, c10.w
bcaaaaaaafaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.x, r3.xyzz, c4
bdaaaaaaaeaaamacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r4.zw, a0, c5
bfaaaaaaacaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r2.z, r4.z
abaaaaaaacaaapacacaaaakkacaaaaaaanaaaaoeabaaaaaa add r2, r2.z, c13
bcaaaaaaaeaaaeacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.z, r3.xyzz, c5
bcaaaaaaadaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.x, r3.xyzz, c6
bdaaaaaaadaaaiacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r3.w, a0, c4
adaaaaaaaaaaapacaeaaaakkacaaaaaaacaaaaoeacaaaaaa mul r0, r4.z, r2
bfaaaaaaabaaaiacadaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r3.w
abaaaaaaabaaapacabaaaappacaaaaaaamaaaaoeabaaaaaa add r1, r1.w, c12
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
aaaaaaaaafaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r5.z, r3.x
aaaaaaaaafaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.y, r4.z
aaaaaaaaafaaaiacbmaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r5.w, c28.x
adaaaaaaagaaapacafaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r5.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaaaoaaaaoeabaaaaaa add r1, r1.x, c14
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
adaaaaaaagaaapacadaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r3.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaabaaapacacaaaaoeacaaaaaaapaaaaoeabaaaaaa mul r1, r2, c15
abaaaaaaabaaapacabaaaaoeacaaaaaabmaaaaaaabaaaaaa add r1, r1, c28.x
aaaaaaaaabaaaeaeadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r3.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
bdaaaaaaacaaaeacafaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r2.z, r5, c22
bdaaaaaaacaaacacafaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r2.y, r5, c21
bdaaaaaaacaaabacafaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r2.x, r5, c20
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaabmaaaaffabaaaaaa max r0, r0, c28.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaabbaaaaoeabaaaaaa mul r1.xyz, r0.y, c17
adaaaaaaagaaahacaaaaaaaaacaaaaaabaaaaaoeabaaaaaa mul r6.xyz, r0.x, c16
abaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r6.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaabcaaaaoeabaaaaaa mul r0.xyz, r0.z, c18
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabdaaaaoeabaaaaaa mul r1.xyz, r0.w, c19
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacafaaaakeacaaaaaaafaaaacjacaaaaaa mul r0, r5.xyzz, r5.yzzx
adaaaaaaabaaaiacaeaaaakkacaaaaaaaeaaaakkacaaaaaa mul r1.w, r4.z, r4.z
bdaaaaaaafaaaiacaaaaaaoeacaaaaaabjaaaaoeabaaaaaa dp4 r5.w, r0, c25
bdaaaaaaafaaaeacaaaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r5.z, r0, c24
bdaaaaaaafaaacacaaaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r5.y, r0, c23
adaaaaaaagaaaiacafaaaaaaacaaaaaaafaaaaaaacaaaaaa mul r6.w, r5.x, r5.x
acaaaaaaabaaaiacagaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r6.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabkaaaaoeabaaaaaa mul r0.xyz, r1.w, c26
abaaaaaaacaaahacacaaaakeacaaaaaaafaaaapjacaaaaaa add r2.xyz, r2.xyzz, r5.yzww
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaafaaaoacaaaaaandacaaaaaabmaaaakkabaaaaaa mul r5.yzw, r0.wxyw, c28.z
abaaaaaaacaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaacacafaaaakkacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r5.z, c8.x
aaaaaaaaabaaabacafaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r5.y
abaaaaaaabaaadacabaaaafeacaaaaaaafaaaappacaaaaaa add r1.xy, r1.xyyy, r5.w
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.y
adaaaaaaaeaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v4.xy, r1.xyyy, c9
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
aaaaaaaaaeaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, r0.wwzw
aaaaaaaaabaaacaeaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r4.z
aaaaaaaaabaaabaeafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r5.x
bfaaaaaaagaaalacadaaaapdacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyw, r3.wxww
abaaaaaaadaaahaeagaaaafdacaaaaaaalaaaaoeabaaaaaa add v3.xyz, r6.wxyy, c11
adaaaaaaagaaadacadaaaaoeaaaaaaaablaaaaoeabaaaaaa mul r6.xy, a3, c27
abaaaaaaaaaaadaeagaaaafeacaaaaaablaaaaooabaaaaaa add v0.xy, r6.xyyy, c27.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 8 to 36, TEX: 1 to 4
//   d3d9 - ALU: 7 to 36, TEX: 1 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 27 ALU, 1 TEX
PARAM c[6] = { program.local[0..4],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
MAD R1.xyz, R1.x, fragment.texcoord[3], c[0];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R1;
DP3 R1.y, fragment.texcoord[1], R2;
MOV R1.x, c[5].y;
MUL R1.z, R1.x, c[4].x;
MAX R1.x, R1.y, c[5];
POW R1.x, R1.x, R1.z;
MUL R2.w, R0, R1.x;
MOV R1, c[2];
DP3 R2.x, fragment.texcoord[1], c[0];
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, fragment.color.primary;
MAX R3.x, R2, c[5];
MUL R2.xyz, R0, c[1];
MUL R2.xyz, R2, R3.x;
MUL R1.xyz, R1, c[1];
MAD R1.xyz, R1, R2.w, R2;
MUL R1.xyz, R1, c[5].z;
MAD result.color.xyz, R0, fragment.texcoord[2], R1;
MUL R0.y, R0.w, c[3].w;
MUL R0.x, R1.w, c[1].w;
MAD result.color.w, R2, R0.x, R0.y;
END
# 27 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 31 ALU, 1 TEX
dcl_2d s0
def c5, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
dp3_pp r0.x, t3, t3
rsq_pp r0.x, r0.x
mad_pp r1.xyz, r0.x, t3, c0
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r1
dp3_pp r1.x, t1, r1
mov_pp r0.x, c4
mul_pp r0.x, c5.y, r0
max_pp r1.x, r1, c5
pow r3.w, r1.x, r0.x
mov r0.x, r3.w
mul_pp r1.xyz, r2, c3
mul r3.xyz, r1, v0
dp3_pp r1.x, t1, c0
mul r0.x, r2.w, r0
mul_pp r2.xyz, r3, c1
max_pp r1.x, r1, c5
mov_pp r4.xyz, c1
mul_pp r1.xyz, r2, r1.x
mul_pp r2.xyz, c2, r4
mad r1.xyz, r2, r0.x, r1
mul r4.xyz, r1, c5.z
mov_pp r0.w, c1
mul_pp r1.x, r2.w, c3.w
mul_pp r2.x, c2.w, r0.w
mad r0.w, r0.x, r2.x, r1.x
mad_pp r0.xyz, r3, t2, r4
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
SetTexture 0 [_MainTex] 2D
"agal_ps
c5 0.0 128.0 2.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaabaaahacaaaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r0.x, v3
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa add r1.xyz, r1.xyzz, c0
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaabaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r0.x, r1.xyzz
bcaaaaaaabaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v1, r1.xyzz
aaaaaaaaaaaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c4
adaaaaaaaaaaabacafaaaaffabaaaaaaaaaaaaaaacaaaaaa mul r0.x, c5.y, r0.x
ahaaaaaaabaaabacabaaaaaaacaaaaaaafaaaaoeabaaaaaa max r1.x, r1.x, c5
alaaaaaaadaaapacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa pow r3, r1.x, r0.x
aaaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.x
adaaaaaaabaaahacacaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c3
adaaaaaaadaaahacabaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r3.xyz, r1.xyzz, v7
bcaaaaaaabaaabacabaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r1.x, v1, c0
adaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r2.w, r0.x
adaaaaaaacaaahacadaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r3.xyzz, c1
ahaaaaaaabaaabacabaaaaaaacaaaaaaafaaaaoeabaaaaaa max r1.x, r1.x, c5
aaaaaaaaaeaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4.xyz, c1
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa mul r1.xyz, r2.xyzz, r1.x
adaaaaaaacaaahacacaaaaoeabaaaaaaaeaaaakeacaaaaaa mul r2.xyz, c2, r4.xyzz
adaaaaaaafaaahacacaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r5.xyz, r2.xyzz, r0.x
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaaeaaahacabaaaakeacaaaaaaafaaaakkabaaaaaa mul r4.xyz, r1.xyzz, c5.z
aaaaaaaaaaaaaiacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1
adaaaaaaabaaabacacaaaappacaaaaaaadaaaappabaaaaaa mul r1.x, r2.w, c3.w
adaaaaaaacaaabacacaaaappabaaaaaaaaaaaappacaaaaaa mul r2.x, c2.w, r0.w
adaaaaaaaaaaaiacaaaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r0.w, r0.x, r2.x
abaaaaaaaaaaaiacaaaaaappacaaaaaaabaaaaaaacaaaaaa add r0.w, r0.w, r1.x
adaaaaaaaaaaahacadaaaakeacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r3.xyzz, v2
abaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaakeacaaaaaa add r0.xyz, r0.xyzz, r4.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 8 ALU, 2 TEX
PARAM c[2] = { program.local[0],
		{ 8 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1, fragment.texcoord[1], texture[1], 2D;
MUL R0, R0, c[0];
MUL R0.xyz, R0, fragment.color.primary;
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R1, R0;
MUL result.color.xyz, R0, c[1].x;
MOV result.color.w, R0;
END
# 8 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 7 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c1, 8.00000000, 0, 0, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xy
texld r1, t0, s0
texld r0, t1, s1
mul_pp r1, r1, c0
mul_pp r0.xyz, r0.w, r0
mul r1.xyz, r1, v0
mul_pp r0.xyz, r0, r1
mul_pp r0.xyz, r0, c1.x
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c1 8.0 0.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
ciaaaaaaaaaaapacabaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v1, s1 <2d wrap linear point>
adaaaaaaabaaapacabaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r1, r1, c0
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r1.xyz, r1.xyzz, v7
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c1.x
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
SetTexture 2 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 30 ALU, 3 TEX
PARAM c[6] = { program.local[0..2],
		{ 8, -0.40824828, -0.70710677, 0.57735026 },
		{ 0.81649655, 0, 0.57735026, 128 },
		{ -0.40824831, 0.70710677, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[1], texture[2], 2D;
TEX R1, fragment.texcoord[1], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1.xyz, R1.w, R1;
MUL R2.xyz, R2.w, R2;
MUL R2.xyz, R2, c[3].x;
MUL R3.xyz, R2.y, c[5];
MAD R3.xyz, R2.x, c[4], R3;
MAD R2.xyz, R2.z, c[3].yzww, R3;
DP3 R2.w, R2, R2;
RSQ R3.x, R2.w;
DP3 R2.w, fragment.texcoord[2], fragment.texcoord[2];
MOV R1.w, c[4];
RSQ R2.w, R2.w;
MUL R2.xyz, R3.x, R2;
MAD R2.xyz, R2.w, fragment.texcoord[2], R2;
DP3 R2.x, R2, R2;
RSQ R2.x, R2.x;
MUL R2.x, R2, R2.z;
MAX R2.w, R2.x, c[4].y;
MUL R1.xyz, R1, c[3].x;
MUL R1.w, R1, c[2].x;
MUL R2.xyz, R1, c[0];
MUL R2.xyz, R0.w, R2;
MUL R0, R0, c[1];
POW R1.w, R2.w, R1.w;
MUL R2.xyz, R2, R1.w;
MUL R0.xyz, R0, fragment.color.primary;
MAD result.color.xyz, R0, R1, R2;
MOV result.color.w, R0;
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
SetTexture 2 [unity_LightmapInd] 2D
"ps_2_0
; 34 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c3, 8.00000000, -0.40824831, 0.70710677, 0.57735026
def c4, 0.81649655, 0.00000000, 0.57735026, 128.00000000
def c5, -0.40824828, -0.70710677, 0.57735026, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xy
dcl t2.xyz
texld r2, t0, s0
texld r0, t1, s2
texld r3, t1, s1
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r0, c3.x
mov r0.x, c3.y
mov r0.z, c3.w
mov r0.y, c3.z
mul r0.xyz, r1.y, r0
mad r0.xyz, r1.x, c4, r0
mad r4.xyz, r1.z, c5, r0
dp3 r0.x, r4, r4
rsq r1.x, r0.x
dp3_pp r0.x, t2, t2
mul r1.xyz, r1.x, r4
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, t2, r1
dp3_pp r0.x, r0, r0
rsq_pp r0.x, r0.x
mul_pp r0.z, r0.x, r0
mov_pp r1.x, c2
max_pp r0.x, r0.z, c4.y
mul_pp r1.x, c4.w, r1
pow r4.x, r0.x, r1.x
mul_pp r0.xyz, r3.w, r3
mul_pp r1.xyz, r0, c3.x
mul_pp r3.xyz, r1, c0
mul_pp r3.xyz, r2.w, r3
mul_pp r2, r2, c1
mov r0.x, r4.x
mul r0.xyz, r3, r0.x
mul r2.xyz, r2, v0
mad_pp r0.xyz, r2, r1, r0
mov_pp r0.w, r2
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
SetTexture 2 [unity_LightmapInd] 2D
"agal_ps
c3 8.0 -0.408248 0.707107 0.57735
c4 0.816497 0.0 0.57735 128.0
c5 -0.408248 -0.707107 0.57735 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
ciaaaaaaaaaaapacabaaaaoeaeaaaaaaacaaaaaaafaababb tex r0, v1, s2 <2d wrap linear point>
ciaaaaaaadaaapacabaaaaoeaeaaaaaaabaaaaaaafaababb tex r3, v1, s1 <2d wrap linear point>
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaabaaahacaaaaaakeacaaaaaaadaaaaaaabaaaaaa mul r1.xyz, r0.xyzz, c3.x
aaaaaaaaaaaaabacadaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c3.y
aaaaaaaaaaaaaeacadaaaappabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c3.w
aaaaaaaaaaaaacacadaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c3.z
adaaaaaaaaaaahacabaaaaffacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.y, r0.xyzz
adaaaaaaaeaaahacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r4.xyz, r1.x, c4
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
adaaaaaaaeaaahacabaaaakkacaaaaaaafaaaaoeabaaaaaa mul r4.xyz, r1.z, c5
abaaaaaaaeaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r4.xyz, r4.xyzz, r0.xyzz
bcaaaaaaaaaaabacaeaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r0.x, r4.xyzz, r4.xyzz
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
adaaaaaaabaaahacabaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r1.xyz, r1.x, r4.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
bcaaaaaaaaaaabacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r0.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaaeacaaaaaaaaacaaaaaaaaaaaakkacaaaaaa mul r0.z, r0.x, r0.z
aaaaaaaaabaaabacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.x, c2
ahaaaaaaaaaaabacaaaaaakkacaaaaaaaeaaaaffabaaaaaa max r0.x, r0.z, c4.y
adaaaaaaabaaabacaeaaaappabaaaaaaabaaaaaaacaaaaaa mul r1.x, c4.w, r1.x
alaaaaaaaeaaapacaaaaaaaaacaaaaaaabaaaaaaacaaaaaa pow r4, r0.x, r1.x
adaaaaaaaaaaahacadaaaappacaaaaaaadaaaakeacaaaaaa mul r0.xyz, r3.w, r3.xyzz
adaaaaaaabaaahacaaaaaakeacaaaaaaadaaaaaaabaaaaaa mul r1.xyz, r0.xyzz, c3.x
adaaaaaaadaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r3.xyz, r1.xyzz, c0
adaaaaaaadaaahacacaaaappacaaaaaaadaaaakeacaaaaaa mul r3.xyz, r2.w, r3.xyzz
adaaaaaaacaaapacacaaaaoeacaaaaaaabaaaaoeabaaaaaa mul r2, r2, c1
aaaaaaaaaaaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r4.x
adaaaaaaaaaaahacadaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r3.xyzz, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r2.xyz, r2.xyzz, v7
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r2.xyzz, r1.xyzz
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r2.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 30 ALU, 2 TEX
PARAM c[6] = { program.local[0..4],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R3.x, fragment.texcoord[4], texture[1], 2D;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
MAD R1.xyz, R1.x, fragment.texcoord[3], c[0];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, fragment.texcoord[1], R1;
MOV R1.w, c[5].y;
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, fragment.color.primary;
MUL R1.y, R1.w, c[4].x;
MAX R1.x, R1, c[5];
POW R2.x, R1.x, R1.y;
MUL R2.w, R0, R2.x;
MOV R1, c[2];
DP3 R2.x, fragment.texcoord[1], c[0];
MAX R3.y, R2.x, c[5].x;
MUL R2.xyz, R0, c[1];
MUL R2.xyz, R2, R3.y;
MUL R1.xyz, R1, c[1];
MUL R3.y, R3.x, c[5].z;
MAD R1.xyz, R1, R2.w, R2;
MUL R1.xyz, R1, R3.y;
MAD result.color.xyz, R0, fragment.texcoord[2], R1;
MUL R0.x, R1.w, c[1].w;
MUL R0.y, R0.w, c[3].w;
MUL R0.x, R2.w, R0;
MAD result.color.w, R3.x, R0.x, R0.y;
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"ps_2_0
; 33 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c5, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4
texldp r5, t4, s1
texld r2, t0, s0
dp3_pp r0.x, t3, t3
rsq_pp r0.x, r0.x
mad_pp r1.xyz, r0.x, t3, c0
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r1
dp3_pp r1.x, t1, r1
mov_pp r0.x, c4
mul_pp r0.x, c5.y, r0
max_pp r1.x, r1, c5
pow r3.w, r1.x, r0.x
mov r0.x, r3.w
mul_pp r1.xyz, r2, c3
mul r3.xyz, r1, v0
dp3_pp r1.x, t1, c0
mul r0.x, r2.w, r0
mul_pp r2.xyz, r3, c1
max_pp r1.x, r1, c5
mul_pp r1.xyz, r2, r1.x
mov_pp r4.xyz, c1
mul_pp r2.xyz, c2, r4
mad r2.xyz, r2, r0.x, r1
mul_pp r1.x, r5, c5.z
mul r4.xyz, r2, r1.x
mov_pp r0.w, c1
mul_pp r1.x, c2.w, r0.w
mul r0.x, r0, r1
mul_pp r2.x, r2.w, c3.w
mad r0.w, r5.x, r0.x, r2.x
mad_pp r0.xyz, r3, t2, r4
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_SpecColor]
Vector 3 [_Color]
Float 4 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"agal_ps
c5 0.0 128.0 2.0 0.0
[bc]
aeaaaaaaaaaaapacaeaaaaoeaeaaaaaaaeaaaappaeaaaaaa div r0, v4, v4.w
ciaaaaaaafaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r5, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaabaaahacaaaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r0.x, v3
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa add r1.xyz, r1.xyzz, c0
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaabaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r0.x, r1.xyzz
bcaaaaaaabaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v1, r1.xyzz
aaaaaaaaaaaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c4
adaaaaaaaaaaabacafaaaaffabaaaaaaaaaaaaaaacaaaaaa mul r0.x, c5.y, r0.x
ahaaaaaaabaaabacabaaaaaaacaaaaaaafaaaaoeabaaaaaa max r1.x, r1.x, c5
alaaaaaaadaaapacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa pow r3, r1.x, r0.x
aaaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.x
adaaaaaaabaaahacacaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r2.xyzz, c3
adaaaaaaadaaahacabaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r3.xyz, r1.xyzz, v7
bcaaaaaaabaaabacabaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r1.x, v1, c0
adaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r2.w, r0.x
adaaaaaaacaaahacadaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r3.xyzz, c1
ahaaaaaaabaaabacabaaaaaaacaaaaaaafaaaaoeabaaaaaa max r1.x, r1.x, c5
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa mul r1.xyz, r2.xyzz, r1.x
aaaaaaaaaeaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4.xyz, c1
adaaaaaaacaaahacacaaaaoeabaaaaaaaeaaaakeacaaaaaa mul r2.xyz, c2, r4.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r2.xyz, r2.xyzz, r0.x
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaabacafaaaaaaacaaaaaaafaaaakkabaaaaaa mul r1.x, r5.x, c5.z
adaaaaaaaeaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa mul r4.xyz, r2.xyzz, r1.x
aaaaaaaaaaaaaiacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1
adaaaaaaabaaabacacaaaappabaaaaaaaaaaaappacaaaaaa mul r1.x, c2.w, r0.w
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r0.x, r0.x, r1.x
adaaaaaaacaaabacacaaaappacaaaaaaadaaaappabaaaaaa mul r2.x, r2.w, c3.w
adaaaaaaaaaaaiacafaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.w, r5.x, r0.x
abaaaaaaaaaaaiacaaaaaappacaaaaaaacaaaaaaacaaaaaa add r0.w, r0.w, r2.x
adaaaaaaaaaaahacadaaaakeacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r3.xyzz, v2
abaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaakeacaaaaaa add r0.xyz, r0.xyzz, r4.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 14 ALU, 3 TEX
PARAM c[2] = { program.local[0],
		{ 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R1.x, fragment.texcoord[2], texture[1], 2D;
TEX R2, fragment.texcoord[1], texture[2], 2D;
MUL R1.yzw, R2.xxyz, R1.x;
MUL R0, R0, c[0];
MUL R2.xyz, R2.w, R2;
MUL R2.xyz, R2, c[1].x;
MUL R1.yzw, R1, c[1].y;
MIN R1.yzw, R2.xxyz, R1;
MUL R2.xyz, R2, R1.x;
MAX R1.xyz, R1.yzww, R2;
MUL R0.xyz, R0, fragment.color.primary;
MUL result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 14 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 12 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c1, 8.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xy
dcl t2
texld r1, t0, s0
texldp r3, t2, s1
texld r0, t1, s2
mul_pp r1, r1, c0
mul_pp r2.xyz, r0, r3.x
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c1.x
mul_pp r2.xyz, r2, c1.y
min_pp r2.xyz, r0, r2
mul_pp r0.xyz, r0, r3.x
max_pp r0.xyz, r2, r0
mul r1.xyz, r1, v0
mul_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"agal_ps
c1 8.0 2.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
aeaaaaaaaaaaapacacaaaaoeaeaaaaaaacaaaappaeaaaaaa div r0, v2, v2.w
ciaaaaaaadaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r3, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacabaaaaoeaeaaaaaaacaaaaaaafaababb tex r0, v1, s2 <2d wrap linear point>
adaaaaaaabaaapacabaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r1, r1, c0
adaaaaaaacaaahacaaaaaakeacaaaaaaadaaaaaaacaaaaaa mul r2.xyz, r0.xyzz, r3.x
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c1.x
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c1.y
agaaaaaaacaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa min r2.xyz, r0.xyzz, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaaaacaaaaaa mul r0.xyz, r0.xyzz, r3.x
ahaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa max r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r1.xyz, r1.xyzz, v7
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 36 ALU, 4 TEX
PARAM c[7] = { program.local[0..2],
		{ 8, 2, 0, 128 },
		{ -0.40824828, -0.70710677, 0.57735026 },
		{ 0.81649655, 0, 0.57735026 },
		{ -0.40824831, 0.70710677, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[1], texture[3], 2D;
TEX R1, fragment.texcoord[1], texture[2], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R3.x, fragment.texcoord[3], texture[1], 2D;
MUL R2.xyz, R2.w, R2;
MUL R2.xyz, R2, c[3].x;
MUL R3.yzw, R2.y, c[6].xxyz;
MAD R2.xyw, R2.x, c[5].xyzz, R3.yzzw;
MAD R2.xyz, R2.z, c[4], R2.xyww;
DP3 R2.w, R2, R2;
RSQ R3.y, R2.w;
MUL R2.xyz, R3.y, R2;
DP3 R2.w, fragment.texcoord[2], fragment.texcoord[2];
RSQ R2.w, R2.w;
MAD R2.xyz, R2.w, fragment.texcoord[2], R2;
DP3 R2.x, R2, R2;
RSQ R2.x, R2.x;
MUL R2.x, R2, R2.z;
MAX R2.w, R2.x, c[3].z;
MUL R2.xyz, R1.w, R1;
MOV R3.y, c[3].w;
MUL R1.w, R3.y, c[2].x;
MUL R2.xyz, R2, c[3].x;
MUL R3.yzw, R2.xxyz, c[0].xxyz;
MUL R3.yzw, R0.w, R3;
MUL R0, R0, c[1];
POW R1.w, R2.w, R1.w;
MUL R1.xyz, R1, R3.x;
MUL R1.xyz, R1, c[3].y;
MIN R1.xyz, R2, R1;
MUL R2.xyz, R2, R3.x;
MUL R3.yzw, R3, R1.w;
MAX R1.xyz, R1, R2;
MUL R0.xyz, R0, fragment.color.primary;
MAD result.color.xyz, R0, R1, R3.yzww;
MOV result.color.w, R0;
END
# 36 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 36 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c3, 8.00000000, 2.00000000, 0.00000000, 128.00000000
def c4, -0.40824831, 0.70710677, 0.57735026, 0
def c5, 0.81649655, 0.00000000, 0.57735026, 0
def c6, -0.40824828, -0.70710677, 0.57735026, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xy
dcl t2.xyz
dcl t3
texld r2, t0, s0
texldp r5, t3, s1
texld r0, t1, s3
texld r3, t1, s2
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c3.x
mul r1.xyz, r0.y, c4
mad r1.xyz, r0.x, c5, r1
mad r4.xyz, r0.z, c6, r1
dp3 r0.x, r4, r4
rsq r1.x, r0.x
dp3_pp r0.x, t2, t2
mul r1.xyz, r1.x, r4
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, t2, r1
dp3_pp r0.x, r0, r0
rsq_pp r1.x, r0.x
mul_pp r0.z, r1.x, r0
mov_pp r0.x, c2
max_pp r1.x, r0.z, c3.z
mul_pp r0.x, c3.w, r0
pow r4.x, r1.x, r0.x
mul_pp r0.xyz, r3.w, r3
mul_pp r1.xyz, r3, r5.x
mul_pp r3.xyz, r0, c3.x
mul_pp r0.xyz, r1, c3.y
min_pp r0.xyz, r3, r0
mul_pp r1.xyz, r3, r5.x
max_pp r1.xyz, r0, r1
mul_pp r3.xyz, r3, c0
mul_pp r3.xyz, r2.w, r3
mul_pp r2, r2, c1
mov r0.x, r4.x
mul r0.xyz, r3, r0.x
mul r2.xyz, r2, v0
mad_pp r0.xyz, r2, r1, r0
mov_pp r0.w, r2
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"agal_ps
c3 8.0 2.0 0.0 128.0
c4 -0.408248 0.707107 0.57735 0.0
c5 0.816497 0.0 0.57735 0.0
c6 -0.408248 -0.707107 0.57735 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
aeaaaaaaaaaaapacadaaaaoeaeaaaaaaadaaaappaeaaaaaa div r0, v3, v3.w
ciaaaaaaafaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r5, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacabaaaaoeaeaaaaaaadaaaaaaafaababb tex r0, v1, s3 <2d wrap linear point>
ciaaaaaaadaaapacabaaaaoeaeaaaaaaacaaaaaaafaababb tex r3, v1, s2 <2d wrap linear point>
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c3.x
adaaaaaaabaaahacaaaaaaffacaaaaaaaeaaaaoeabaaaaaa mul r1.xyz, r0.y, c4
adaaaaaaaeaaahacaaaaaaaaacaaaaaaafaaaaoeabaaaaaa mul r4.xyz, r0.x, c5
abaaaaaaabaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r4.xyzz, r1.xyzz
adaaaaaaaeaaahacaaaaaakkacaaaaaaagaaaaoeabaaaaaa mul r4.xyz, r0.z, c6
abaaaaaaaeaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa add r4.xyz, r4.xyzz, r1.xyzz
bcaaaaaaaaaaabacaeaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r0.x, r4.xyzz, r4.xyzz
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
adaaaaaaabaaahacabaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r1.xyz, r1.x, r4.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
bcaaaaaaaaaaabacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r0.xyzz
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
adaaaaaaaaaaaeacabaaaaaaacaaaaaaaaaaaakkacaaaaaa mul r0.z, r1.x, r0.z
aaaaaaaaaaaaabacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c2
ahaaaaaaabaaabacaaaaaakkacaaaaaaadaaaakkabaaaaaa max r1.x, r0.z, c3.z
adaaaaaaaaaaabacadaaaappabaaaaaaaaaaaaaaacaaaaaa mul r0.x, c3.w, r0.x
alaaaaaaaeaaapacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa pow r4, r1.x, r0.x
adaaaaaaaaaaahacadaaaappacaaaaaaadaaaakeacaaaaaa mul r0.xyz, r3.w, r3.xyzz
adaaaaaaabaaahacadaaaakeacaaaaaaafaaaaaaacaaaaaa mul r1.xyz, r3.xyzz, r5.x
adaaaaaaadaaahacaaaaaakeacaaaaaaadaaaaaaabaaaaaa mul r3.xyz, r0.xyzz, c3.x
adaaaaaaaaaaahacabaaaakeacaaaaaaadaaaaffabaaaaaa mul r0.xyz, r1.xyzz, c3.y
agaaaaaaaaaaahacadaaaakeacaaaaaaaaaaaakeacaaaaaa min r0.xyz, r3.xyzz, r0.xyzz
adaaaaaaabaaahacadaaaakeacaaaaaaafaaaaaaacaaaaaa mul r1.xyz, r3.xyzz, r5.x
ahaaaaaaabaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa max r1.xyz, r0.xyzz, r1.xyzz
adaaaaaaadaaahacadaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c0
adaaaaaaadaaahacacaaaappacaaaaaaadaaaakeacaaaaaa mul r3.xyz, r2.w, r3.xyzz
adaaaaaaacaaapacacaaaaoeacaaaaaaabaaaaoeabaaaaaa mul r2, r2, c1
aaaaaaaaaaaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r4.x
adaaaaaaaaaaahacadaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r3.xyzz, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r2.xyz, r2.xyzz, v7
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r2.xyzz, r1.xyzz
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r2.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 15 to 20
//   d3d9 - ALU: 15 to 20
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 19 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.color, vertex.color;
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[15];
ADD result.texcoord[3].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_2_0
; 19 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov oD0, v3
dp4 oT4.z, r0, c10
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c14
add oT3.xyz, -r0, c13
mad oT0.xy, v2, c15, c15.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp float atten;
  atten = texture2D (_LightTexture0, tmpvar_7).w;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, lightDir));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize ((lightDir + normalize (xlv_TEXCOORD3)))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_10)) * (atten * 2.0));
  c_i0.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_10) * atten));
  c_i0.w = tmpvar_12;
  c = c_i0;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp float atten;
  atten = texture2D (_LightTexture0, tmpvar_7).w;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, lightDir));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize ((lightDir + normalize (xlv_TEXCOORD3)))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_10)) * (atten * 2.0));
  c_i0.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_10) * atten));
  c_i0.w = tmpvar_12;
  c = c_i0;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v4.z, r0, c10
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v4.y, r0, c9
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v4.x, r0, c8
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
bfaaaaaaabaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r0.xyzz
abaaaaaaacaaahaeabaaaakeacaaaaaaaoaaaaoeabaaaaaa add v2.xyz, r1.xyzz, c14
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaadaaahaeaaaaaakeacaaaaaaanaaaaoeabaaaaaa add v3.xyz, r0.xyzz, c13
adaaaaaaaaaaadacadaaaaoeaaaaaaaaapaaaaoeabaaaaaa mul r0.xy, a3, c15
abaaaaaaaaaaadaeaaaaaafeacaaaaaaapaaaaooabaaaaaa add v0.xy, r0.xyyy, c15.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 12 [_MainTex_ST]
"!!ARBvp1.0
# 15 ALU
PARAM c[13] = { program.local[0],
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.color, vertex.color;
MOV result.texcoord[2].xyz, c[11];
ADD result.texcoord[3].xyz, -R0, c[10];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 15 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 11 [_MainTex_ST]
"vs_2_0
; 15 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r0.xyz, v1, c8.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov oD0, v3
mov oT2.xyz, c10
add oT3.xyz, -r0, c9
mad oT0.xy, v2, c11, c11.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  lightDir = xlv_TEXCOORD2;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_6;
  tmpvar_6 = max (0.0, dot (xlv_TEXCOORD1, lightDir));
  mediump float tmpvar_7;
  tmpvar_7 = max (0.0, dot (xlv_TEXCOORD1, normalize ((lightDir + normalize (xlv_TEXCOORD3)))));
  nh = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_9;
  tmpvar_9 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_6) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_8)) * 2.0);
  c_i0.xyz = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (tmpvar_5 + ((_LightColor0.w * _SpecColor.w) * tmpvar_8));
  c_i0.w = tmpvar_10;
  c = c_i0;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  lightDir = xlv_TEXCOORD2;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_6;
  tmpvar_6 = max (0.0, dot (xlv_TEXCOORD1, lightDir));
  mediump float tmpvar_7;
  tmpvar_7 = max (0.0, dot (xlv_TEXCOORD1, normalize ((lightDir + normalize (xlv_TEXCOORD3)))));
  nh = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_9;
  tmpvar_9 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_6) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_8)) * 2.0);
  c_i0.xyz = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (tmpvar_5 + ((_LightColor0.w * _SpecColor.w) * tmpvar_8));
  c_i0.w = tmpvar_10;
  c = c_i0;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 11 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaiaaaappabaaaaaa mul r0.xyz, a1, c8.w
bcaaaaaaabaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r0.xyzz, c6
bcaaaaaaabaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c5
bcaaaaaaabaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
aaaaaaaaacaaahaeakaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c10
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaadaaahaeaaaaaakeacaaaaaaajaaaaoeabaaaaaa add v3.xyz, r0.xyzz, c9
adaaaaaaaaaaadacadaaaaoeaaaaaaaaalaaaaoeabaaaaaa mul r0.xy, a3, c11
abaaaaaaaaaaadaeaaaaaafeacaaaaaaalaaaaooabaaaaaa add v0.xy, r0.xyyy, c11.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 20 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.color, vertex.color;
DP4 result.texcoord[4].w, R0, c[12];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[15];
ADD result.texcoord[3].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_2_0
; 20 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov oD0, v3
dp4 oT4.w, r0, c11
dp4 oT4.z, r0, c10
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c14
add oT3.xyz, -r0, c13
mad oT0.xy, v2, c15, c15.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_6;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_7;
  tmpvar_7 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_7).w);
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, lightDir));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize ((lightDir + normalize (xlv_TEXCOORD3)))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_10)) * (atten * 2.0));
  c_i0.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_10) * atten));
  c_i0.w = tmpvar_12;
  c = c_i0;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_6;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD4.xyz;
  highp vec2 tmpvar_7;
  tmpvar_7 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_7).w);
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, lightDir));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize ((lightDir + normalize (xlv_TEXCOORD3)))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_10)) * (atten * 2.0));
  c_i0.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_10) * atten));
  c_i0.w = tmpvar_12;
  c = c_i0;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
bdaaaaaaaeaaaiaeaaaaaaoeacaaaaaaalaaaaoeabaaaaaa dp4 v4.w, r0, c11
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v4.z, r0, c10
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v4.y, r0, c9
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v4.x, r0, c8
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
bfaaaaaaabaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r0.xyzz
abaaaaaaacaaahaeabaaaakeacaaaaaaaoaaaaoeabaaaaaa add v2.xyz, r1.xyzz, c14
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaadaaahaeaaaaaakeacaaaaaaanaaaaoeabaaaaaa add v3.xyz, r0.xyzz, c13
adaaaaaaaaaaadacadaaaaoeaaaaaaaaapaaaaoeabaaaaaa mul r0.xy, a3, c15
abaaaaaaaaaaadaeaaaaaafeacaaaaaaapaaaaooabaaaaaa add v0.xy, r0.xyyy, c15.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 19 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.color, vertex.color;
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[15];
ADD result.texcoord[3].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_2_0
; 19 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov oD0, v3
dp4 oT4.z, r0, c10
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c14
add oT3.xyz, -r0, c13
mad oT0.xy, v2, c15, c15.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp float atten;
  atten = (texture2D (_LightTextureB0, tmpvar_7).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w);
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, lightDir));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize ((lightDir + normalize (xlv_TEXCOORD3)))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_10)) * (atten * 2.0));
  c_i0.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_10) * atten));
  c_i0.w = tmpvar_12;
  c = c_i0;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  mediump vec3 tmpvar_6;
  tmpvar_6 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = vec2(dot (xlv_TEXCOORD4, xlv_TEXCOORD4));
  lowp float atten;
  atten = (texture2D (_LightTextureB0, tmpvar_7).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w);
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_8;
  tmpvar_8 = max (0.0, dot (xlv_TEXCOORD1, lightDir));
  mediump float tmpvar_9;
  tmpvar_9 = max (0.0, dot (xlv_TEXCOORD1, normalize ((lightDir + normalize (xlv_TEXCOORD3)))));
  nh = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_8) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_10)) * (atten * 2.0));
  c_i0.xyz = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_10) * atten));
  c_i0.w = tmpvar_12;
  c = c_i0;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
bdaaaaaaaeaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v4.z, r0, c10
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v4.y, r0, c9
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v4.x, r0, c8
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
bfaaaaaaabaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r0.xyzz
abaaaaaaacaaahaeabaaaakeacaaaaaaaoaaaaoeabaaaaaa add v2.xyz, r1.xyzz, c14
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaadaaahaeaaaaaakeacaaaaaaanaaaaoeabaaaaaa add v3.xyz, r0.xyzz, c13
adaaaaaaaaaaadacadaaaaoeaaaaaaaaapaaaaoeabaaaaaa mul r0.xy, a3, c15
abaaaaaaaaaaadaeaaaaaafeacaaaaaaapaaaaooabaaaaaa add v0.xy, r0.xyyy, c15.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 18 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.color, vertex.color;
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
MOV result.texcoord[2].xyz, c[15];
ADD result.texcoord[3].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"vs_2_0
; 18 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov oD0, v3
dp4 oT4.y, r0, c9
dp4 oT4.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
mov oT2.xyz, c14
add oT3.xyz, -r0, c13
mad oT0.xy, v2, c15, c15.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  lightDir = xlv_TEXCOORD2;
  lowp float atten;
  atten = texture2D (_LightTexture0, xlv_TEXCOORD4).w;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_6;
  tmpvar_6 = max (0.0, dot (xlv_TEXCOORD1, lightDir));
  mediump float tmpvar_7;
  tmpvar_7 = max (0.0, dot (xlv_TEXCOORD1, normalize ((lightDir + normalize (xlv_TEXCOORD3)))));
  nh = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_9;
  tmpvar_9 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_6) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_8)) * (atten * 2.0));
  c_i0.xyz = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_8) * atten));
  c_i0.w = tmpvar_10;
  c = c_i0;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  highp vec4 tmpvar_1;
  tmpvar_1 = xlv_COLOR0;
  lowp vec3 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_4;
  tmpvar_4 = ((tmpvar_3.xyz * _Color.xyz) * tmpvar_1.xyz);
  tmpvar_2 = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = (tmpvar_3.w * _Color.w);
  lightDir = xlv_TEXCOORD2;
  lowp float atten;
  atten = texture2D (_LightTexture0, xlv_TEXCOORD4).w;
  lowp vec4 c_i0;
  highp float nh;
  lowp float tmpvar_6;
  tmpvar_6 = max (0.0, dot (xlv_TEXCOORD1, lightDir));
  mediump float tmpvar_7;
  tmpvar_7 = max (0.0, dot (xlv_TEXCOORD1, normalize ((lightDir + normalize (xlv_TEXCOORD3)))));
  nh = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (pow (nh, (_Shininess * 128.0)) * tmpvar_3.w);
  highp vec3 tmpvar_9;
  tmpvar_9 = ((((tmpvar_2 * _LightColor0.xyz) * tmpvar_6) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_8)) * (atten * 2.0));
  c_i0.xyz = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = (tmpvar_5 + (((_LightColor0.w * _SpecColor.w) * tmpvar_8) * atten));
  c_i0.w = tmpvar_10;
  c = c_i0;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
aaaaaaaaahaaapaeacaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v7, a2
bdaaaaaaaeaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v4.y, r0, c9
bdaaaaaaaeaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v4.x, r0, c8
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
aaaaaaaaacaaahaeaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c14
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaadaaahaeaaaaaakeacaaaaaaanaaaaoeabaaaaaa add v3.xyz, r0.xyzz, c13
adaaaaaaaaaaadacadaaaaoeaaaaaaaaapaaaaoeabaaaaaa mul r0.xy, a3, c15
abaaaaaaaaaaadaeaaaaaafeacaaaaaaapaaaaooabaaaaaa add v0.xy, r0.xyyy, c15.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, c0
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 25 to 36, TEX: 1 to 3
//   d3d9 - ALU: 29 to 38, TEX: 1 to 3
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 30 ALU, 2 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
DP3 R1.x, fragment.texcoord[4], fragment.texcoord[4];
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[2];
MUL R0.xyz, R0, fragment.color.primary;
RSQ R2.x, R2.x;
MOV result.color.w, c[4].x;
TEX R1.w, R1.x, texture[1], 2D;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[2];
MAD R2.xyz, R2.x, fragment.texcoord[3], R1;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
DP3 R2.x, fragment.texcoord[1], R2;
MOV R2.w, c[4].y;
MUL R2.y, R2.w, c[3].x;
MAX R2.x, R2, c[4];
POW R2.x, R2.x, R2.y;
MUL R0.w, R2.x, R0;
DP3 R2.x, fragment.texcoord[1], R1;
MUL R1.xyz, R0, c[0];
MAX R2.x, R2, c[4];
MOV R0.xyz, c[1];
MUL R1.xyz, R1, R2.x;
MUL R0.xyz, R0, c[0];
MUL R1.w, R1, c[4].z;
MAD R0.xyz, R0, R0.w, R1;
MUL result.color.xyz, R0, R1.w;
END
# 30 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 33 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r2, t0, s0
dp3 r0.x, t4, t4
mov r0.xy, r0.x
mul_pp r2.xyz, r2, c2
mul r2.xyz, r2, v0
mul_pp r2.xyz, r2, c0
mov_pp r0.w, c4.x
texld r5, r0, s1
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r0.x
dp3_pp r0.x, t3, t3
mul_pp r4.xyz, r1.x, t2
rsq_pp r0.x, r0.x
mad_pp r1.xyz, r0.x, t3, r4
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r1
mov_pp r0.x, c3
dp3_pp r1.x, t1, r1
mul_pp r0.x, c4.y, r0
max_pp r1.x, r1, c4
pow r3.w, r1.x, r0.x
mov r0.x, r3.w
dp3_pp r1.x, t1, r4
max_pp r1.x, r1, c4
mul_pp r3.xyz, r2, r1.x
mov_pp r2.xyz, c0
mul r0.x, r0, r2.w
mul_pp r2.xyz, c1, r2
mul_pp r1.x, r5, c4.z
mad r0.xyz, r2, r0.x, r3
mul r0.xyz, r0, r1.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c4 0.0 128.0 2.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
adaaaaaaacaaahacacaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r2.xyz, r2.xyzz, v7
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
adaaaaaaaeaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r4.xyz, r1.x, v2
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaabaaahacaaaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r0.x, v3
abaaaaaaabaaahacabaaaakeacaaaaaaaeaaaakeacaaaaaa add r1.xyz, r1.xyzz, r4.xyzz
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaabaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r0.x, r1.xyzz
aaaaaaaaaaaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c3
bcaaaaaaabaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v1, r1.xyzz
adaaaaaaaaaaabacaeaaaaffabaaaaaaaaaaaaaaacaaaaaa mul r0.x, c4.y, r0.x
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
alaaaaaaadaaapacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa pow r3, r1.x, r0.x
aaaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaappacaaaaaa mul r0.x, r0.x, r2.w
bcaaaaaaabaaabacabaaaaoeaeaaaaaaaeaaaakeacaaaaaa dp3 r1.x, v1, r4.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaadaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa mul r3.xyz, r2.xyzz, r1.x
adaaaaaaabaaabacaaaaaappacaaaaaaaeaaaakkabaaaaaa mul r1.x, r0.w, c4.z
aaaaaaaaacaaahacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.xyz, c0
adaaaaaaacaaahacabaaaaoeabaaaaaaacaaaakeacaaaaaa mul r2.xyz, c1, r2.xyzz
adaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r2.xyzz, r0.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaaaacaaaaaa mul r0.xyz, r0.xyzz, r1.x
aaaaaaaaaaaaaiacaeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c4.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 25 ALU, 1 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
DP3 R1.w, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[2];
MOV R1.xyz, fragment.texcoord[2];
RSQ R1.w, R1.w;
MAD R2.xyz, R1.w, fragment.texcoord[3], R1;
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
MOV R1.w, c[4].y;
DP3 R2.x, fragment.texcoord[1], R2;
MUL R2.y, R1.w, c[3].x;
MAX R1.w, R2.x, c[4].x;
POW R1.w, R1.w, R2.y;
MUL R0.w, R1, R0;
DP3 R1.w, fragment.texcoord[1], R1;
MUL R0.xyz, R0, fragment.color.primary;
MUL R1.xyz, R0, c[0];
MAX R1.w, R1, c[4].x;
MOV R0.xyz, c[1];
MUL R1.xyz, R1, R1.w;
MUL R0.xyz, R0, c[0];
MAD R0.xyz, R0, R0.w, R1;
MUL result.color.xyz, R0, c[4].z;
MOV result.color.w, c[4].x;
END
# 25 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 29 ALU, 1 TEX
dcl_2d s0
def c4, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
dp3_pp r0.x, t3, t3
mul_pp r2.xyz, r2, c2
mul r2.xyz, r2, v0
rsq_pp r0.x, r0.x
mov_pp r1.xyz, t2
mad_pp r1.xyz, r0.x, t3, r1
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r1
dp3_pp r1.x, t1, r1
mov_pp r0.x, c3
mul_pp r0.x, c4.y, r0
max_pp r1.x, r1, c4
pow r3.w, r1.x, r0.x
mov r0.x, r3.w
mov_pp r1.xyz, t2
dp3_pp r1.x, t1, r1
mul_pp r2.xyz, r2, c0
max_pp r1.x, r1, c4
mul_pp r1.xyz, r2, r1.x
mov_pp r3.xyz, c0
mul r0.x, r0, r2.w
mul_pp r2.xyz, c1, r3
mad r0.xyz, r2, r0.x, r1
mul r0.xyz, r0, c4.z
mov_pp r0.w, c4.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
"agal_ps
c4 0.0 128.0 2.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
adaaaaaaacaaahacacaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r2.xyz, r2.xyzz, v7
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
aaaaaaaaabaaahacacaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v2
adaaaaaaadaaahacaaaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r3.xyz, r0.x, v3
abaaaaaaabaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r3.xyzz, r1.xyzz
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaabaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r0.x, r1.xyzz
bcaaaaaaabaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v1, r1.xyzz
aaaaaaaaaaaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c3
adaaaaaaaaaaabacaeaaaaffabaaaaaaaaaaaaaaacaaaaaa mul r0.x, c4.y, r0.x
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
alaaaaaaadaaapacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa pow r3, r1.x, r0.x
aaaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.x
aaaaaaaaabaaahacacaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v2
bcaaaaaaabaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v1, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaabaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa mul r1.xyz, r2.xyzz, r1.x
aaaaaaaaadaaahacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r3.xyz, c0
adaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaappacaaaaaa mul r0.x, r0.x, r2.w
adaaaaaaacaaahacabaaaaoeabaaaaaaadaaaakeacaaaaaa mul r2.xyz, c1, r3.xyzz
adaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r2.xyzz, r0.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaakkabaaaaaa mul r0.xyz, r0.xyzz, c4.z
aaaaaaaaaaaaaiacaeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c4.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 36 ALU, 3 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 128, 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[0], texture[0], 2D;
DP3 R0.z, fragment.texcoord[4], fragment.texcoord[4];
RCP R0.x, fragment.texcoord[4].w;
MAD R0.xy, fragment.texcoord[4], R0.x, c[4].z;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
MOV result.color.w, c[4].x;
TEX R0.w, R0, texture[1], 2D;
TEX R1.w, R0.z, texture[2], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
MAD R1.xyz, R1.x, fragment.texcoord[3], R0;
DP3 R3.x, R1, R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R1;
DP3 R1.x, fragment.texcoord[1], R1;
MOV R3.x, c[4].y;
MUL R1.y, R3.x, c[3].x;
MAX R1.x, R1, c[4];
POW R1.x, R1.x, R1.y;
MUL R2.w, R1.x, R2;
MUL R1.xyz, R2, c[2];
DP3 R2.x, fragment.texcoord[1], R0;
MUL R0.xyz, R1, fragment.color.primary;
MAX R1.x, R2, c[4];
MUL R0.xyz, R0, c[0];
MUL R1.xyz, R0, R1.x;
MOV R0.xyz, c[1];
SLT R2.x, c[4], fragment.texcoord[4].z;
MUL R0.w, R2.x, R0;
MUL R0.w, R0, R1;
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, c[4];
MAD R0.xyz, R0, R2.w, R1;
MUL result.color.xyz, R0, R0.w;
END
# 36 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 38 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c4, 0.00000000, 128.00000000, 1.00000000, 0.50000000
def c5, 2.00000000, 0, 0, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4
texld r3, t0, s0
dp3 r1.x, t4, t4
mov r1.xy, r1.x
rcp r0.x, t4.w
mad r0.xy, t4, r0.x, c4.w
texld r0, r0, s1
texld r5, r1, s2
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r0.x
dp3_pp r0.x, t3, t3
mul_pp r4.xyz, r1.x, t2
rsq_pp r0.x, r0.x
mad_pp r2.xyz, r0.x, t3, r4
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r2.xyz, r1.x, r2
dp3_pp r2.x, t1, r2
cmp r0.x, -t4.z, c4, c4.z
mul_pp r0.x, r0, r0.w
mul_pp r0.x, r0, r5
mov_pp r1.x, c3
mul_pp r1.x, c4.y, r1
max_pp r2.x, r2, c4
pow r5.x, r2.x, r1.x
mul_pp r2.xyz, r3, c2
mul r3.xyz, r2, v0
dp3_pp r2.x, t1, r4
mov r1.x, r5.x
mul_pp r3.xyz, r3, c0
max_pp r2.x, r2, c4
mul_pp r2.xyz, r3, r2.x
mov_pp r4.xyz, c0
mul_pp r0.x, r0, c5
mul r1.x, r1, r3.w
mul_pp r3.xyz, c1, r4
mad r1.xyz, r3, r1.x, r2
mul r0.xyz, r1, r0.x
mov_pp r0.w, c4.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"agal_ps
c4 0.0 128.0 1.0 0.5
c5 2.0 0.0 0.0 0.0
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r3, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
afaaaaaaabaaabacaeaaaappaeaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, v4.w
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
adaaaaaaabaaadacaeaaaaoeaeaaaaaaabaaaaaaacaaaaaa mul r1.xy, v4, r1.x
abaaaaaaabaaadacabaaaafeacaaaaaaaeaaaappabaaaaaa add r1.xy, r1.xyyy, c4.w
ciaaaaaaaaaaapacaaaaaafeacaaaaaaacaaaaaaafaababb tex r0, r0.xyyy, s2 <2d wrap linear point>
ciaaaaaaabaaapacabaaaafeacaaaaaaabaaaaaaafaababb tex r1, r1.xyyy, s1 <2d wrap linear point>
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
adaaaaaaaeaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r4.xyz, r1.x, v2
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaacaaahacaaaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r2.xyz, r0.x, v3
abaaaaaaacaaahacacaaaakeacaaaaaaaeaaaakeacaaaaaa add r2.xyz, r2.xyzz, r4.xyzz
bcaaaaaaaaaaabacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.x, r2.xyzz, r2.xyzz
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
adaaaaaaacaaahacabaaaaaaacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r1.x, r2.xyzz
bcaaaaaaacaaabacabaaaaoeaeaaaaaaacaaaakeacaaaaaa dp3 r2.x, v1, r2.xyzz
bfaaaaaaacaaaiacaeaaaakkaeaaaaaaaaaaaaaaaaaaaaaa neg r2.w, v4.z
ckaaaaaaaaaaabacacaaaappacaaaaaaafaaaaffabaaaaaa slt r0.x, r2.w, c5.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaappacaaaaaa mul r0.x, r0.x, r1.w
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
aaaaaaaaabaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.x, c3
adaaaaaaabaaabacaeaaaaffabaaaaaaabaaaaaaacaaaaaa mul r1.x, c4.y, r1.x
ahaaaaaaacaaabacacaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r2.x, r2.x, c4
alaaaaaaafaaapacacaaaaaaacaaaaaaabaaaaaaacaaaaaa pow r5, r2.x, r1.x
adaaaaaaacaaahacadaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r3.xyzz, c2
adaaaaaaadaaahacacaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r3.xyz, r2.xyzz, v7
bcaaaaaaacaaabacabaaaaoeaeaaaaaaaeaaaakeacaaaaaa dp3 r2.x, v1, r4.xyzz
aaaaaaaaabaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r5.x
adaaaaaaadaaahacadaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c0
ahaaaaaaacaaabacacaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r2.x, r2.x, c4
adaaaaaaacaaahacadaaaakeacaaaaaaacaaaaaaacaaaaaa mul r2.xyz, r3.xyzz, r2.x
aaaaaaaaaeaaahacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4.xyz, c0
adaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaoeabaaaaaa mul r0.x, r0.x, c5
adaaaaaaabaaabacabaaaaaaacaaaaaaadaaaappacaaaaaa mul r1.x, r1.x, r3.w
adaaaaaaadaaahacabaaaaoeabaaaaaaaeaaaakeacaaaaaa mul r3.xyz, c1, r4.xyzz
adaaaaaaabaaahacadaaaakeacaaaaaaabaaaaaaacaaaaaa mul r1.xyz, r3.xyzz, r1.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
aaaaaaaaaaaaaiacaeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c4.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 32 ALU, 3 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[4], texture[2], CUBE;
DP3 R0.x, fragment.texcoord[4], fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
MOV result.color.w, c[4].x;
TEX R0.w, R0.x, texture[1], 2D;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
MAD R1.xyz, R1.x, fragment.texcoord[3], R0;
DP3 R3.x, R1, R1;
RSQ R3.x, R3.x;
MUL R1.xyz, R3.x, R1;
DP3 R1.x, fragment.texcoord[1], R1;
MOV R3.x, c[4].y;
MUL R0.w, R0, R1;
MUL R1.y, R3.x, c[3].x;
MAX R1.x, R1, c[4];
POW R1.x, R1.x, R1.y;
MUL R2.w, R1.x, R2;
MUL R1.xyz, R2, c[2];
DP3 R2.x, fragment.texcoord[1], R0;
MUL R0.xyz, R1, fragment.color.primary;
MUL R0.xyz, R0, c[0];
MAX R1.x, R2, c[4];
MUL R1.xyz, R0, R1.x;
MOV R0.xyz, c[1];
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, c[4].z;
MAD R0.xyz, R0, R2.w, R1;
MUL result.color.xyz, R0, R0.w;
END
# 32 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 34 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c4, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r3, t0, s0
dp3 r0.x, t4, t4
mov r0.xy, r0.x
texld r4, r0, s1
texld r0, t4, s2
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r0.x
dp3_pp r0.x, t3, t3
mul_pp r5.xyz, r1.x, t2
rsq_pp r0.x, r0.x
mad_pp r2.xyz, r0.x, t3, r5
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r2.xyz, r1.x, r2
dp3_pp r2.x, t1, r2
mov_pp r1.x, c3
mul r0.x, r4, r0.w
mul_pp r1.x, c4.y, r1
max_pp r2.x, r2, c4
pow r4.w, r2.x, r1.x
mul_pp r2.xyz, r3, c2
mul r3.xyz, r2, v0
mov r1.x, r4.w
dp3_pp r2.x, t1, r5
mul_pp r3.xyz, r3, c0
max_pp r2.x, r2, c4
mul_pp r2.xyz, r3, r2.x
mov_pp r4.xyz, c0
mul_pp r0.x, r0, c4.z
mul r1.x, r1, r3.w
mul_pp r3.xyz, c1, r4
mad r1.xyz, r3, r1.x, r2
mul r0.xyz, r1, r0.x
mov_pp r0.w, c4.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"agal_ps
c4 0.0 128.0 2.0 0.0
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r3, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
ciaaaaaaabaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r1, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacaeaaaaoeaeaaaaaaacaaaaaaafbababb tex r0, v4, s2 <cube wrap linear point>
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
adaaaaaaafaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r5.xyz, r1.x, v2
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaacaaahacaaaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r2.xyz, r0.x, v3
abaaaaaaacaaahacacaaaakeacaaaaaaafaaaakeacaaaaaa add r2.xyz, r2.xyzz, r5.xyzz
bcaaaaaaaaaaabacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.x, r2.xyzz, r2.xyzz
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
adaaaaaaacaaahacabaaaaaaacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r1.x, r2.xyzz
adaaaaaaaaaaabacabaaaappacaaaaaaaaaaaappacaaaaaa mul r0.x, r1.w, r0.w
bcaaaaaaacaaabacabaaaaoeaeaaaaaaacaaaakeacaaaaaa dp3 r2.x, v1, r2.xyzz
aaaaaaaaabaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.x, c3
adaaaaaaabaaabacaeaaaaffabaaaaaaabaaaaaaacaaaaaa mul r1.x, c4.y, r1.x
ahaaaaaaacaaabacacaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r2.x, r2.x, c4
alaaaaaaaeaaapacacaaaaaaacaaaaaaabaaaaaaacaaaaaa pow r4, r2.x, r1.x
adaaaaaaacaaahacadaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r3.xyzz, c2
adaaaaaaadaaahacacaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r3.xyz, r2.xyzz, v7
aaaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r4.x
bcaaaaaaacaaabacabaaaaoeaeaaaaaaafaaaakeacaaaaaa dp3 r2.x, v1, r5.xyzz
adaaaaaaadaaahacadaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c0
ahaaaaaaacaaabacacaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r2.x, r2.x, c4
adaaaaaaacaaahacadaaaakeacaaaaaaacaaaaaaacaaaaaa mul r2.xyz, r3.xyzz, r2.x
aaaaaaaaaeaaahacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r4.xyz, c0
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa mul r0.x, r0.x, c4.z
adaaaaaaabaaabacabaaaaaaacaaaaaaadaaaappacaaaaaa mul r1.x, r1.x, r3.w
adaaaaaaadaaahacabaaaaoeabaaaaaaaeaaaakeacaaaaaa mul r3.xyz, c1, r4.xyzz
adaaaaaaabaaahacadaaaakeacaaaaaaabaaaaaaacaaaaaa mul r1.xyz, r3.xyzz, r1.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
aaaaaaaaaaaaaiacaeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c4.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 27 ALU, 2 TEX
PARAM c[5] = { program.local[0..3],
		{ 0, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[4], texture[1], 2D;
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[2];
MOV R1.xyz, fragment.texcoord[2];
RSQ R2.x, R2.x;
MAD R2.xyz, R2.x, fragment.texcoord[3], R1;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
DP3 R2.x, fragment.texcoord[1], R2;
MOV R2.w, c[4].y;
MUL R0.xyz, R0, fragment.color.primary;
MUL R2.y, R2.w, c[3].x;
MAX R2.x, R2, c[4];
POW R2.x, R2.x, R2.y;
MUL R0.w, R2.x, R0;
DP3 R2.x, fragment.texcoord[1], R1;
MUL R1.xyz, R0, c[0];
MAX R2.x, R2, c[4];
MOV R0.xyz, c[1];
MUL R1.xyz, R1, R2.x;
MUL R0.xyz, R0, c[0];
MUL R1.w, R1, c[4].z;
MAD R0.xyz, R0, R0.w, R1;
MUL result.color.xyz, R0, R1.w;
MOV result.color.w, c[4].x;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 30 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00000000, 128.00000000, 2.00000000, 0
dcl t0.xy
dcl v0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xy
texld r0, t4, s1
texld r2, t0, s0
dp3_pp r0.x, t3, t3
mul_pp r2.xyz, r2, c2
mul r2.xyz, r2, v0
rsq_pp r0.x, r0.x
mov_pp r1.xyz, t2
mad_pp r1.xyz, r0.x, t3, r1
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, r1
dp3_pp r1.x, t1, r1
mov_pp r0.x, c3
mul_pp r0.x, c4.y, r0
max_pp r1.x, r1, c4
pow r3.w, r1.x, r0.x
mov r0.x, r3.w
mul r0.x, r0, r2.w
mov_pp r1.xyz, t2
dp3_pp r1.x, t1, r1
max_pp r1.x, r1, c4
mul_pp r2.xyz, r2, c0
mul_pp r3.xyz, r2, r1.x
mul_pp r1.x, r0.w, c4.z
mov_pp r2.xyz, c0
mul_pp r2.xyz, c1, r2
mad r0.xyz, r2, r0.x, r3
mul r0.xyz, r0, r1.x
mov_pp r0.w, c4.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_SpecColor]
Vector 2 [_Color]
Float 3 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c4 0.0 128.0 2.0 0.0
[bc]
ciaaaaaaaaaaapacaeaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v4, s1 <2d wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
adaaaaaaacaaahacacaaaakeacaaaaaaahaaaaoeaeaaaaaa mul r2.xyz, r2.xyzz, v7
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
aaaaaaaaabaaahacacaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v2
adaaaaaaadaaahacaaaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r3.xyz, r0.x, v3
abaaaaaaabaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r3.xyzz, r1.xyzz
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaabaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r0.x, r1.xyzz
bcaaaaaaabaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v1, r1.xyzz
aaaaaaaaaaaaabacadaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c3
adaaaaaaaaaaabacaeaaaaffabaaaaaaaaaaaaaaacaaaaaa mul r0.x, c4.y, r0.x
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
alaaaaaaadaaapacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa pow r3, r1.x, r0.x
aaaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaappacaaaaaa mul r0.x, r0.x, r2.w
aaaaaaaaabaaahacacaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v2
bcaaaaaaabaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v1, r1.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
adaaaaaaadaaahacacaaaakeacaaaaaaabaaaaaaacaaaaaa mul r3.xyz, r2.xyzz, r1.x
adaaaaaaabaaabacaaaaaappacaaaaaaaeaaaakkabaaaaaa mul r1.x, r0.w, c4.z
aaaaaaaaacaaahacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.xyz, c0
adaaaaaaacaaahacabaaaaoeabaaaaaaacaaaakeacaaaaaa mul r2.xyz, c1, r2.xyzz
adaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r2.xyzz, r0.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaaaacaaaaaa mul r0.xyz, r0.xyzz, r1.x
aaaaaaaaaaaaaiacaeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c4.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 8 to 8
//   d3d9 - ALU: 8 to 8
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
"!!ARBvp1.0
# 8 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 8 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
"vs_2_0
; 8 ALU
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c8.w
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD0;
uniform mediump float _Shininess;
void main ()
{
  lowp vec4 res;
  res.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res.w = _Shininess;
  gl_FragData[0] = res;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD0;
uniform mediump float _Shininess;
void main ()
{
  lowp vec4 res;
  res.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res.w = _Shininess;
  gl_FragData[0] = res;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 2 to 2, TEX: 0 to 0
//   d3d9 - ALU: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_Shininess]
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 2 ALU, 0 TEX
PARAM c[2] = { program.local[0],
		{ 0.5 } };
MAD result.color.xyz, fragment.texcoord[0], c[1].x, c[1].x;
MOV result.color.w, c[0].x;
END
# 2 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_Shininess]
"ps_2_0
; 3 ALU
def c1, 0.50000000, 0, 0, 0
dcl t0.xyz
mad_pp r0.xyz, t0, c1.x, c1.x
mov_pp r0.w, c0.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 21 to 29
//   d3d9 - ALU: 21 to 29
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Matrix 5 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 29 ALU
PARAM c[19] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[10].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[13];
DP4 R2.y, R0, c[12];
DP4 R2.x, R0, c[11];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[16];
DP4 R3.y, R1, c[15];
DP4 R3.x, R1, c[14];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[17];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[1].xy, R0, R0.z;
MOV result.position, R1;
MOV result.color, vertex.color;
MOV result.texcoord[1].zw, R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 29 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Matrix 4 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"vs_2_0
; 29 ALU
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r1.xyz, v1, c10.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c19.y
dp4 r2.z, r0, c13
dp4 r2.y, r0, c12
dp4 r2.x, r0, c11
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c16
dp4 r3.y, r1, c15
dp4 r3.x, r1, c14
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c17
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c19.x
mul r0.y, r0, c8.x
add oT2.xyz, r3, r2
mad oT1.xy, r0.z, c9.zwzw, r0
mov oPos, r1
mov oD0, v3
mov oT1.zw, r1
mad oT0.xy, v2, c18, c18.zwzw
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = (tmpvar_5 * (normalize (_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  tmpvar_1 = tmpvar_7;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  mediump vec4 tmpvar_7;
  tmpvar_7 = -(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001))));
  light = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7.xyz + xlv_TEXCOORD2);
  light.xyz = tmpvar_8;
  lowp vec4 c_i0;
  lowp float spec;
  mediump float tmpvar_9;
  tmpvar_9 = (tmpvar_7.w * tmpvar_4.w);
  spec = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_3 * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
  c_i0.xyz = tmpvar_10;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = (tmpvar_5 * (normalize (_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  tmpvar_1 = tmpvar_7;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  mediump vec4 tmpvar_7;
  tmpvar_7 = -(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001))));
  light = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7.xyz + xlv_TEXCOORD2);
  light.xyz = tmpvar_8;
  lowp vec4 c_i0;
  lowp float spec;
  mediump float tmpvar_9;
  tmpvar_9 = (tmpvar_7.w * tmpvar_4.w);
  spec = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_3 * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
  c_i0.xyz = tmpvar_10;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Vector 13 [_ProjectionParams]
Matrix 9 [_Object2World]
Vector 14 [unity_LightmapST]
Vector 15 [unity_ShadowFadeCenterAndType]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 21 ALU
PARAM c[17] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..16] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[15].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[15];
MOV result.color, vertex.color;
MOV result.texcoord[1].zw, R0;
MUL result.texcoord[3].xyz, R1, c[15].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[14], c[14].zwzw;
MUL result.texcoord[3].w, -R0.x, R0.y;
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Matrix 8 [_Object2World]
Vector 14 [unity_LightmapST]
Vector 15 [unity_ShadowFadeCenterAndType]
Vector 16 [_MainTex_ST]
"vs_2_0
; 21 ALU
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dcl_color0 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
mad oT1.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov r0.x, c15.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c15
mov oD0, v3
mov oT1.zw, r0
mul oT3.xyz, r1, c15.w
mad oT0.xy, v1, c16, c16.zwzw
mad oT2.xy, v2, c14, c14.zwzw
mul oT3.w, -r0.x, r0.y
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec3 lmIndirect;
  mediump vec3 lmFull;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  mediump vec4 tmpvar_7;
  tmpvar_7 = -(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001))));
  light = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lmFull = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  lmIndirect = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = vec3(clamp (((length (xlv_TEXCOORD3) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0));
  light.xyz = (tmpvar_7.xyz + mix (lmIndirect, lmFull, tmpvar_10));
  lowp vec4 c_i0;
  lowp float spec;
  mediump float tmpvar_11;
  tmpvar_11 = (tmpvar_7.w * tmpvar_4.w);
  spec = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_3 * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
  c_i0.xyz = tmpvar_12;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec3 lmIndirect;
  mediump vec3 lmFull;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  mediump vec4 tmpvar_7;
  tmpvar_7 = -(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001))));
  light = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  lmFull = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((8.0 * tmpvar_10.w) * tmpvar_10.xyz);
  lmIndirect = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = vec3(clamp (((length (xlv_TEXCOORD3) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0));
  light.xyz = (tmpvar_7.xyz + mix (lmIndirect, lmFull, tmpvar_12));
  lowp vec4 c_i0;
  lowp float spec;
  mediump float tmpvar_13;
  tmpvar_13 = (tmpvar_7.w * tmpvar_4.w);
  spec = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_3 * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
  c_i0.xyz = tmpvar_14;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 12 [unity_LightmapST]
Vector 13 [_MainTex_ST]
"!!ARBvp1.0
# 25 ALU
PARAM c[14] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R3.xyz, R0, vertex.attrib[14].w;
MOV R1.xyz, c[11];
MOV R1.w, c[0].y;
DP4 R2.z, R1, c[7];
DP4 R2.x, R1, c[5];
DP4 R2.y, R1, c[6];
MAD R1.xyz, R2, c[10].w, -vertex.position;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].x;
MUL R2.y, R2, c[9].x;
DP3 result.texcoord[3].y, R1, R3;
ADD result.texcoord[1].xy, R2, R2.z;
DP3 result.texcoord[3].z, vertex.normal, R1;
DP3 result.texcoord[3].x, R1, vertex.attrib[14];
MOV result.position, R0;
MOV result.color, vertex.color;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[12], c[12].zwzw;
END
# 25 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 12 [unity_LightmapST]
Vector 13 [_MainTex_ST]
"vs_2_0
; 26 ALU
def c14, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r1.xyz, c11
mov r1.w, c14.y
dp4 r2.z, r1, c6
dp4 r2.x, r1, c4
dp4 r2.y, r1, c5
mad r1.xyz, r2, c10.w, -v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c14.x
mul r2.y, r2, c8.x
dp3 oT3.y, r1, r3
mad oT1.xy, r2.z, c9.zwzw, r2
dp3 oT3.z, v2, r1
dp3 oT3.x, r1, v1
mov oPos, r0
mov oD0, v5
mov oT1.zw, r0
mad oT0.xy, v3, c13, c13.zwzw
mad oT2.xy, v4, c12, c12.zwzw
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_3.zw;
  highp mat3 tmpvar_6;
  tmpvar_6[0] = tmpvar_1.xyz;
  tmpvar_6[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_6[2] = tmpvar_2;
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_6[0].x;
  tmpvar_7[0].y = tmpvar_6[1].x;
  tmpvar_7[0].z = tmpvar_6[2].x;
  tmpvar_7[1].x = tmpvar_6[0].y;
  tmpvar_7[1].y = tmpvar_6[1].y;
  tmpvar_7[1].z = tmpvar_6[2].y;
  tmpvar_7[2].x = tmpvar_6[0].z;
  tmpvar_7[2].y = tmpvar_6[1].z;
  tmpvar_7[2].z = tmpvar_6[2].z;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_7 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (xlv_TEXCOORD3);
  mediump vec4 tmpvar_8;
  mediump vec3 viewDir;
  viewDir = tmpvar_7;
  highp float nh;
  mediump vec3 scalePerBasisVector_i0;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_9;
  tmpvar_9 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_i0 = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  scalePerBasisVector_i0 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (vec3(0.0, 0.0, 1.0), normalize ((normalize ((((scalePerBasisVector_i0.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_i0.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_i0.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir))));
  nh = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = lm_i0;
  tmpvar_12.w = pow (nh, (_Shininess * 128.0));
  tmpvar_8 = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (-(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_8);
  light = tmpvar_13;
  lowp vec4 c_i0;
  lowp float spec_i0;
  mediump float tmpvar_14;
  tmpvar_14 = (tmpvar_13.w * tmpvar_4.w);
  spec_i0 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_3 * tmpvar_13.xyz) + ((tmpvar_13.xyz * _SpecColor.xyz) * spec_i0));
  c_i0.xyz = tmpvar_15;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec_i0 * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_3.zw;
  highp mat3 tmpvar_6;
  tmpvar_6[0] = tmpvar_1.xyz;
  tmpvar_6[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_6[2] = tmpvar_2;
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_6[0].x;
  tmpvar_7[0].y = tmpvar_6[1].x;
  tmpvar_7[0].z = tmpvar_6[2].x;
  tmpvar_7[1].x = tmpvar_6[0].y;
  tmpvar_7[1].y = tmpvar_6[1].y;
  tmpvar_7[1].z = tmpvar_6[2].y;
  tmpvar_7[2].x = tmpvar_6[0].z;
  tmpvar_7[2].y = tmpvar_6[1].z;
  tmpvar_7[2].z = tmpvar_6[2].z;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_7 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD3);
  mediump vec4 tmpvar_10;
  mediump vec3 viewDir;
  viewDir = tmpvar_9;
  highp float nh;
  mediump vec3 scalePerBasisVector_i0;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((8.0 * tmpvar_7.w) * tmpvar_7.xyz);
  lm_i0 = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  scalePerBasisVector_i0 = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (vec3(0.0, 0.0, 1.0), normalize ((normalize ((((scalePerBasisVector_i0.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_i0.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_i0.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir))));
  nh = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = lm_i0;
  tmpvar_14.w = pow (nh, (_Shininess * 128.0));
  tmpvar_10 = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (-(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_10);
  light = tmpvar_15;
  lowp vec4 c_i0;
  lowp float spec_i0;
  mediump float tmpvar_16;
  tmpvar_16 = (tmpvar_15.w * tmpvar_4.w);
  spec_i0 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = ((tmpvar_3 * tmpvar_15.xyz) + ((tmpvar_15.xyz * _SpecColor.xyz) * spec_i0));
  c_i0.xyz = tmpvar_17;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec_i0 * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Matrix 5 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 29 ALU
PARAM c[19] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[10].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[13];
DP4 R2.y, R0, c[12];
DP4 R2.x, R0, c[11];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[16];
DP4 R3.y, R1, c[15];
DP4 R3.x, R1, c[14];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[17];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[1].xy, R0, R0.z;
MOV result.position, R1;
MOV result.color, vertex.color;
MOV result.texcoord[1].zw, R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 29 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Matrix 4 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"vs_2_0
; 29 ALU
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mul r1.xyz, v1, c10.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c19.y
dp4 r2.z, r0, c13
dp4 r2.y, r0, c12
dp4 r2.x, r0, c11
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c16
dp4 r3.y, r1, c15
dp4 r3.x, r1, c14
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c17
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c19.x
mul r0.y, r0, c8.x
add oT2.xyz, r3, r2
mad oT1.xy, r0.z, c9.zwzw, r0
mov oPos, r1
mov oD0, v3
mov oT1.zw, r1
mad oT0.xy, v2, c18, c18.zwzw
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = (tmpvar_5 * (normalize (_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  tmpvar_1 = tmpvar_7;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  mediump vec4 tmpvar_7;
  tmpvar_7 = max (light, vec4(0.001, 0.001, 0.001, 0.001));
  light = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7.xyz + xlv_TEXCOORD2);
  light.xyz = tmpvar_8;
  lowp vec4 c_i0;
  lowp float spec;
  mediump float tmpvar_9;
  tmpvar_9 = (tmpvar_7.w * tmpvar_4.w);
  spec = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_3 * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
  c_i0.xyz = tmpvar_10;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = (tmpvar_5 * (normalize (_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  tmpvar_1 = tmpvar_7;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  mediump vec4 tmpvar_7;
  tmpvar_7 = max (light, vec4(0.001, 0.001, 0.001, 0.001));
  light = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7.xyz + xlv_TEXCOORD2);
  light.xyz = tmpvar_8;
  lowp vec4 c_i0;
  lowp float spec;
  mediump float tmpvar_9;
  tmpvar_9 = (tmpvar_7.w * tmpvar_4.w);
  spec = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_3 * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
  c_i0.xyz = tmpvar_10;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Vector 13 [_ProjectionParams]
Matrix 9 [_Object2World]
Vector 14 [unity_LightmapST]
Vector 15 [unity_ShadowFadeCenterAndType]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 21 ALU
PARAM c[17] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..16] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[15].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[15];
MOV result.color, vertex.color;
MOV result.texcoord[1].zw, R0;
MUL result.texcoord[3].xyz, R1, c[15].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[14], c[14].zwzw;
MUL result.texcoord[3].w, -R0.x, R0.y;
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Matrix 8 [_Object2World]
Vector 14 [unity_LightmapST]
Vector 15 [unity_ShadowFadeCenterAndType]
Vector 16 [_MainTex_ST]
"vs_2_0
; 21 ALU
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dcl_color0 v3
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
mad oT1.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov r0.x, c15.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c15
mov oD0, v3
mov oT1.zw, r0
mul oT3.xyz, r1, c15.w
mad oT0.xy, v1, c16, c16.zwzw
mad oT2.xy, v2, c14, c14.zwzw
mul oT3.w, -r0.x, r0.y
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec3 lmIndirect;
  mediump vec3 lmFull;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  mediump vec4 tmpvar_7;
  tmpvar_7 = max (light, vec4(0.001, 0.001, 0.001, 0.001));
  light = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lmFull = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  lmIndirect = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = vec3(clamp (((length (xlv_TEXCOORD3) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0));
  light.xyz = (tmpvar_7.xyz + mix (lmIndirect, lmFull, tmpvar_10));
  lowp vec4 c_i0;
  lowp float spec;
  mediump float tmpvar_11;
  tmpvar_11 = (tmpvar_7.w * tmpvar_4.w);
  spec = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = ((tmpvar_3 * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
  c_i0.xyz = tmpvar_12;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec3 lmIndirect;
  mediump vec3 lmFull;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  mediump vec4 tmpvar_7;
  tmpvar_7 = max (light, vec4(0.001, 0.001, 0.001, 0.001));
  light = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec3 tmpvar_9;
  tmpvar_9 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  lmFull = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((8.0 * tmpvar_10.w) * tmpvar_10.xyz);
  lmIndirect = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = vec3(clamp (((length (xlv_TEXCOORD3) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0));
  light.xyz = (tmpvar_7.xyz + mix (lmIndirect, lmFull, tmpvar_12));
  lowp vec4 c_i0;
  lowp float spec;
  mediump float tmpvar_13;
  tmpvar_13 = (tmpvar_7.w * tmpvar_4.w);
  spec = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = ((tmpvar_3 * light.xyz) + ((light.xyz * _SpecColor.xyz) * spec));
  c_i0.xyz = tmpvar_14;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 12 [unity_LightmapST]
Vector 13 [_MainTex_ST]
"!!ARBvp1.0
# 25 ALU
PARAM c[14] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R3.xyz, R0, vertex.attrib[14].w;
MOV R1.xyz, c[11];
MOV R1.w, c[0].y;
DP4 R2.z, R1, c[7];
DP4 R2.x, R1, c[5];
DP4 R2.y, R1, c[6];
MAD R1.xyz, R2, c[10].w, -vertex.position;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].x;
MUL R2.y, R2, c[9].x;
DP3 result.texcoord[3].y, R1, R3;
ADD result.texcoord[1].xy, R2, R2.z;
DP3 result.texcoord[3].z, vertex.normal, R1;
DP3 result.texcoord[3].x, R1, vertex.attrib[14];
MOV result.position, R0;
MOV result.color, vertex.color;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[12], c[12].zwzw;
END
# 25 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Vector 11 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 12 [unity_LightmapST]
Vector 13 [_MainTex_ST]
"vs_2_0
; 26 ALU
def c14, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_texcoord1 v4
dcl_color0 v5
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r0, v1.w
mov r1.xyz, c11
mov r1.w, c14.y
dp4 r2.z, r1, c6
dp4 r2.x, r1, c4
dp4 r2.y, r1, c5
mad r1.xyz, r2, c10.w, -v0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c14.x
mul r2.y, r2, c8.x
dp3 oT3.y, r1, r3
mad oT1.xy, r2.z, c9.zwzw, r2
dp3 oT3.z, v2, r1
dp3 oT3.x, r1, v1
mov oPos, r0
mov oD0, v5
mov oT1.zw, r0
mad oT0.xy, v3, c13, c13.zwzw
mad oT2.xy, v4, c12, c12.zwzw
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_3.zw;
  highp mat3 tmpvar_6;
  tmpvar_6[0] = tmpvar_1.xyz;
  tmpvar_6[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_6[2] = tmpvar_2;
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_6[0].x;
  tmpvar_7[0].y = tmpvar_6[1].x;
  tmpvar_7[0].z = tmpvar_6[2].x;
  tmpvar_7[1].x = tmpvar_6[0].y;
  tmpvar_7[1].y = tmpvar_6[1].y;
  tmpvar_7[1].z = tmpvar_6[2].y;
  tmpvar_7[2].x = tmpvar_6[0].z;
  tmpvar_7[2].y = tmpvar_6[1].z;
  tmpvar_7[2].z = tmpvar_6[2].z;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_7 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize (xlv_TEXCOORD3);
  mediump vec4 tmpvar_8;
  mediump vec3 viewDir;
  viewDir = tmpvar_7;
  highp float nh;
  mediump vec3 scalePerBasisVector_i0;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_9;
  tmpvar_9 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_i0 = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  scalePerBasisVector_i0 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (vec3(0.0, 0.0, 1.0), normalize ((normalize ((((scalePerBasisVector_i0.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_i0.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_i0.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir))));
  nh = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = lm_i0;
  tmpvar_12.w = pow (nh, (_Shininess * 128.0));
  tmpvar_8 = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (max (light, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_8);
  light = tmpvar_13;
  lowp vec4 c_i0;
  lowp float spec_i0;
  mediump float tmpvar_14;
  tmpvar_14 = (tmpvar_13.w * tmpvar_4.w);
  spec_i0 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = ((tmpvar_3 * tmpvar_13.xyz) + ((tmpvar_13.xyz * _SpecColor.xyz) * spec_i0));
  c_i0.xyz = tmpvar_15;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec_i0 * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_5 + tmpvar_4.w);
  o_i0.zw = tmpvar_3.zw;
  highp mat3 tmpvar_6;
  tmpvar_6[0] = tmpvar_1.xyz;
  tmpvar_6[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_6[2] = tmpvar_2;
  mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_6[0].x;
  tmpvar_7[0].y = tmpvar_6[1].x;
  tmpvar_7[0].z = tmpvar_6[2].x;
  tmpvar_7[1].x = tmpvar_6[0].y;
  tmpvar_7[1].y = tmpvar_6[1].y;
  tmpvar_7[1].z = tmpvar_6[2].y;
  tmpvar_7[2].x = tmpvar_6[0].z;
  tmpvar_7[2].y = tmpvar_6[1].z;
  tmpvar_7[2].z = tmpvar_6[2].z;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = _WorldSpaceCameraPos;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (tmpvar_7 * (((_World2Object * tmpvar_8).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  highp vec4 tmpvar_2;
  tmpvar_2 = xlv_COLOR0;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec3 tmpvar_5;
  tmpvar_5 = ((tmpvar_4.xyz * _Color.xyz) * tmpvar_2.xyz);
  tmpvar_3 = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (xlv_TEXCOORD3);
  mediump vec4 tmpvar_10;
  mediump vec3 viewDir;
  viewDir = tmpvar_9;
  highp float nh;
  mediump vec3 scalePerBasisVector_i0;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((8.0 * tmpvar_7.w) * tmpvar_7.xyz);
  lm_i0 = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((8.0 * tmpvar_8.w) * tmpvar_8.xyz);
  scalePerBasisVector_i0 = tmpvar_12;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (vec3(0.0, 0.0, 1.0), normalize ((normalize ((((scalePerBasisVector_i0.x * vec3(0.816497, 0.0, 0.57735)) + (scalePerBasisVector_i0.y * vec3(-0.408248, 0.707107, 0.57735))) + (scalePerBasisVector_i0.z * vec3(-0.408248, -0.707107, 0.57735)))) + viewDir))));
  nh = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = lm_i0;
  tmpvar_14.w = pow (nh, (_Shininess * 128.0));
  tmpvar_10 = tmpvar_14;
  mediump vec4 tmpvar_15;
  tmpvar_15 = (max (light, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_10);
  light = tmpvar_15;
  lowp vec4 c_i0;
  lowp float spec_i0;
  mediump float tmpvar_16;
  tmpvar_16 = (tmpvar_15.w * tmpvar_4.w);
  spec_i0 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = ((tmpvar_3 * tmpvar_15.xyz) + ((tmpvar_15.xyz * _SpecColor.xyz) * spec_i0));
  c_i0.xyz = tmpvar_17;
  c_i0.w = ((tmpvar_4.w * _Color.w) + (spec_i0 * _SpecColor.w));
  c = c_i0;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 11 to 37, TEX: 2 to 4
//   d3d9 - ALU: 10 to 40, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 15 ALU, 2 TEX
PARAM c[2] = { program.local[0..1] };
TEMP R0;
TEMP R1;
TEMP R2;
TXP R1, fragment.texcoord[1], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
LG2 R1.w, R1.w;
MUL R0.xyz, R0, c[1];
MUL R1.w, R0, -R1;
LG2 R1.x, R1.x;
LG2 R1.z, R1.z;
LG2 R1.y, R1.y;
ADD R1.xyz, -R1, fragment.texcoord[2];
MUL R2.xyz, R1, c[0];
MUL R2.xyz, R1.w, R2;
MUL R1.w, R1, c[0];
MUL R0.xyz, R0, fragment.color.primary;
MAD result.color.xyz, R0, R1, R2;
MAD result.color.w, R0, c[1], R1;
END
# 15 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"ps_2_0
; 14 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
dcl t0.xy
dcl v0.xyz
dcl t1
dcl t2.xyz
texldp r0, t1, s1
texld r1, t0, s0
mul_pp r1.xyz, r1, c1
log_pp r0.x, r0.x
log_pp r0.z, r0.z
log_pp r0.y, r0.y
add_pp r2.xyz, -r0, t2
log_pp r0.x, r0.w
mul_pp r0.x, r1.w, -r0
mul_pp r3.xyz, r2, c0
mul_pp r3.xyz, r0.x, r3
mul_pp r0.x, r0, c0.w
mul r1.xyz, r1, v0
mad_pp r1.xyz, r1, r2, r3
mad_pp r1.w, r1, c1, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Vector 2 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 26 ALU, 4 TEX
PARAM c[4] = { program.local[0..2],
		{ 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TXP R1, fragment.texcoord[1], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R3, fragment.texcoord[2], texture[2], 2D;
TEX R2, fragment.texcoord[2], texture[3], 2D;
MUL R3.xyz, R3.w, R3;
MUL R2.xyz, R2.w, R2;
MUL R2.xyz, R2, c[3].x;
DP4 R3.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R2.w, R3.w;
RCP R2.w, R2.w;
LG2 R1.w, R1.w;
MUL R0.xyz, R0, c[1];
MUL R1.w, R0, -R1;
MAD R3.xyz, R3, c[3].x, -R2;
MAD_SAT R2.w, R2, c[2].z, c[2];
MAD R2.xyz, R2.w, R3, R2;
LG2 R1.x, R1.x;
LG2 R1.y, R1.y;
LG2 R1.z, R1.z;
ADD R1.xyz, -R1, R2;
MUL R2.xyz, R1, c[0];
MUL R2.xyz, R1.w, R2;
MUL R1.w, R1, c[0];
MUL R0.xyz, R0, fragment.color.primary;
MAD result.color.xyz, R0, R1, R2;
MAD result.color.w, R0, c[1], R1;
END
# 26 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Vector 2 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 23 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c3, 8.00000000, 0, 0, 0
dcl t0.xy
dcl v0.xyz
dcl t1
dcl t2.xy
dcl t3
texld r2, t0, s0
texldp r1, t1, s1
texld r0, t2, s2
texld r3, t2, s3
mul_pp r4.xyz, r0.w, r0
mul_pp r3.xyz, r3.w, r3
mul_pp r3.xyz, r3, c3.x
dp4 r0.x, t3, t3
rsq r0.x, r0.x
rcp r0.x, r0.x
mul_pp r2.xyz, r2, c1
mad_pp r4.xyz, r4, c3.x, -r3
mad_sat r0.x, r0, c2.z, c2.w
mad_pp r0.xyz, r0.x, r4, r3
log_pp r1.x, r1.x
log_pp r1.y, r1.y
log_pp r1.z, r1.z
add_pp r1.xyz, -r1, r0
log_pp r0.x, r1.w
mul_pp r3.xyz, r1, c0
mul_pp r0.x, r2.w, -r0
mul_pp r3.xyz, r0.x, r3
mul_pp r0.x, r0, c0.w
mul r2.xyz, r2, v0
mad_pp r1.xyz, r2, r1, r3
mad_pp r1.w, r2, c1, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 37 ALU, 4 TEX
PARAM c[6] = { program.local[0..2],
		{ 8, -0.40824828, -0.70710677, 0.57735026 },
		{ 0.81649655, 0, 0.57735026, 128 },
		{ -0.40824831, 0.70710677, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TXP R1, fragment.texcoord[1], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R3, fragment.texcoord[2], texture[3], 2D;
TEX R2, fragment.texcoord[2], texture[2], 2D;
MUL R3.xyz, R3.w, R3;
MUL R3.xyz, R3, c[3].x;
MUL R4.xyz, R3.y, c[5];
MAD R4.xyz, R3.x, c[4], R4;
MAD R3.xyz, R3.z, c[3].yzww, R4;
DP3 R3.w, R3, R3;
RSQ R4.x, R3.w;
DP3 R3.w, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[1];
RSQ R3.w, R3.w;
MUL R3.xyz, R4.x, R3;
MAD R3.xyz, R3.w, fragment.texcoord[3], R3;
DP3 R3.x, R3, R3;
RSQ R3.y, R3.x;
MUL R3.y, R3, R3.z;
MOV R3.x, c[4].w;
MUL R3.z, R3.x, c[2].x;
MAX R3.x, R3.y, c[4].y;
POW R3.w, R3.x, R3.z;
MUL R2.xyz, R2.w, R2;
MUL R3.xyz, R2, c[3].x;
LG2 R1.x, R1.x;
LG2 R1.y, R1.y;
LG2 R1.z, R1.z;
LG2 R1.w, R1.w;
ADD R1, -R1, R3;
MUL R1.w, R0, R1;
MUL R2.xyz, R1, c[0];
MUL R2.xyz, R1.w, R2;
MUL R1.w, R1, c[0];
MUL R0.xyz, R0, fragment.color.primary;
MAD result.color.xyz, R1, R0, R2;
MAD result.color.w, R0, c[1], R1;
END
# 37 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 40 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c3, 8.00000000, -0.40824831, 0.70710677, 0.57735026
def c4, 0.81649655, 0.00000000, 0.57735026, 128.00000000
def c5, -0.40824828, -0.70710677, 0.57735026, 0
dcl t0.xy
dcl v0.xyz
dcl t1
dcl t2.xy
dcl t3.xyz
texld r4, t0, s0
texld r2, t2, s2
texld r0, t2, s3
texldp r3, t1, s1
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r0, c3.x
mov r0.x, c3.y
mov r0.z, c3.w
mov r0.y, c3.z
mul r0.xyz, r1.y, r0
mad r0.xyz, r1.x, c4, r0
mad r5.xyz, r1.z, c5, r0
dp3 r0.x, r5, r5
rsq r1.x, r0.x
dp3_pp r0.x, t3, t3
mul r1.xyz, r1.x, r5
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, t3, r1
dp3_pp r0.x, r0, r0
rsq_pp r1.x, r0.x
mul_pp r0.z, r1.x, r0
max_pp r1.x, r0.z, c4.y
mov_pp r0.x, c2
mul_pp r0.x, c4.w, r0
pow r5.x, r1.x, r0.x
mul_pp r1.xyz, r2.w, r2
log_pp r0.x, r3.x
log_pp r0.y, r3.y
log_pp r0.z, r3.z
mul_pp r3.xyz, r4, c1
mov r1.w, r5.x
log_pp r0.w, r3.w
mul_pp r1.xyz, r1, c3.x
add_pp r1, -r0, r1
mul_pp r0.x, r4.w, r1.w
mul_pp r2.xyz, r1, c0
mul_pp r2.xyz, r0.x, r2
mul_pp r0.x, r0, c0.w
mul r3.xyz, r3, v0
mad_pp r1.xyz, r1, r3, r2
mad_pp r1.w, r4, c1, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 11 ALU, 2 TEX
PARAM c[2] = { program.local[0..1] };
TEMP R0;
TEMP R1;
TEMP R2;
TXP R1, fragment.texcoord[1], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R2.w, R0, R1;
ADD R1.xyz, R1, fragment.texcoord[2];
MUL R1.w, R2, c[0];
MUL R2.xyz, R1, c[0];
MUL R0.xyz, R0, c[1];
MUL R2.xyz, R2.w, R2;
MUL R0.xyz, R0, fragment.color.primary;
MAD result.color.xyz, R0, R1, R2;
MAD result.color.w, R0, c[1], R1;
END
# 11 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"ps_2_0
; 10 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
dcl t0.xy
dcl v0.xyz
dcl t1
dcl t2.xyz
texldp r0, t1, s1
texld r2, t0, s0
add_pp r3.xyz, r0, t2
mul_pp r1.x, r2.w, r0.w
mul_pp r0.x, r1, c0.w
mul_pp r4.xyz, r3, c0
mul_pp r2.xyz, r2, c1
mul_pp r1.xyz, r1.x, r4
mul r2.xyz, r2, v0
mad_pp r1.xyz, r2, r3, r1
mad_pp r1.w, r2, c1, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Vector 2 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 22 ALU, 4 TEX
PARAM c[4] = { program.local[0..2],
		{ 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R1, fragment.texcoord[1], texture[1], 2D;
TEX R3, fragment.texcoord[2], texture[2], 2D;
TEX R2, fragment.texcoord[2], texture[3], 2D;
MUL R3.xyz, R3.w, R3;
MUL R2.xyz, R2.w, R2;
MUL R2.xyz, R2, c[3].x;
DP4 R3.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R2.w, R3.w;
RCP R2.w, R2.w;
MUL R0.xyz, R0, c[1];
MUL R1.w, R0, R1;
MAD R3.xyz, R3, c[3].x, -R2;
MAD_SAT R2.w, R2, c[2].z, c[2];
MAD R2.xyz, R2.w, R3, R2;
ADD R1.xyz, R1, R2;
MUL R2.xyz, R1, c[0];
MUL R2.xyz, R1.w, R2;
MUL R1.w, R1, c[0];
MUL R0.xyz, R0, fragment.color.primary;
MAD result.color.xyz, R0, R1, R2;
MAD result.color.w, R0, c[1], R1;
END
# 22 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Vector 2 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c3, 8.00000000, 0, 0, 0
dcl t0.xy
dcl v0.xyz
dcl t1
dcl t2.xy
dcl t3
texld r2, t0, s0
texldp r1, t1, s1
texld r0, t2, s2
texld r3, t2, s3
mul_pp r4.xyz, r0.w, r0
dp4 r0.x, t3, t3
mul_pp r3.xyz, r3.w, r3
mul_pp r3.xyz, r3, c3.x
rsq r0.x, r0.x
rcp r0.x, r0.x
mul_pp r2.xyz, r2, c1
mad_pp r4.xyz, r4, c3.x, -r3
mad_sat r0.x, r0, c2.z, c2.w
mad_pp r0.xyz, r0.x, r4, r3
add_pp r1.xyz, r1, r0
mul_pp r0.x, r2.w, r1.w
mul_pp r3.xyz, r1, c0
mul_pp r3.xyz, r0.x, r3
mul_pp r0.x, r0, c0.w
mul r2.xyz, r2, v0
mad_pp r1.xyz, r2, r1, r3
mad_pp r1.w, r2, c1, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 33 ALU, 4 TEX
PARAM c[6] = { program.local[0..2],
		{ 8, -0.40824828, -0.70710677, 0.57735026 },
		{ 0.81649655, 0, 0.57735026, 128 },
		{ -0.40824831, 0.70710677, 0.57735026 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R3, fragment.texcoord[2], texture[3], 2D;
TEX R2, fragment.texcoord[2], texture[2], 2D;
TXP R1, fragment.texcoord[1], texture[1], 2D;
MUL R3.xyz, R3.w, R3;
MUL R3.xyz, R3, c[3].x;
MUL R4.xyz, R3.y, c[5];
MAD R4.xyz, R3.x, c[4], R4;
MAD R3.xyz, R3.z, c[3].yzww, R4;
DP3 R3.w, R3, R3;
RSQ R4.x, R3.w;
MUL R2.xyz, R2.w, R2;
DP3 R3.w, fragment.texcoord[3], fragment.texcoord[3];
MUL R0.xyz, R0, c[1];
MUL R2.xyz, R2, c[3].x;
MUL R3.xyz, R4.x, R3;
RSQ R3.w, R3.w;
MAD R3.xyz, R3.w, fragment.texcoord[3], R3;
DP3 R3.x, R3, R3;
RSQ R3.x, R3.x;
MUL R3.y, R3.x, R3.z;
MOV R3.x, c[4].w;
MAX R3.y, R3, c[4];
MUL R3.x, R3, c[2];
POW R2.w, R3.y, R3.x;
ADD R1, R1, R2;
MUL R1.w, R0, R1;
MUL R2.xyz, R1, c[0];
MUL R2.xyz, R1.w, R2;
MUL R1.w, R1, c[0];
MUL R0.xyz, R0, fragment.color.primary;
MAD result.color.xyz, R1, R0, R2;
MAD result.color.w, R0, c[1], R1;
END
# 33 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_SpecColor]
Vector 1 [_Color]
Float 2 [_Shininess]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 36 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c3, 8.00000000, -0.40824831, 0.70710677, 0.57735026
def c4, 0.81649655, 0.00000000, 0.57735026, 128.00000000
def c5, -0.40824828, -0.70710677, 0.57735026, 0
dcl t0.xy
dcl v0.xyz
dcl t1
dcl t2.xy
dcl t3.xyz
texld r4, t0, s0
texldp r3, t1, s1
texld r0, t2, s3
texld r2, t2, s2
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r0, c3.x
mov r0.x, c3.y
mov r0.z, c3.w
mov r0.y, c3.z
mul r0.xyz, r1.y, r0
mad r0.xyz, r1.x, c4, r0
mad r5.xyz, r1.z, c5, r0
dp3 r0.x, r5, r5
rsq r1.x, r0.x
dp3_pp r0.x, t3, t3
mul r1.xyz, r1.x, r5
rsq_pp r0.x, r0.x
mad_pp r0.xyz, r0.x, t3, r1
dp3_pp r0.x, r0, r0
rsq_pp r1.x, r0.x
mul_pp r0.z, r1.x, r0
mov_pp r0.x, c2
max_pp r1.x, r0.z, c4.y
mul_pp r0.x, c4.w, r0
pow r5.x, r1.x, r0.x
mul_pp r0.xyz, r2.w, r2
mul_pp r0.xyz, r0, c3.x
mov r0.w, r5.x
add_pp r1, r3, r0
mul_pp r3.xyz, r4, c1
mul_pp r0.x, r4.w, r1.w
mul_pp r2.xyz, r1, c0
mul_pp r2.xyz, r0.x, r2
mul_pp r0.x, r0, c0.w
mul r3.xyz, r3, v0
mad_pp r1.xyz, r1, r3, r2
mad_pp r1.w, r4, c1, r0.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

}
	}

#LINE 32

}

Fallback "VertexLit"
}
