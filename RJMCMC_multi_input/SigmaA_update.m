function SigmaA_update(Settings)
global mc
theta=1/(Settings.betaA+0.5*eaz(norm(mc.ak)^2,1));
pd=makedist('Gamma','a',Settings.alphaA+0.5*mc.k,'b',1/theta);
 mc.sigmaA=sqrt(1/random(pd));
end