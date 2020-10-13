Shader "Unlit/HalfLambertShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainColor;

            float4 HalfLambertCalc(float3 normal) {

                float4 dotNormalLight = dot(normal, normalize(ObjSpaceLightDir(_WorldSpaceLightPos0)));
                float4 hLambert = dotNormalLight * 0.5 + 0.5;

                float4 lightFinal = pow(hLambert, 2);

                return lightFinal;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = v.normal;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                float4 colorLight = HalfLambertCalc(i.normal);
                fixed4 col = tex2D(_MainTex, i.uv) * colorLight;
                return col;
            }
            ENDCG
        }
    }
}
