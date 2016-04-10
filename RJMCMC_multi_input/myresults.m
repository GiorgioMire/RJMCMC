close all
clear all
% Carico il file dei dati generati durante l'esecuzione dell'algoritmo
%load('SalvataggioIdentificazione.mat')
load('./MATS/ALtroModello.mat')

% Suffisso che viene aggiunto al nome delle immagini salvate
% (Modificare per non sovrascrivere le immagini)
versione='V1';

% Apro il file dove scriverò i risultati
outputfile=fopen('RISULTATO_IDENTIFICAZIONE.txt','w');

figure

% 

for i=1:length(sq)
    modesq(i)=mode(sq(1:i));
end

figure
plot(modesq,'k')
title('Miglior numero di termini di rumore')
nomefile=['modesq','.eps'];
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')
ylim([-10,max(modesq)+10])


%% Mode noise
figure
plot(ModeNoise,'k')
ylim([-10,max(ModeNoise)+10])
title('Miglior modello di rumore')
nomefile=['BestModelN','.eps'];
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')

%% Modesk
for i=1:length(sk)
    modesk(i)=mode(sk(1:i));
end
figure
plot(modesk,'k')
ylim([-10,max(modesk)+10])
title('Miglior numero di termini di processo')
nomefile=['modesk','.eps'];
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc');

%% Mode process
figure
plot(ModeProcess,'k')
ylim([-10,max(ModeProcess)+10])
title('Miglior modello di processo')
saveas(gcf,['BestModelP','.eps'],'epsc')
figure
plot(ModeProcess,'k')
title('Miglior modello di processo ')
nomefile=['BestModelPTransitorio','.eps'];
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')

%% stringa target
strprocesso=[];
for i=1:length(ProcessTarget)
    a=num2str(akTarget(i));
s=sprintf(func2str(Process_all{ProcessTarget(i)}));
   s=s(9:end);
   
   strprocesso=[strprocesso,a,'*',s,'\n']
   
    
end

strnoise=[];
for i=1:length(NoiseTarget)
    b=num2str(bqTarget(i));
s=sprintf(func2str(Noise_all{NoiseTarget(i)}));
   s=s(11:end);
   
   strnoise=[strnoise,b,'*',s,'\n'];
   
   
   
    
end
strTarget=['y(t)=',strprocesso,strnoise]
fprintf(outputfile,'\nEQUAZIONE TARGET\n')
fprintf(outputfile,strTarget)
fprintf(outputfile,'\n')

%% Calcola bestmodel

bestprocessid=mode(modelserie_process);
bestprocess=ord2Model_separate(bestprocessid,Process_all);
bestaks=Ak{LowerP(bestprocessid)};
bestak=[];
[ProcessTarget,s]=sort(ProcessTarget);
akTarget=akTarget(s);
fprintf(outputfile,['EQUAZIONE IDENTIFICATA\n termine ',' akTarget ',' bestak ',' p ',' binsize ',' var','\n'])
for i=1:size(bestaks,1)
    string=func2str(Process_all{bestprocess(i)});
    string=string(9:end);
[bestak(i),p,binsize]=maxhistplot(bestaks(i,:),1);
I=find(ProcessTarget==bestprocess(i));

fprintf(outputfile,'\n%s \t %4.3f\t %4.3f(+-)%4.3f\t   %4.3f\t %4.3f\t \n',string ,akTarget(I),bestak(i),sqrt(var(bestaks(i,:))),p,binsize)
hold on

stem(akTarget(I),p,'r','LineWidth',2)
title(['p(a_',num2str(i),'|y), del termine  ',string])
nomefile=['ak_',num2str(i),'.eps'];
nomefile=[versione,nomefile];

saveas(gcf,nomefile,'epsc')

end

[bestprocess,s]=sort(bestprocess);
bestak=bestak(s);

%%

bestnoiseid=mode(modelserie_noise);
bestnoise=ord2Model_separate(bestnoiseid,Noise_all);
bestbqs=Bq{LowerN(bestnoiseid)};
bestbq=[];
[NoiseTarget,s]=sort(NoiseTarget);
bqTarget=bqTarget(s);
if ~isempty(bestbqs)
for i=1:size(bestbqs,1)
    string=func2str(Noise_all{bestnoise(i)});
    string=string(11:end);
[bestbq(i),p,binsize]=maxhistplot(bestbqs(i,:),1);
I=find(NoiseTarget==bestnoise(i))
hold on
stem(bqTarget(I),p,'r','LineWidth',2);
title(['p(b_',num2str(i),'|y) del termine  ',string])
nomefile=['bq_',num2str(i),'.eps'];
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')

fprintf(outputfile,'\n%s\t %4.3f\t %4.3f(+-)%4.3f\t %4.3f\t %4.3f \n',string ,bqTarget(i),bestbq(i),sqrt(var(bestbqs(i,:))),p,binsize)


end

[bestNoise,s]=sort(bestnoise);
bsetbq=bestbq(s);
end
%%
ProcessTarget
bestprocess
akTarget
bestak

%% Termini convergenza
for i=1:length(modelserie_process)
    modelserieplow(i)=LowerP(modelserie_process(i));
end
for i=1:length(modelserie_noise)
    modelserienlow(i)=LowerN(modelserie_noise(i));
end
% time=find(modelserieplow==LowerP(bestprocessid));
% 
% p=[];s
% figure
% for i=1:size(bestaks,1)
%    
%     for j=1:length(sk)-1
%         j
% p(i,j)=maxhistplot(bestaks(i,1:j),0);
%     end
%     figure
% plot(time(1:27400),p(2,:),'.')
% ylim([-0.55 -0.45])
% hold on
% line([0 time(27400)],[ -0.5 -0.5],'Color','g')
% title(['convergenzatermini',num2str(i)])
%  saveas(['convergenzatermini',num2str(i),'.eps'],'epsc');
%     
% end

%% String processo
strmyprocesso=[];
for i=1:length(bestprocess)
    a=num2str(bestak(i));
s=sprintf(func2str(Process_all{bestprocess(i)}))
   s=s(9:end);
   
   strmyprocesso=[strmyprocesso,a,'*',s,'+']
   
    
end
strmynoise=[]
for i=1:length(bestnoise)
    b=num2str(bestbq(i));
s=sprintf(func2str(Noise_all{bestnoise(i)}))
   s=s(11:end);
   
   strmynoise=[strmynoise,b,'*',s,'+']
   
   
   
    
end
strIdentificato=['y(t)=',strmyprocesso,strmynoise];
fprintf(outputfile,['\n',strIdentificato]);
%% Varie prob

figure
plotp(sk,length(ProcessTarget))
title('Probabilità numero di termini di processo')
nomefile='histk';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')

figure
plotp(sq,length(NoiseTarget))
title('Probabilità numero di termini di rumore')
nomefile='histq';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')

figure
ploth(sk,length(ProcessTarget))
title('Storia numero di termini di processo')

figure
ploth(sq,length(NoiseTarget))
title('Storia numero di termini di processo')

figure
plotp(slambA,length(ProcessTarget))
title('Probabilità p(\lambda_a|y)')

figure
plotp(slambB,length(NoiseTarget))
title('Probabilità p(\lambda_b|y)')

figure
for i=1:length(modelserie_process)
    modelserieplow(i)=LowerP(modelserie_process(i));
end
plot(modelserieplow,'k')



title('Serie temporale strutture di processo')
nomefile='modelserieplow';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')

%%
for i=1:length(modelserie_noise)
    modelserienlow(i)=LowerN(modelserie_noise(i));
end
figure
plot(modelserienlow,'k')
title('Serie temporale strutture di rumore')
nomefile='modelserienlow';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')


figure
[h,b]=hist(modelserieplow,length(modelserieplow));
bar(b,h./sum(h),'FaceColor','k','EdgeColor','k');
title('Probabilità della struttura di modello per il processo p(P_k,k|y)')
nomefile='probstrutP.eps';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')

figure(39)
[h,b]=hist(modelserienlow,length(modelserienlow));
bar(b,h./sum(h),'FaceColor','k','EdgeColor','k');
title('Probabilità della struttura di modello per il rumore p(E_q,q|y)')
nomefile='probstrutN.eps';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')

%%

%etest=e;sigmaE*randn(1,length(e));
yestim=zeros(1,length(sk));
for t=dynamicOrder+1:length(sk)
    for i=1:length(bestprocess)
        T=Process_all{bestprocess(i)};
%        akTarget(i)
%        T
%        T(t,u,y)
%        '\n___\n'
    yestim(t)=yestim(t)+bestak(i)*T(t,u,y);
    end
   for i=1:length(bestnoise)
        T=Noise_all{bestnoise(i)};
%        bqTarget(i)
%        T
%        T(t,u,y,e)
%         '\n___\n'
    yestim(t)=yestim(t)+bestbq(i)*T(t,u,y,e);
   end
     yestim(t)=yestim(t);
  
%  '\n___\n'
end
display('calcolata predizione')
%%

 figure
plot(yestim(600:900),'r')
hold on
plot(y(600:900),'k')
legend('Uscita stimata','Uscita vera')
title('Uscita vera e uscita stimata')
nomefile='uscita';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')


 figure
scarto=-(yestim-y(1:length(sk)).');
plot(scarto,'k')
title('Residuo')
hold on
nomefile='residuo';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')



%plot(e,'g')
figure
plot(-20:20,xcorr(scarto,scarto,20,'biased')./sigmaE^2,'k')
hold on
line([-20 20],[0.05,0.05],'LineStyle','--','Color','r')
hold on
line([-20 20],[-0.05,-0.05],'LineStyle','--','Color','r')
ylim([-0.2 1.2])
ylim([-0.2 1.2])
title('Autocorrelazione residuo')
nomefile='ree';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')


figure
plot(-20:20,xcorr(scarto,u(1:length(sk)),20,'biased')./sigmaE^2,'k')
hold on
line([-20 20],[0.05,0.05],'LineStyle','--','Color','r')
hold on
line([-20 20],[-0.05,-0.05],'LineStyle','--','Color','r')
ylim([-0.2 1.2])
ylim([-0.2 1.2])
title('$R_{\epsilon,u}$', 'interpreter','latex')
nomefile='reu';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')


figure
plot(-20:20,xcorr(scarto.^2-mean(scarto.^2),u(1:length(sk)),20,'biased')./sigmaE^2,'k')
hold on
line([-20 20],[0.05,0.05],'LineStyle','--','Color','r')
hold on
line([-20 20],[-0.05,-0.05],'LineStyle','--','Color','r')
ylim([-0.2 1.2])
ylim([-0.2 1.2])
title('$R_{\epsilon^2,u}$', 'interpreter','latex')
nomefile='reeu';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')


figure
plot(-20:20,xcorr(scarto,u(1:length(sk)).^2-mean(u(1:length(sk)).^2),20,'unbiased')./sigmaE^2,'k')
hold on
line([-20 20],[0.05,0.05],'LineStyle','--','Color','r')
hold on
line([-20 20],[-0.05,-0.05],'LineStyle','--','Color','r')
ylim([-0.2 1.2])
title('$R_{\epsilon,u^2}$', 'interpreter','latex')
nomefile='reuu';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')


figure
plot(-20:20,xcorr(scarto.^2-mean(scarto.^2),u(1:length(sk)).^2-mean(u(1:length(sk)).^2),20,'biased')./sigmaE^2,'k')
hold on
line([-20 20],[0.05,0.05],'LineStyle','--','Color','r')
hold on
line([-20 20],[-0.05,-0.05],'LineStyle','--','Color','r')
ylim([-0.2 1.2])
ylim([-0.2 1.2])
title('$R_{\epsilon^2,u^2}$', 'interpreter','latex')

nomefile='reeuu';
nomefile=[versione,nomefile];
saveas(gcf,nomefile,'epsc')
display('Il risultato è stato scritto nel file RISULTATO_IDENTIFICAZIONE.txt')



