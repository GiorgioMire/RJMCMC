bqold=bq;
SE=sigmaEN;
SB=sigmaB;

invC=SE^(-2)*(Eq.')*Eq+SB^(-2)*eye(q);%;
C=inv(invC);
for m=1:q
      bhat(m)=normrnd(bq(m),sqrt(C(m,m)));
    
    %PosteriorNew
    b=bq;
    b(m)=bhat(m);
    % PosteriorNew
  epsilon=ycut-ezp(Pk,ak,ycut)-ezp(Eq,b,ycut);
  epsilonOld=ycut-ezp(Pk,ak,ycut)-ezp(Eq,bq,ycut);
  posteriorNew=prod(exp(-norm(epsilon)^2/2/(sigmaEN^2)+norm(epsilonOld)^2/2/(sigmaEN^2)))*mvnpdf(b,zeros(q,1),sigmaB^2*eye(q));
%PosteriorOld

posterior=mvnpdf(bq,zeros(q,1),sigmaB^2*eye(q));

%La proposal secondo me non va compensata a causa della simmetria
%della gaussiana attorno al valor medio

rate=(posteriorNew/posterior);

if (~isfinite(posterior) && ~isfinite(posteriorNew)) || isnan(rate)
    warning('not finite posterior or nan rate')
    rate=0;
end
alpha=min(1,rate);
z=rand();
if z<alpha
    bq(m)=bhat(m);
  
else
%display('rifiutata')
end


end