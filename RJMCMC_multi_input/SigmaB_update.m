if q==0
    bq=0;
end
theta=1/(betaB+0.5*(bq.')*bq);
pd=makedist('Gamma','a',alphaB+0.5*q,'b',1/theta);
sigmaB=min(sqrt(1/random(pd)),100);
% xinv=1/5:0.1:10;
% figure(2000)
% plot(1./xinv,pd.pdf(xinv));
% pause(0.001)