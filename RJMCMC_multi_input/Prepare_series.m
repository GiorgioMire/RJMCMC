function [series]=Prepare_series()
%Il prefisso "s" sta per serie e indica vettori che memorizzano la storia
%temporale di alcune quantità
series.sq=[]; % numero di termini del modello di rumore
series.sk=[]; % numero di termini del modello du processo
series.slambA=[]; % valore atteso dei numeri di termini di processo
series.slambB=[]; % valor atteso  dei numeri di termini di processo
series.svA=[]; % varianza dei coefficienti di processo
series.svB=[]; % varianza dei coefficienti di rumore
series.ModeProcess=[];  % moda attuale degli identificativi della struttura di processo
series.ModeNoise=[]; % moda attuale degli identificativi della struttura di rumore
end