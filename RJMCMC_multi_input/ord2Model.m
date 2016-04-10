function [ Process_choosen,Noise_choosen] = ord2Model( ord,Process_all,Noise_all)
ord=uint64(ord);
n=length(Process_all)+length(Noise_all);
idx=de2bi(ord,n);
v=1:n;
choosen=v(idx==1);
Noise_choosen=choosen(choosen>length(Process_all));
Process_choosen=choosen(choosen<=length(Process_all));
Noise_choosen=Noise_choosen-length(Process_all);

end