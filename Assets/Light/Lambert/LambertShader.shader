// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Study/LambertShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("Main Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode" = "ForwardBase"}
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

            float4 LambertCalc(float3 normal) {

                //Get light direction in object space
                float3 lightDirection = ObjSpaceLightDir(_WorldSpaceLightPos0);
                //Transform normal of the object and normalize
                float3 normalDirection = normalize(normal);
                //Calculate dot between normal and light
                float3 dotResult = dot(normalDirection, lightDirection);
                
                //Get color of light and get the max of dotResult
                float3 diffuseRefrection = _LightColor0.xyz * dotResult;
                //Calculate final light and append ambient light
                float3 lightFinal = diffuseRefrection;
                
                return float4(lightFinal, 1.0);
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
                float4 color = LambertCalc(i.normal);
                fixed4 col = tex2D(_MainTex, i.uv) * _MainColor * color;
                return col;
            }
            ENDCG
        }
    }
}
