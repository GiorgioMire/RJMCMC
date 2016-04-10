% Numero di volte con cui si ripete l'algoritmo di aggiornamento

repeat=1;

% Numero di iterazioni da saltare prima di costruire le statistiche

burnin=1;
periodo_salvataggi=2000;

% Iperparametri di lambda (valore atteso del numero di termini)

alphaLA=0.5;
alphaLB=0.5;
betaLA=1.1;
betaLB=1.1;

% Iperparametri di sigma (Varianza del vettore di coefficienti)

betaA=1.1;
betaB=1.1;
alphaA=2;
alphaB=2;
betaE=1.1;

alphaE=2;


% Deviazione standard del rumore bianco

sigmaE=sqrt(0.01);

% Grado di libertà per tuning della frequenza di accettazione delle mosse
% (deviazione standard ipotizzata del rumore) 
windowSize=2000;
sigmaEP=0.01;%1.0600e-04;%0.244%sqrt(0.05);
sigmaEN=0.01;

% Dimensione della finestra temporale di identificazione


passo=100;
% Inizializzazione del numero di termini (modello iniziale vuoto)

k=0;
q=0;

% Inizializzazione delle matrici di regressione

Pk=[];
Eq=[];

% Inizializzazione dei vettori di coefficienti

ak=0;
bq=0;

% Inizializzazione dei valori attesi del numero di coefficienti

lambdaA=2;
lambdaB=2;

% Inizializzazione delle varianze delle proposal dei coefficienti

sigmaA=5;
sigmaB=5;

% Rapporto di frequenza tra le mosse dinamiche (morte e nascita) e quella
% di aggiornamento

c=0.4;

% Massimo ritardo che compare nei termini disponibili 

dynamicOrderP=2; % Nel modello di processo
dynamicOrderN=2; % Nel modello di rumore
dynamicOrder=max(dynamicOrderP,dynamicOrderN);  % complessivamente

% Massimo grado polinomiale possibile 
data='Data.mat';

polinomialOrderP=3;
polinomialOrderN=3;

% Numero di iterazioni

nIterations=200000;

% Numero di campioni di segnale da generare
N=70000;

% Inizializzo gli insiemi dei termini disponibili 

Inizializza_insiemi

% Creazione dei dati simulati
%Crea_segnali
Acquisisci_segnali
% Inizializza i vettori che servono a salvare le storie temporali 
Prepare_series
% undersample

Insiemi = fileread('Inizializza_insiemi.m');
regexdate = '[0-9]+_[0-9]+_[0-9]+_[0-9]+_[0-9]+_[0-9]';
date_sim=regexp(FileName,regexdate,'match');
savename=sprintf('SalvataggioIdentificazione_dati%s__id__%s.mat',date_sim{1},datetime('now','format','yyyy_MM_dd_HH_mm_ss'));