function [New_Pk]=compute_Pk_New(y,u,Sets,New_pos)
global mc
T=Sets.Process_all{mc.Process_avaiable(New_pos)};
t=mc.t_base:mc.t_end;
aggiunta=zeros(length(t),1);
for i=1:length(t);
aggiunta(i,1)=T(t(i),u,y);
end
if isempty(mc.Pk)
    New_Pk=aggiunta;
else
New_Pk=[mc.Pk,aggiunta];
end
end