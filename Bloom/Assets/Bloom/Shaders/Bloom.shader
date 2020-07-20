// ブルーム処理
Shader "MyProject/Bloom"
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

		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		float _Threshold;

		// 明度を取得
		half GetBrightness(half3 col)
		{
			return max(col.r, max(col.g, col.b));
		}

		// メインテクスチャのサンプリング
		// 返す値はRGBのみ
		half3 SampleMainRGB(float2 uv)
		{
			return tex2D(_MainTex, uv).rgb;
		}

		// 対角線上の4点をサンプリングした色の平均値を取得
		half3 SampleBox(float2 uv)
		{
			half3 c0 = SampleMainRGB(uv + float2(-_MainTex_TexelSize.x, _MainTex_TexelSize.y));
			half3 c1 = SampleMainRGB(uv + float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y));
			half3 c2 = SampleMainRGB(uv + float2(-_MainTex_TexelSize.x, -_MainTex_TexelSize.y));
			half3 c3 = SampleMainRGB(uv + float2(_MainTex_TexelSize.x, -_MainTex_TexelSize.y));

			return (c0 + c1 + c2 + c3) * 0.25;
		}

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

		// 0: 明度の取得
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

		// 1: ダウンサンプリング
		Pass
		{
			Blend One One

			CGPROGRAM
			fixed4 frag(v2f i) : SV_Target
			{
				return fixed4(SampleBox(i.uv), 1);
			}
			ENDCG
		}
	}
}
