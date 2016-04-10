v = VideoWriter('noisecorr.avi')
v.FrameRate=70;
open(v)
figure(90);
set(gcf,'Position',[0,0,562,440])
for i=1:1:size(Residuals,1)
    figure(90);
     stem(-15:15,xcorr(Residuals(i,:),Residuals(i,:),15,'unbiased'))
     
    title(['R_{\epsilon,\epsilon}   ',sprintf('it=%i ',i)]);
 
 set(gcf,'Position',[0,0,562,440])
    f=getframe(gcf);
writeVideo(v,f);

end
close(v)