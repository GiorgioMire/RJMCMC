function Nascita_processo(y,u,Settings,Sets)
global mc
%__ Estraggo da quelli disponibili il termine che verrà proposto
New.pos=randi(length(mc.Process_avaiable));
% Estraggo un nuovo termine da quelli disponibili
New.k=mc.k+1;

% Calcolo il regressore che si avrebbe se accettassi il nuovo termine
[New.Pk]=compute_Pk_New(y,u,Sets,New.pos);

% Calcolo il rapporto di accettazione della mossa
[ra,New.ak]=Compute_RA(y,mc,New);
gamma=min(1,ra);
z=rand();
% Decido se accettare o meno la modda
if z<gamma
    % Mossa accettata
  display('accettata')
  % Aggiorno il vettore dei termini scelti
mc.Process_choosen=[mc.Process_choosen,mc.Process_avaiable(New.pos)];
% Elimino il termine accettato dal vettore dei termini disponibili
mc.Process_avaiable(New.pos)=[];
% Aggiorno il numero di termini del processo
mc.k=New.k;

% Aggiorno il vettore dei coeffcienti
mc.ak=New.ak;
% Aggiorno la matrice di regressione del processo
mc.Pk=New.Pk;
else
    
 % Mossa rifiutata, dunque effettuo l'aggiornamento dei coefficienti  
   display('rifiutata')
 
 for i=1:Settings.repeat
     % Aggiorno la varianza dei coefficienti
 SigmaA_update(Settings)
 % Aggiorno i coefficienti
 Process_update(y);
 end
    
end
end