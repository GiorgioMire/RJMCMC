z=rand();

if q==0
    B=1;
elseif q==length(Noise_all)
    B=0;
else
num=(lambdaB^(q+1))/factorial(q+1);
den=(lambdaB^(q))/factorial(q);
B=c*min(1,(num/den)^1);
end

if q>0
num=(lambdaB^(q-1))/factorial(q-1);
den=(lambdaB^(q))/factorial(q);
D=c*min(1,(num/den)^1);
end

if z<B
  %display('Nascita Processo')
    Nascita_rumore
elseif z<(B+D)
   % display('Morte Processo')
    Morte_rumore
else 
   %  display('Aggiornamrento Processo')
    for i=1:repeat
 SigmaB_update
 Noise_update;
 end
   
end
clear z