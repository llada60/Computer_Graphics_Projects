#version 330 core            // minimal GL version support expected from the GPU

layout(location=0) in vec3 vPosition; // the 1st input attribute is the position (CPU side: glVertexAttrib 0)
layout(location=1) in vec3 vNormal;
layout(location=2) in vec2 vTexCoord;

uniform mat4 modelMat, viewMat, projMat;
uniform mat3 normMat;
uniform mat4 depthMVP[3];

out vec3 fPositionModel;
out vec3 fPosition;
out vec3 fNormal;
out vec2 fTexCoord;
out vec4 fragPosLightSpace[3];

void main() {
  fPositionModel = vPosition;
  fPosition = (modelMat*vec4(vPosition, 1.0)).xyz;
  fNormal = normMat*vNormal;
  fTexCoord = vTexCoord;

  gl_Position =  projMat*viewMat*modelMat*vec4(vPosition, 1.0); // mandatory
  for(int i=0; i<3; i++){
    fragPosLightSpace[i] = depthMVP[i] * modelMat * vec4(vPosition, 1.0);
  }
  
}
