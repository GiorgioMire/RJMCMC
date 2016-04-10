function Shift_segnali_e_matrici(y,u,Settings,Sets)
global mc
dynamicOrder=Settings.dynamicOrder;
windowSize=Settings.windowSize;


mc.t_base=dynamicOrder+mc.it;
mc.t_end=mc.t_base+windowSize-1;
%_______________________________________
% Shift della matrice Pk
if ~isempty(mc.Pk)
mc.Pk(1,:)=[];
end

aggiunta=zeros(1,length(mc.Process_choosen));
for i=1:length(mc.Process_choosen)
    
    pos=mc.Process_choosen(i);
    T=Sets.Process_all{pos};
    aggiunta(1,i)=T(mc.t_end,u,y);
end

mc.Pk=[mc.Pk;aggiunta];
%_______________________________________
% Shift della matrice Eq
if ~isempty(mc.Eq)
mc.Eq(1,:)=[];
end

aggiunta=zeros(1,length(mc.Noise_choosen));
for i=1:length(mc.Noise_choosen)
    pos=mc.Noise_choosen(i);
    T=Sets.Noise_all{pos};
    aggiunta(1,i)=T(mc.t_end,u,y,eestim);
end
mc.Eq=[mc.Eq;aggiunta];

end