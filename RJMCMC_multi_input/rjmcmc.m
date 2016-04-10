%_ Pulizia del workspace
% close all
% clear all
% clc

function rjmcmc(y,u)
global mc 
close all
clc
Settings=Settings_by_GUI();
clc

% Inizializzazione del numero di termini (modello iniziale vuoto)
mc.k=0;
mc.q=0;

% Inizializzazione delle matrici di regressione

mc.Pk=[];
mc.Eq=[];

% Inizializzazione dei vettori di coefficienti

mc.ak=0;
mc.bq=0;

% Inizializzazione dei valori attesi del numero di coefficienti

mc.lambdaA=2;
mc.lambdaB=2;

% Inizializzazione delle varianze delle proposal dei coefficienti

mc.sigmaA=Settings.sigmaP;
mc.sigmaB=Settings.sigmaN;
mc.sigmaE=Settings.sigmaEP;

% Inizializzo gli insiemi dei termini disponibili 

[Sets]=Inizializza_insiemi();

mc.eestim=zeros(size(y));

[Series]=Prepare_series();
% undersample

Settings.Insiemi = fileread('Inizializza_insiemi.m');

Settings.savename=sprintf('SalvataggioIdentificazione_dati_%s.mat',datetime('now','format','yyyy_MM_dd_HH_mm_ss'));
%%
%__ Qui inizia il ciclo di identificazione

for it=1:Settings.niter
 mc.it=it;
% Stampo il numero delle iterazioni

if mod(it,1)==0    
  fprintf('Iterazione %i\n',it);
end

% Salvo ogni tanto i risultati parziali
if mod(it,Settings.periodo_salvataggi)==0 || it==1
    display('Saving data...')
    save(Settings.savename,'mc','Series','Sets','Settings','it')
    display('Done!')
end

% Da qui stimo la durata dell'iterazione
  tic

%__Shift dei segnali e delle matrici di una unità di tempo
Shift_segnali_e_matrici(y,u,Settings,Sets) 

% Scelgo ed effettuo la mossa di transizione della catena di Markov per il
% processo
 Effettua_mossa_processo(y,u,Settings,Sets)
 
% Estraggo un nuovo valor medio del numero di termini di processo
% dalla distribuzione a posteriori di k
 simulateLa(Settings);
 

if it>2
    
% Scelgo ed effettuo la mossa di transizione della catena di Markov per il
% rumore 

%  Effettua_mossa_rumore

% Estraggo un nuovo valor medio del numero di termini di rumore
% dalla distribuzione a posteriori di q

% simulateLb;

end

% Calcolo del nuovo residuo
[residual]=calculateResidual(y);
 SigmaE_update(Settings,residual);

if Settings.plot_residual &&  it> Settings.burnin
plots
end
% Aggiorno la matrice di regressione del rumore con il nuovo residuo
updateEq(y,u,Sets);


if it>=Settings.burnin
    
% Associo un identificativo numerico alla struttura del modello attuale
% Salvo l'identificativo e il vettore dei coefficienti

[Series]=coding(Series,Settings);

end

% Salvo le altre quantità 

[Series]=save_series(Series,residual);
%Process_choosen

% Registro la durata dell'iterazione

tocs(it)=toc;

end
end

     