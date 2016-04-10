function [ra,New_ak]=Compute_RA(y,mc,New)
Pk=mc.Pk;
Eq=mc.Eq;
k=mc.k;
q=mc.q;
bq=mc.bq;
sigmaA=mc.sigmaA;
sigmaEP=mc.sigmaE;
lambdaA=mc.lambdaA;

ycut=y(mc.t_base:mc.t_end);
Slack=(ycut-ezp(Eq,bq,ycut));

if New.k==0
invC=sigmaEP^(-2)*(Pk.')*Pk+sigmaA^(-2)*eye(k);
mu=sigmaEP^(-2)*invC\(Pk.'*Slack);
New_ak=0;
f1=sigmaA^(-(New.k-k));
f2=sqrt(abs(invC));
f3=1/(lambdaA^k/factorial(k));
f4=exp(-0.5*mu.'*invC*mu);
ra=f1*f2*f3*f4;



elseif k==0
invCNew=sigmaEP^(-2)*(New.Pk.')*New.Pk+sigmaA^(-2)*eye(New.k);
Cnew=inv(invCNew);
muNew=sigmaEP^(-2)*Cnew*New.Pk.'*Slack;

New_ak=muNew;

f1=sigmaA^(-(New.k-k));
f2=sqrt(abs(det(Cnew)));
f3=((lambdaA^New.k/factorial(New.k))/(lambdaA^k/factorial(k)));
f4=exp(0.5*muNew.'*invCNew*muNew);
ra=f1*f2*f3*f4;
else

invC=sigmaEP^(-2)*(Pk.')*Pk+sigmaA^(-2)*eye(k);
invCNew=sigmaEP^(-2)*(New.Pk.')*New.Pk+sigmaA^(-2)*eye(New.k);
mu=sigmaEP^(-2)*invC\(Pk.'*Slack);
muNew=sigmaEP^(-2)*invCNew\(New.Pk.'*Slack);
New_ak=muNew;
f1=sigmaA^(-(New.k-k));
f2=sqrt(abs(det(invC)/det(invCNew)));
f3=((lambdaA^New.k/factorial(New.k))/(lambdaA^k/factorial(k)));
f4=exp(0.5*muNew.'*invCNew*muNew-0.5*mu.'*invC*mu);
ra=f1*f2*f3*f4;

if isnan(New_ak)
    error('e')
end

end

