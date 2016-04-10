function [ y,p ,binsize] = maxhist( v ,doplot)

binsize=0.00001*(2*iqr(v)*length(v))^(-1/3);
[h,b]=hist(v,ceil(range(v)/binsize));
[~,i]=max(h);

%    figure(174)
%    bar(B,H./sum(H))
    
    y=b(i);
    if isempty(y)
        [h,b]=hist(v);
        [~,i]=max(h);
        

    end
    if doplot
      figure
 bar(b,h./sum(h),'FaceColor','w','EdgeColor','k')
 
pause(0.001)
    end
    y=b(i);
   p=h(i)./sum(h);
end

