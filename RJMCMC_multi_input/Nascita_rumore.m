%__ draw Avai
New_pos=randi(length(Noise_avaiable));
New_T=Noise_all{Noise_avaiable(New_pos)};
New_q=q+1;

compute_Eq_New;

Compute_RB;


gamma=min(1,rb);



%_____________ Accept?
z=rand();

if z<gamma
  % display('accettata')
Noise_choosen=[Noise_choosen,Noise_avaiable(New_pos)];
Noise_avaiable(New_pos)=[];
q=New_q;
bq=New_bq;
Eq=New_Eq;
clear  New_k New_ak New_Pk ra 
else
   
 %  display('rifiutata')
       for i=1:repeat
 SigmaB_update
 Noise_update;
 end
    
end
