

#version 450

layout(push_constant) uniform PushData {
    int offset;
} pushData;

layout(set = 1, binding = 0) uniform texture2D texImage;
layout(set = 2, binding = 0) uniform sampler   texSampler;

layout(location = 0) in vec3 fragColor;
layout(location = 1) in vec2 fragTexCoord;

layout(location = 0) out vec4 outColor;

void main() {
    outColor = texture(sampler2D(texImage, texSampler), fragTexCoord);
    //outColor = vec4(fragTexCoord, 0.0, 1.0);
}
