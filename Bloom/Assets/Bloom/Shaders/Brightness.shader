// 輝度抽出用
Shader "MyProject/Brightness"
{
    Properties
    {
        [HideInInspector][NoScaleOffset] _MainTex("Texture", 2D) = "white" {}
		[HideInInspector] _Threshold("Threshold", Range(0, 1)) = 1
    }
    SubShader
    {
		CGINCLUDE
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"

		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float4 vertex : SV_POSITION;
			float2 uv : TEXCOORD0;
		};

		// 明度を取得
		half GetBrightness(half3 col)
		{
			return max(col.r, max(col.g, col.b));
		}

		sampler2D _MainTex;
		float _Threshold;

		v2f vert(appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = v.uv;
			return o;
		}
		ENDCG

        Cull Off 
		ZWrite Off 
		ZTest Always

        Pass
        {
            CGPROGRAM
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);

				half brightness = GetBrightness(col.rgb);
				half contribution = max(0, brightness - _Threshold);
				contribution /= max(brightness, 0.00001);

				return col * contribution;
			}
            ENDCG
        }
    }
}
