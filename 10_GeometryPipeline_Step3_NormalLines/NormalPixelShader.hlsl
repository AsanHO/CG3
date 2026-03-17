struct PixelShaderInput
{
    float4 posProj : SV_POSITION; // Screen position
    float3 color : COLOR; // Normal lines 쉐이더에서 사용
};
float4 main(PixelShaderInput input) : SV_TARGET
{
    return float4(input.color, 1.0f);
}