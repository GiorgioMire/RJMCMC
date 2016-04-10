yestim=zeros(1,1000)
for t=dynamicOrder+1:1000
    for i=1:length(bestprocess)
        T=Process_all{bestprocess(i)}
    yestim(t)=yestim(t)+bestak(i)*T(t,u,yestim);
    end
     for i=1:length(bestnoise)
        T=Noise_all{bestnoise(i)}
    yestim(t)=yestim(t)+bestbq(i)*T(t,u,yestim,e);
     end
end
 figure
plot(yestim)
hold on
plot(y(1:1000),'r')
 figure
plot(yestim(1:1000)-y(1:1000).')