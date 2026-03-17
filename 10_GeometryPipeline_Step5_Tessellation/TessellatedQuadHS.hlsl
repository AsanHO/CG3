cbuffer ConstantData : register(b0)
{
    float3 eyeWorld;
    float width;
    Matrix model;
    Matrix view;
    Matrix proj;
    float time = 0.0f;
    float3 padding;
    float4 edges;
    float2 inside;
    float2 padding2;
};

struct VertexOut
{
    float4 pos : POSITION;
};

struct HullOut
{
    float3 pos : POSITION;
};

struct PatchConstOutput
{
    float edges[4] : SV_TessFactor;
    float inside[2] : SV_InsideTessFactor;
};

PatchConstOutput MyPatchConstantFunc(InputPatch<VertexOut, 4> patch,
                                     uint patchID : SV_PrimitiveID)
{
    float3 center = (patch[0].pos.xyz +
                 patch[1].pos.xyz +
                 patch[2].pos.xyz +
                 patch[3].pos.xyz) * 0.25;
    float dist = length(center - eyeWorld);

    float minDist = 0.5;
    float maxDist = 20.0;

   // 0~1로 정규화
    float t = saturate((dist - minDist) / (maxDist - minDist));

    // 반대로 뒤집기
    t = 1.0 - t;

    // tess factor 범위
    float minTess = 1.0;
    float maxTess = 16.0;

    float tess = lerp(minTess, maxTess, t);
    PatchConstOutput pt;
    pt.edges[0] = tess;
    pt.edges[1] = tess;
    pt.edges[2] = tess;
    pt.edges[3] = tess;
    pt.inside[0] = tess;
    pt.inside[1] = tess;
    return pt;
    
}

[domain("quad")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(4)]
[patchconstantfunc("MyPatchConstantFunc")]
[maxtessfactor(64.0f)]
HullOut main(InputPatch<VertexOut, 4> p,
           uint i : SV_OutputControlPointID,
           uint patchId : SV_PrimitiveID)
{
    HullOut hout;
	
    hout.pos = p[i].pos.xyz;

    return hout;
}
