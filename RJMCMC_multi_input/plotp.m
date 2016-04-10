function plotp(v,realval)
[h,b]=hist(v,min(v)-1:max(v)+1);
bar(b,h./sum(h),'FaceColor','w','EdgeColor','k')
%line([realval realval],[0,max(h./sum(h))+0.1], 'Color','r','LineWidth',2)
end