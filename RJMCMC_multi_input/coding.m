function [series]=coding(series,Settings)
global mc 
% Riordino i vettori dei modelli in modo da evitare di considerare diversi
% due modelli che differiscono solo per l'ordine dei termini

[Process_choosen_c,idx]=sort(mc.Process_choosen);
  [Noise_choosen_c,idx2]=sort(mc.Noise_choosen);

%Inizializza le mappe
if mc.it==Settings.burnin
        series.codesP=containers.Map('%%',0);
        series.codesN=containers.Map('%%',0);
series.model_from_codeP=containers.Map(0,'%%');
series.model_from_codeN=containers.Map(0,'%%');
       series.modelserie_process=[];
       series.modelserie_noise=[];
  series.Ak{1}=[];
  series.Bq{1}=[];
end

% Crea una stringa che identifica il processo
id_process=num2str( Process_choosen_c);
id_noise=num2str( Noise_choosen_c);

% Se il modello attuale non è ancora stato incontrato aggiorna le mappe
if ~series.codesP.isKey(id_process) %mappa la stringa in un numero 1=non valido 2=primo processo ...
    n=series.codesP.Count+1;
n=double(n);
 series.codesP(id_process)=n;
 series.model_from_codeP(n)=id_process;
 series.Ak{n}=[];
end

% Aggiunge il vettore attuale dei parametri alla storia temporale
% associata al modello attuale
series.Ak{series.codesP(id_process)}=[series.Ak{series.codesP(id_process)},mc.ak(idx)];

% Stesse operazioni per il rumore
 if ~series.codesN.isKey(id_noise)
    n=series.codesN.Count+1;
n=double(n);
 series.codesN(id_noise)=n;
 series.model_from_codeN(n)=id_noise;
 series.Bq{n}=[];
 end
series.Bq{series.codesN(id_noise)}=[series.Bq{series.codesN(id_noise)},mc.bq(idx2)];
% Storia temporale dei modell
series.modelserie_process=[series.modelserie_process,series.codesP(id_process)];
series.modelserie_noise=[series.modelserie_noise,series.codesN(id_noise)];
series.ModeNoise=[series.ModeNoise,mode(series.modelserie_noise)];
series.ModeProcess=[series.ModeProcess,mode(series.modelserie_process)];
end