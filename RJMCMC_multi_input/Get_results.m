close all
%clear all
% Carico il file dei dati generati durante l'esecuzione dell'algoritm
%load('SalvataggioIdentificazione.mat'
%load('./MATS/ALtroModello.mat'
display('Carico risultati')
%load('D:\Underwater\RJMCMC_multi_input\SIMPLE_SIMULATION_DATA\Simulazioni_salvate\SalvataggioIdentificazione_dati2016_04_02_15_39_1__id__2016_04_03_10_48_06.mat')
% Suffisso che viene aggiunto al nome delle immagini salvat
% (Modificare per non sovrascrivere le immagini)
versione='V1';

T=20%300;
modelserie_process=modelserie_process(end-T:end);
modelserie_noise=modelserie_noise(end-T:end);
% Apro il file dove scriverò i risultat
outputfile=fopen('RISULTATO_IDENTIFICAZIONE.txt','w');



for i=1:length(sq)
    modesq(i)=mode(sq(1:i));
end

figure
plot(modesq,'k')
drawnow
title('Miglior numero di termini di rumore')
nomefile=['modesq','.eps']
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')
ylim([-10,max(modesq)+10])

pause(0.001)

%% Mode nois
figure
plot(ModeNoise,'k')
ylim([-10,max(ModeNoise)+10])
title('Miglior modello di rumore')
nomefile=['BestModelN','.eps']
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')
drawnow
%% Modes
for i=1:length(sk)
    modesk(i)=mode(sk(1:i));
end
figure
plot(modesk,'k')
drawnow
ylim([-10,max(modesk)+10])
title('Miglior numero di termini di processo')
nomefile=['modesk','.eps']
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')

%% Mode proces
figure
plot(ModeProcess,'k')
drawnow
ylim([-10,max(ModeProcess)+10])
title('Miglior modello di processo')
%saveas(gcf,['BestModelP','.eps'],'epsc')

title('Miglior modello di processo ')
nomefile=['BestModelPTransitorio','.eps']
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')

%% Calcola bestmode

bestprocessid=mode(modelserie_process)
bestprocess=str2num(model_from_codeP(bestprocessid))
bestnoiseid=mode(modelserie_noise)
bestnoise=str2num(model_from_codeN(bestnoiseid))
bestbqs=Bq{bestnoiseid}

bestaks=Ak{bestprocessid}
bestak=[]
fprintf(outputfile,['EQUAZIONE IDENTIFICATA\n termine ',' bestak ',' var',' p ',' binsize ',' var','\n'])
if ~isempty(bestaks)
for i=1:size(bestaks,1)
    string=func2str(Process_all{bestprocess(i)})
    string=parse_string_name(string,inputs_names)
[bestak(i),p,binsize]=maxhistplot(bestaks(i,:),1)

fprintf(outputfile,'\n%s 	 %8.7f(+-)%8.7f	   %8.7f	 %8.7f	 \n',string ,bestak(i),sqrt(var(bestaks(i,:))),p,binsize)
hold on

%stem(akTarget(I),p,'r','LineWidth',2
title(['p(a_',num2str(i),'|y), del termine  ',string])
nomefile=['ak_',num2str(i),'.eps']
nomefile=[versione,nomefile]

%saveas(gcf,nomefile,'epsc')

end
end

[bestprocess,s]=sort(bestprocess)
bestak=bestak(s)

%% 

bestbq=[]


if~isempty(bestbqs)
if ~isempty(bestbqs)
for i=1:size(bestbqs,1)
    string=func2str(Noise_all{bestnoise(i)})
    string=parse_string_name(string,inputs_names)
[bestbq(i),p,binsize]=maxhistplot(bestbqs(i,:),1)

hold on
%stem(bqTarget(I),p,'r','LineWidth',2)
title(['p(b_',num2str(i),'|y) del termine  ',string])
nomefile=['bq_',num2str(i),'.eps']
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')

fprintf(outputfile,'\n%s	 	 %8.7f(+-)%8.7f	 %8.7f	 %8.7f \n',string ,bestbq(i),sqrt(var(bestbqs(i,:))),p,binsize)
end
end
end


%% String process
strmyprocesso=[]
for i=1:length(bestprocess)
    a=num2str(bestak(i))
s=sprintf(func2str(Process_all{bestprocess(i)}))
  s=parse_string_name(s,inputs_names)
  
   strmyprocesso=[strmyprocesso,a,'*',s,'+']
  
   
end
strmynoise=[]
for i=1:length(bestnoise)
    b=num2str(bestbq(i))
s=sprintf(func2str(Noise_all{bestnoise(i)}))
     s=parse_string_name(s,inputs_names)
  
   strmynoise=[strmynoise,b,'*',s,'+']
  
  
  
   
end
strIdentificato=['y(t)=',strmyprocesso,strmynoise]
fprintf(outputfile,['\n',strIdentificato])
%% Varie pro

figure
plotp(sk,[])
title('Probabilità numero di termini di processo')
nomefile='histk'
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')

figure
plotp(sq,[])
title('Probabilità numero di termini di rumore')
nomefile='histq'
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')

figure
ploth(sk,[])
title('Storia numero di termini di processo')

figure
ploth(sq,[])
title('Storia numero di termini di processo')

figure
plotp(slambA,[])
title('Probabilità p(\lambda_a|y)')

figure
plotp(slambB,[])
title('Probabilità p( \lambda_b|y)')
plot(modelserie_process,'k')



title('Serie temporale strutture di processo')
nomefile='modelserieplow'
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')

figure
plot(modelserie_noise,'k')
title('Serie temporale strutture di rumore')
nomefile='modelserienlow'
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')


figure
[h,b]=hist(modelserie_process,length(modelserie_process))
bar(b,h./sum(h),'FaceColor','k','EdgeColor','k')
title('Probabilità della struttura di modello per il processo p(P_k,k|y)')
nomefile='probstrutP.eps'
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')

figure(39)
[h,b]=hist(modelserie_noise,length(modelserie_noise))
bar(b,h./sum(h),'FaceColor','k','EdgeColor','k')
title('Probabilità della struttura di modello per il rumore p(E_q,q|y)')
nomefile='probstrutN.eps'
nomefile=[versione,nomefile];
%saveas(gcf,nomefile,'epsc')
%%

Compute_prediction
 
%  \n___\n
Interval=1:100
display('calcolata predizione')
 figure
plot(yestim(Interval),'r')
hold on
plot(y(Interval),'k')
legend('Uscita stimata','Uscita vera')
title('Uscita vera e uscita stimata')
nomefile='uscita'
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')

%%
 figure
scarto=-(yestim-y(1:length(sk)).')
plot(scarto,'k')
title('Residuo')
hold on
nomefile='residuo'
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')



%plot(e,'g')
figure
cor=xcorr(scarto,scarto,20,'biased');
plot(-20:20,cor./max(cor),'k')
hold on
line([-20 20],[0.05,0.05],'LineStyle','--','Color','r')
hold on
line([-20 20],[-0.05,-0.05],'LineStyle','--','Color','r')
ylim([-0.2 1.2])
ylim([-0.2 1.2])
title('Autocorrelazione residuo')
nomefile='ree'
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')

for l=1:0%inputs
eval(strcat('ing=',l,';'));
figure
plot(-20:20,xcorr(scarto,ing(1:length(sk)),20,'biased')./sigmaE^2,'k')
line([-20 20],[0.05,0.05],'LineStyle','--','Color','r')
hold on
line([-20 20],[-0.05,-0.05],'LineStyle','--','Color','r')
ylim([-0.2 1.2])
ylim([-0.2 1.2])
title(sprintf('$R_{\\epsilon,%s}$',l), 'interpreter','latex')
nomefile=sprintf('re%s',l)
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')


figure
plot(-20:20,xcorr(scarto.^2-mean(scarto.^2),ing(1:length(sk)),20,'biased')./sigmaE^2,'k')
hold on
line([-20 20],[0.05,0.05],'LineStyle','--','Color','r')
hold on
line([-20 20],[-0.05,-0.05],'LineStyle','--','Color','r')
ylim([-0.2 1.2])
ylim([-0.2 1.2])
title(sprintf('$R_{\\epsilon^2,%s}$',l), 'interpreter','latex')
nomefile=sprintf('ree%s',l);
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')


figure
plot(-20:20,xcorr(scarto,ing(1:length(sk)).^2-mean(ing(1:length(sk)).^2),20,'unbiased')./sigmaE^2,'k')
hold on
line([-20 20],[0.05,0.05],'LineStyle','--','Color','r')
hold on
line([-20 20],[-0.05,-0.05],'LineStyle','--','Color','r')
ylim([-0.2 1.2])
title('$R_{\\epsilon,u^2}$', 'interpreter','latex')
nomefile='reuu'
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')


figure
plot(-20:20,xcorr(scarto.^2-mean(scarto.^2),ing(1:length(sk)).^2-mean(ing(1:length(sk)).^2),20,'biased')./sigmaE^2,'k')
hold on
line([-20 20],[0.05,0.05],'LineStyle','--','Color','r')
hold on
line([-20 20],[-0.05,-0.05],'LineStyle','--','Color','r')
ylim([-0.2 1.2])
ylim([-0.2 1.2])
title(sprintf('$R_{\\epsilon,%s^2}$',l), 'interpreter','latex')

nomefile=sprintf('ree%s%s',l,l)
nomefile=[versione,nomefile]
%saveas(gcf,nomefile,'epsc')
end
display('Il risultato � stato scritto nel file RISULTATO_DENTIFICAZIONE.txt')
