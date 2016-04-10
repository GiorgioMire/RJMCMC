%___ Definisco i segnali

% Indico con il suffisso 'work' i segnali che comprendono i campioni della
% finestra temporale di identificazione e un numero di campioni precedenti
% alla finestra pari all'ordine dinamico 

ework=zeros(1,windowSize+dynamicOrder);

% Indico con il suffisso 'cut' i segnali che comprendono solo i campioni
% della finestra temporale di identificazione

ecut=zeros(1,windowSize);

% Segnale di ingresso 

u=2*(rand(1,N)-0.5);

% Rumore bianco
e=(sigmaE*randn(1,N)).';

% Inizializzo il vettore di uscita con zeri
y=(zeros(1,N)).';
eestim=zeros(size(e,1),size(e,2)); 

clc
Scelta=input('Digita 2 se vuoi utilizzare un modello casuale\n Digita 1 se vuoi utilizzare l''esempio dell''articolo\n Digita 0 se vuoi inserire un modello manualmente\n');
if Scelta==2
ProcessTarget=randi(32,1,randi(4));%[ 13 3 31 25];
akTarget=rand(1,length(ProcessTarget));%[ -0.5 , 0.6 ,0.7 ,-0.7];
NoiseTarget=randi(32,1,randi(2));
bqTarget=rand(1,length(NoiseTarget));%[ 0.2 ,0.3 ];
[ProcessTarget,s]=sort(ProcessTarget);
akTarget=akTarget(s);
[NoiseTarget,s]=sort(NoiseTarget);
bqTarget=bqTarget(s);
end

if Scelta==1
    dynamicOrderP=2; % Nel modello di processo
dynamicOrderN=2; % Nel modello di rumore
dynamicOrder=max(dynamicOrderP,dynamicOrderN);  % complessivamente
Inizializza_insiemi

ProcessTarget=[ 13 3 31 25];
akTarget=[ -0.5 , 0.6 ,0.7 ,-0.7];
NoiseTarget=randi(32,1,randi(2));
bqTarget=[ 0.2 ,0.3 ];
[ProcessTarget,s]=sort(ProcessTarget);
akTarget=akTarget(s);
[NoiseTarget,s]=sort(NoiseTarget);
bqTarget=bqTarget(s);
end

if Scelta==0
h=figure;
u=uicontrol('style','edit','units','normalized',...
    'position',[.05 .05 .9 .9],'hor','left','max',2,'enable','on');
fname='data.txt';
M=textread('Lista_termini.txt','%s','delimiter','\n');
set(u,'string',M) ;
    edit Lista_termini.txt
ProcessTarget=input('Nel file Lista_termini.txt è stata scritta la lista dei termini possibili con i rispettivi identificativi\n inserire gli identificativi dei termini di processo scelti in un vettore (Scrivere anche le parentesi quadre)\n') 
ProcessTString=[];
for s=1:length(ProcessTarget)
    ProcessTString=[ProcessTString,func2str(Process_all{s}),'\n '];
end
display('Termini di processo scelti\n')
display(ProcessTString)

akTarget=input('Inserire il vettore dei coefficienti (Inserire anche le parentesi quadre)\n')
figure(h)
NoiseTarget=input('Nel file Lista_termini.txt è stata scritta la lista dei termini possibili con i rispettivi identificativi\n inserire gli identificativi dei termini di rumore scelti in un vettore (Scrivere anche le parentesi quadre)\n') 
 NoiseTString=[];
for s=1:length(NoiseTarget)
    NoiseTString=[NoiseTString,func2str(Noise_all{s}),'\n '];
end
display('Termini di rumore scelti\n')
display(NoiseTString)

bqTarget=input('Inserire il vettore dei coefficienti (Inserire anche le parentesi quadre)\n');
try
[ProcessTarget,s]=sort(ProcessTarget);
end
try
akTarget=akTarget(s);
end
try
[NoiseTarget,s]=sort(NoiseTarget);
end
try
bqTarget=bqTarget(s);
end
end

display('Generazione dei dati: attendere')
%% Applico l'equazione alle differenze sui dati per ottenere l'uscita simulata

for t=dynamicOrder+1:N
    for i=1:length(ProcessTarget)
        
  y(t,1)=y(t,1)+akTarget(i).*Process_all{ProcessTarget(i)}(t,u,y);
  
    end
    
   if ~isempty(NoiseTarget) 
   for i=1:length(NoiseTarget)
       
  y(t,1)=y(t,1)+bqTarget(i).*Noise_all{NoiseTarget(i)}(t,u,y,e);

   end
   end
   
   y(t,1)=y(t,1)+e(t);
   
end
display('Dati generati')
%%
clear N
%_________
% Plot dei segnali
PlotDataFigure=figure();
subplot(3,1,1)
plot(u);
title('u')
subplot(3,1,2)
plot(y);
title('y')
subplot(3,1,3)
plot(e);
title('e')
pause(1)

