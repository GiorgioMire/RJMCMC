theta=1/betaLB;
pd=makedist('Gamma','a',alphaLB+q,'b',theta);
lambdaB=random(pd);
