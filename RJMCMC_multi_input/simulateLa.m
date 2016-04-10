function simulateLa(Settings)
global mc
theta=1/(Settings.betaLA);
pd=makedist('Gamma','a',Settings.alphaLA+mc.k,'b',theta);
mc.lambdaA=random(pd);
end
% lambdaA=random(pd);





