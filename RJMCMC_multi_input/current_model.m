fid = fopen('Crea_segnali.m');
tline = fgetl(fid);
for i=1:9
    tline = fgetl(fid);
    
end

fclose(fid);

if it<burnin+100
fileid=fopen('Andamento.txt','w');
end

fprintf(fileid,'\n___________________________ \n');
fprintf(fileid,'\n ITERAZIONE %i \n',it);
fprintf(fileid,'\nEQUAZIONE TARGET\n');
fprintf(fileid,tline);
fprintf(fileid,'\nMODELLO DI PROCESSO\n');
formatSpec = '\n %i° termine= %4.2f * u(t-%i)^%i * y(t-%i)^%i\n';
% fwrite(bestprocess);
for j=1:length(Process_choosen)
   T=Process_all(Process_choosen(j));
    coeff=ak(j,:);
   fprintf(fileid,formatSpec,j,coeff,T.udelay,T.upow,T.ydelay,T.ypow);
end
  fprintf(fileid,'\nMODELLO DI RUMORE\n');
formatSpec = '\n %i° termine= %4.2f * u(t-%i)^%i * y(t-%i)^%i* e(t-%i)^%i\n';

for j=1:length(Noise_choosen)
     T=Noise_all(Noise_choosen(j));
    coeff=bq(j,:);
   fprintf(fileid,formatSpec,j,coeff,T.udelay,T.upow,T.ydelay,T.ypow,T.edelay,T.epow);
end
% fclose(file);
% edit Risultati.txt