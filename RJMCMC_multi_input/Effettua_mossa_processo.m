function Effettua_mossa_processo(y,u,Settings,Sets)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global mc
k=mc.k;
lambdaA=mc.lambdaA;
c=Settings.cc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z=rand();
% Calcolo le probabilità di nascita e di morte
if k==0
    B=1;
elseif k==length(Sets.Process_all)
    B=0;
else
num=(lambdaA^(k+1))/factorial(k+1);
den=(lambdaA^(k))/factorial(k);
B=c*min(1,(num/den)^1);
end

if k>0
num=(lambdaA^(k-1))/factorial(k-1);
den=(lambdaA^(k))/factorial(k);
D=c*min(1,(num/den)^1);
end

% Estraggo la  mossa e la effetttuo

if z<B
  %display('Nascita Processo')
    Nascita_processo(y,u,Settings,Sets)
elseif z<(B+D)
   % %display('Morte Processo')
    Morte_processo(y,Settings)
else 
   %  %display('Aggiornamrento Processo')
 for i=1:Settings.repeat
     % Aggiorno la varianza dei termini di processo
 SigmaA_update(Settings)
 % Aggiorno i coefficienti del processo Process_update;
 end
   
end
end