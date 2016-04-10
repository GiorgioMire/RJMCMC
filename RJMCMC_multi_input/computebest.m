% %____________________________________________________________________________%
if ~isempty(modelserie)
bestid=mode(modelserie);
[bestProcess,bestNoise]=ord2Model(bestid,Process_all,Noise_all);
BestAk=Ak{bestid};
if ~isempty(BestAk)
for l=1:size(BestAk,1)
     binsize=2*iqr(BestAk(l,:))*length(BestAk(l,:))^(-1/3);
     if binsize==0
 
     [h,b]=hist(BestAk(l,:));
     else
             [h,b]=hist(BestAk(l,:),min(ceil(range(BestAk(l,:))/binsize),10^6));
     end
     [~,i]=max(h);
     
   bestak(l,1)=b(i);
 end
 end
 clear  h b i
BestBq=Bq{bestid};
 if ~isempty(BestBq)
 for l=1:size(BestBq,1)
     binsize=2*iqr(BestBq(l,:))*length(BestBq(l,:))^(-1/3);
     if binsize==0
 
     [h,b]=hist(BestBq(l,:));
     else
             [h,b]=hist(BestBq(l,:),min(ceil(range(BestBq(l,:))/binsize),10^6));
     end
     [~,i]=max(h);
     
     bestbq(l,1)=b(i);
 end
 end
end