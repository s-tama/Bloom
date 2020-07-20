// テクスチャブレンド用
Shader "MyProject/BlendTex"
{
    Properties
    {
		[HideInInspector][NoScaleOffset] _MainTex("Texture", 2D) = "white" {}
		[HideInInspector][NoScaleOffset] _BlendTex("Blend Texture", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off 
		ZWrite Off 
		ZTest Always

        Pass
        {
            CGPROGRAM
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			sampler2D _BlendTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c0 = tex2D(_MainTex, i.uv);
				fixed4 c1 = tex2D(_BlendTex, i.uv);
                return c0 * c1;
            }
            ENDCG
        }
    }
}
