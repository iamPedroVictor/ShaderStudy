Shader "Unlit/HalfLambertShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Brightness("Brightness", Range(0,5)) = 1
        _Contrast("Contrast", Range(0,10)) = 1
        _Lambert("Lambert", Range(0,1)) = 0.5

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
            float _Contrast;
            float _Lambert;
            float _Brightness;

            float HalfLambertCalc(float3 normal) {

                float dotNormalLight = max(0.0, dot(normal, normalize(ObjSpaceLightDir(_WorldSpaceLightPos0))));
                float hLambert = dotNormalLight * _Lambert + (1 - _Lambert);

                float lightFinal = pow(hLambert, _Contrast) * _Brightness;

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
                float colorLight = HalfLambertCalc(i.normal);
                fixed4 col = tex2D(_MainTex, i.uv) * colorLight;
                return col;
            }
            ENDCG
        }
    }
}
