if New_q==0
invC=sigmaEN^(-2)*Eq.'*Eq+sigmaB^(-2)*eye(q);
%invCNew=sigmaEN^(-2)*(New_Eq.')*New_Eq+sigmaB^(-2)*eye(New_q);
C=inv(invC);

Slack=(ycut-ezp(Pk,ak,ycut));
mu=sigmaEN^(-2)*C*Eq.'*Slack;


New_bq=0;

f1=sigmaB^(-(New_q-q));
f2=sqrt(abs(1/det(C)));
f3=((lambdaB^New_q/factorial(New_q))/(lambdaB^q/factorial(q)));
f4=exp(-0.5*mu.'*invC*mu);
rb=f1*f2*f3*f4;



elseif q==0

invCNew=sigmaEN^(-2)*(New_Eq.')*New_Eq+sigmaB^(-2)*eye(New_q);
Cnew=inv(invCNew);
Slack=(ycut-ezp(Pk,ak,ycut));

muNew=sigmaEN^(-2)*Cnew*New_Eq.'*Slack;

New_bq=muNew;

f1=sigmaB^(-(New_q-q));
f2=sqrt(abs(det(Cnew)));
f3=((lambdaA^New_q/factorial(New_q))/(lambdaB^q/factorial(q)));
f4=exp(0.5*muNew.'*invCNew*muNew);
rb=f1*f2*f3*f4;
else

invC=sigmaEN^(-2)*Eq.'*Eq+sigmaB^(-2)*eye(q);
invCNew=sigmaEN^(-2)*(New_Eq.')*New_Eq+sigmaB^(-2)*eye(New_q);
C=inv(invC);
Cnew=inv(invCNew);
Slack=(ycut-ezp(Pk,ak,ycut));
mu=sigmaEN^(-2)*C*Eq.'*Slack;
muNew=sigmaEN^(-2)*Cnew*New_Eq.'*Slack;

New_bq=muNew;

f1=sigmaB^(-(New_q-q));
f2=sqrt(abs(det(Cnew)/det(C)));
f3=((lambdaB^New_q/factorial(New_q))/(lambdaB^q/factorial(q)));
f4=exp(0.5*muNew.'*invCNew*muNew-0.5*mu.'*invC*mu);
rb=f1*f2*f3*f4;

if isnan(New_bq)
    error('e')
end
clear invC invCNew Slack mu muNew f1 f2 f3 f4
end

