
Shader "Unlit/NoCulling" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Color ("Main Color", Color) = (1,1,1,1)
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha 
	cull Off
	Pass {
		Lighting Off
		SetTexture [_MainTex] { 
			constantColor [_Color]
			combine texture * constant 
		} 
	}
}
}
