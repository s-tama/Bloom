﻿// ぼかしに加算処理を追加
Shader "MyProject/AddBlur"
{
	Properties
	{
		[HideInInspector][NoScaleOffset] _MainTex("Texture", 2D) = "white" {}
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
