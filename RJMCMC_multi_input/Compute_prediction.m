yestim=zeros(1,length(sk));
for t=dynamicOrder+1:length(sk)
 for i=1:length(bestprocess)
       T=Process_all{bestprocess(i)};
  yestim(t)=yestim(t)+bestak(i)*T(t,u,y);
 end
for i=1:length(bestnoise)
   T=Noise_all{bestnoise(i)};
    yestim(t)=yestim(t)+bestbq(i)*T(t,u,y,eestim);
 end
end