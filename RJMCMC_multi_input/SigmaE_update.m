function SigmaE_update(Settings,residual)
global mc
theta=1/(Settings.betaE+0.5*eaz(norm(residual)^2,1));
pd=makedist('Gamma','a',Settings.alphaE+0.5*length(residual),'b',1/theta);
 mc.sigmaE=sqrt(1/random(pd));
end