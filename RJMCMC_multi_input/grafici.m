mainfigure = figure (3);
set(0,'Units','pixels')
set (mainfigure, 'Position', [384   433   943   582])
rfig=5;
cfig=5;
ifig=0;
ifig=ifig+1;
subplot(rfig,cfig,ifig)

[h,b]=hist(sk,-1:max(sk));
bar(b,h./sum(h))
axis([b(1)-1,b(end)+1,0,1])
title('k')

ifig=ifig+1;
subplot(rfig,cfig,ifig)

[h,b]=hist(sq,-1:max(sq));
bar(b,h./sum(h))
axis([b(1)-1,b(end)+1,0,1])
title('q')

ifig=ifig+1;
subplot(rfig,cfig,ifig)

 plot(besty+ecut,'b');
 hold on
 plot(ycut,'r');
 hold off
 title('uscite')
 
 ifig=ifig+1;
subplot(rfig,cfig,ifig)
 plot(normbesteps,'b')
% hold on
% plot(normecut,'r')
hold on
plot(normrealecut,'g')
hold off
 title('norma residuo e rumore')



ifig=ifig+1;
subplot(rfig,cfig,ifig)

[h,b]=hist(slambA,-1:max(slambA));
bar(b,h./sum(h))
axis([b(1)-1,b(end)+1,0,1])
title('lamb A')
ifig=ifig+1;
subplot(rfig,cfig,ifig)

[h,b]=hist(slambB,-1:max(slambB));
bar(b,h./sum(h))
axis([b(1)-1,b(end)+1,0,1])
title('lamb B')

ifig=ifig+1;
subplot(rfig,cfig,ifig)
[h,b]=hist(modelserie,-1:max(modelserie));
bar(b,h./sum(h))
axis([b(1)-1,b(end)+1,0,max(h)./sum(h)])
title('modelserie')

ifig=ifig+1;
subplot(rfig,cfig,ifig)
[h,b]=hist(modelserie,-1:max(modelserie));
plot(Mode)
title('bestmodel')

pause(0.0001)
