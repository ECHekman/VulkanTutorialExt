layout(push_constant) uniform PushData {
    uint uboDescriptorOffset;
};

layout(buffer_reference, std430) readonly buffer UBORef {
    mat4 model;
    mat4 view;
    mat4 proj;
};

void main() {
    UBORef uboRef = UBORef(uboDescriptorOffset);
    gl_Position = uboRef.proj * uboRef.view * uboRef.model * vec4(inPosition, 0.0, 1.0);
    fragColor = inColor;
}