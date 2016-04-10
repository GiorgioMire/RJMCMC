aggiunta=[];
T=Noise_all{Noise_avaiable(New_pos)};
t=cutInterval;
for i=1:windowSize
aggiunta(i,1)=T(t(i),u,y,eestim);
end
New_Eq=[Eq,aggiunta];
clear t T aggiunta