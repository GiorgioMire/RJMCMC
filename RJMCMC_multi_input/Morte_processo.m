function Morte_processo(y,Settings)
global mc
New.pos=randi(length(mc.Process_choosen));
New.k=mc.k-1;
New.Pk=mc.Pk;
New.Pk(:,New.pos)=[];
[ra,New_ak]=Compute_RA(y,mc,New);
gamma=min(1,ra);

% if ~exist('plot_gamma')
%     plot_gamma=[];
% end
% plot_gamma=[plot_gamma,gamma];
% figure(2)
% plot(plot_gamma)
% pause(0.1)

z=rand();

if z<gamma
  % display('accettata')
mc.Process_avaiable=[mc.Process_avaiable,mc.Process_choosen(New.pos)];  
mc.Process_choosen(New.pos)=[];
mc.k=New.k;
mc.ak=New_ak;
if isnan(New_ak)
    error('E')
end
mc.Pk=New.Pk;
else

  %  display('rifiutata')
     for i=1:Settings.repeat
 SigmaA_update(Settings)
 Process_update(y)

 end
end

end