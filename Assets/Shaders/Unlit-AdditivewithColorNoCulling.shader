
Shader "Unlit/Additive with Color No Culling" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Color ("Main Color", Color) = (1,1,1,1)
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	ZWrite Off
	Blend One One 
	cull Off

	Pass {
        ColorMaterial AmbientAndDiffuse
		Lighting Off
		SetTexture [_MainTex] { 
			constantColor [_Color]
			combine texture * constant 
		} 
	}
}
}
