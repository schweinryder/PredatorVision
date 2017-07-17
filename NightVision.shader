Shader "Predator/NightVision"
{
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}

	SubShader {
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="Transparent"}

		Cull Off Lighting Off ZWrite Off

		Pass {  
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _CameraGBufferTexture0;
			float4 _MainTex_ST;
			float4 _TrgCol;

			v2f vert (appdata_t v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target {
				fixed4 color = tex2D(_MainTex, i.texcoord);
				fixed4 diffuse = tex2D(_CameraGBufferTexture0, i.texcoord);
				float4 target = float4(.1,.1,.1,0);
							
				float grey = Luminance (color.rgb);

				color = dot(color, float4(0,0,0,0));
				color.rgb = lerp(color.rgb, target, grey * 80);
				color.rgb = lerp(color.rgb, diffuse.rgb, grey + .05);
				color.rb = max (color.r - 0.6, 0) * 5;
				
				return color;
			}
			ENDCG
		}
	}
}