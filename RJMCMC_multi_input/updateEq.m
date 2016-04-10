function updateEq(y,u,Sets)
global mc

t=mc.t_base:mc.t_end;
if mc.q~=0
for j=1:length(mc.Noise_choosen)
    for i=1:size(mc.Eq,1);
        T=Sets.Noise_all{mcNoise_choosen(j)};
         mc.Eq(i,j)=T(t(i),u,y,mc.eestim);
    end
end
end
end
    