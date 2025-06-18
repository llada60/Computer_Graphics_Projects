#version 330 core            // minimal GL version support expected from the GPU

struct LightSource {
  vec3 position;
  vec3 color;
  float intensity;
  int isActive;
};

int numberOfLights = 3;
uniform LightSource lightSources[3];
// TODO: shadow maps

struct Material {
  vec3 albedo;
  // TODO: textures
};

uniform Material material;
uniform sampler2D normalMap;
uniform sampler2D albedoMap;
//uniform sampler2D shadowMap;
uniform bool isNormal;
uniform sampler2D shadows[3];

uniform vec3 camPos;

in vec3 fPositionModel;
in vec3 fPosition;
in vec3 fNormal;
in vec2 fTexCoord;
in vec4 fragPosLightSpace[3];

out vec4 colorOut; // shader output: the color response attached to this fragment

float pi = 3.1415927;

// TODO: shadows
void main() {
  

  vec3 n;
  if (isNormal){
    vec3 sampledNormal = texture(normalMap, fTexCoord).rgb;
    sampledNormal = normalize(sampledNormal * 2.0 - 1.0);
    n = sampledNormal;
  }
  else{
    n = normalize(fNormal);
  }
  
  vec3 wo = normalize(camPos - fPosition); // unit vector pointing to the camera
  vec3 radiance = vec3(0, 0, 0);
  vec3 albedo;
  float shadow;
  vec3 lightDir;
  for(int i=0; i<numberOfLights; ++i) {
    LightSource a_light = lightSources[i];

    vec3 projCoords = fragPosLightSpace[i].xyz / fragPosLightSpace[i].w;
    projCoords = projCoords * 0.5 + 0.5;
    float closestDepth = texture(shadows[i], projCoords.xy).r;
    float currentDepth = projCoords.z;
    lightDir = normalize(a_light.position - fPosition);
    float bias = max(0.05 * (1.0 - dot(n, lightDir)), 0.005);
    shadow = currentDepth - bias > closestDepth ? 0.0 : 1.0;
    vec3 textureColor = texture(albedoMap, fTexCoord).rgb;


    
    if(a_light.isActive == 1) { // consider active lights only
      vec3 wi = normalize(a_light.position - fPosition); // unit vector pointing to the light
      vec3 Li = a_light.color*a_light.intensity;
      if(isNormal){
        albedo = textureColor;
      }else{
        albedo = material.albedo;
      }

      radiance += (shadow)*Li*albedo*max(dot(n, wi), 0);
    }
  }
  colorOut = vec4(radiance, 1.0); // build an RGBA value from an RGB one
}
