#version 450

layout(push_constant) uniform PushData {
    int offset;
} pushData;

layout(set = 0, binding = 0) uniform UBO {
    mat4 model;
    mat4 view;
    mat4 proj;
} ubo[2];

layout(location = 0) in vec2 inPosition;
layout(location = 1) in vec3 inColor;
layout(location = 0) out vec3 fragColor;

void main() {
    gl_Position = ubo[pushData.offset].proj * ubo[pushData.offset].view * ubo[pushData.offset].model * vec4(inPosition, 0.0, 1.0);
    fragColor = inColor;
}