function Process_update(y)
global mc

SE=mc.sigmaE;
SA=mc.sigmaA;
Pk=mc.Pk;
Eq=mc.Eq;
bq=mc.bq;
k=mc.k;
ak=mc.ak;
ycut=y(mc.t_base:mc.t_end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
akold=ak;
invC=SE^(-2)*(Pk.')*Pk+SA^(-2)*eye(k);%;
C=inv(invC);
for m=1:k
      ahat=normrnd(ak(m),sqrt(C(m,m)));
%      display('diff')
  %  ahat(m)-ak(m)
    %PosteriorNew
    a=ak;
    a(m)=ahat;
    % PosteriorNew
  epsilon=ycut-ezp(Pk,a,ycut)-ezp(Eq,bq,ycut);
  epsilonOld=ycut-ezp(Pk,ak,ycut)-ezp(Eq,bq,ycut);
  posteriorNew=prod(-exp(epsilon.^2/2/(SE^2)+epsilonOld.^2/2/(SE^2)))*mvnpdf(a,zeros(k,1),SA^2*eye(k));
%PosteriorOld

posterior=mvnpdf(ak,zeros(k,1),SA^2*eye(k));

%La proposal secondo me non va compensata a causa della simmetria
%della gaussiana attorno al valor medio

rate=(posteriorNew/posterior);

if (~isfinite(posterior) && ~isfinite(posteriorNew)) || isnan(rate)
    warning('not finite posterior or nan rate')
    rate=1;
end
alpha=min(1,rate);
z=rand();
if z<alpha 
    mc.ak(m)=ahat;
else

end


end
end