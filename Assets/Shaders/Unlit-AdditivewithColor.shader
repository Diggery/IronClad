
Shader "Unlit/Additive with Color" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Color ("Main Color", Color) = (1,1,1,1)
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	ZWrite Off
	Blend One One 

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
