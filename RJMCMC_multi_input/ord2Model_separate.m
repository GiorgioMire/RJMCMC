function [ Process_choosen] = ord2Model_separate( ord,Process_all)
ord=uint64(ord);
n=length(Process_all)+1;
idx=de2bi(ord,n);
v=1:n;
choosen=v(idx==1);

Process_choosen=choosen;


end