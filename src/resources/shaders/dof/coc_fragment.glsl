// Algine DOF CoC fragment shader

/*
 * @author congard
 * dbcongard@gmail.com
 * t.me/congard
 * github.com/congard
 */

#version 330

in vec2 texCoord;

layout (location = 0) out float fragCoC;

uniform sampler2D positionMap;

// if ALGINE_DOF_MODE == ALGINE_DOF_MODE_ENABLED
uniform float maxSigma;
uniform float minSigma;
uniform float focalDepth;
uniform float focalRange;

// if ALGINE_DOF_MODE == ALGINE_CINEMATIC_DOF_MODE_ENABLED
uniform struct CinematicDOF {
	float p; // plane in focus
	float a; // aperture
	float i; // image distance
} cinematicDOF;

void main() {
    #ifdef ALGINE_CINEMATIC_DOF
		float p = -cinematicDOF.p;
		float f = (p + cinematicDOF.i) / (p * cinematicDOF.i);
		float d = -texture(positionMap, texCoord).z;
		float sigma = abs((cinematicDOF.a * f * (p - d)) / (d * (p - f)));
		fragCoC = sigma;
	#else
		float sigma = abs(focalDepth + texture(positionMap, texCoord).z) / focalRange;
		fragCoC = maxSigma * sigma + minSigma;
	#endif
}
