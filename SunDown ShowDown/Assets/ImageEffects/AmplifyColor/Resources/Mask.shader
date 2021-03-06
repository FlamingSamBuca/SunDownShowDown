// Amplify Color - Advanced Color Grading for Unity Pro
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

Shader "Hidden/Amplify Color/Mask" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
	CGINCLUDE
		#pragma multi_compile _ AC_QUALITY_MOBILE
		#include "Common.cginc"

		inline float4 apply_grading( v2f i, float4 color )
		{
			float mask = tex2D( _MaskTex, i.uv1 ).r;
			return lerp( color, apply( color ), mask );
		}
	ENDCG
	Subshader {
		ZTest Always Cull Off ZWrite Off Blend Off
		Fog { Mode off }

		// 0 LDR GAMMA
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				float4 frag( v2f i ) : SV_Target
				{
					float4 color = fetch_process_ldr_gamma( i );
					color = apply_grading( i, color );
					return output_ldr_gamma( color );
				}
			ENDCG
		}

		// 1 HDR GAMMA
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile _ AC_TONEMAPPING
				#pragma multi_compile _ AC_DITHERING

				float4 frag( v2f i ) : SV_Target
				{
					float4 color = fetch_process_hdr_gamma( i );
					color = apply_grading( i, color );
					return output_hdr_gamma( color );
				}
			ENDCG
		}

		// 2 LDR LINEAR
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				float4 frag( v2f i ) : SV_Target
				{
					float4 color = fetch_process_ldr_linear( i );
					color = apply_grading( i, color );
					return output_ldr_linear( color );
				}
			ENDCG
		}

		// 3 HDR LINEAR
		Pass {
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile _ AC_TONEMAPPING
				#pragma multi_compile _ AC_DITHERING

				float4 frag( v2f i ) : SV_Target
				{
					float4 color = fetch_process_hdr_linear( i );
					color = apply_grading( i, color );
					return output_hdr_linear( color );
				}
			ENDCG
		}
	}

	Fallback Off
}
