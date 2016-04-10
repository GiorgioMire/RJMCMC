function [ code ] = Model2ord_separate( Process_choosen,Process_all)
v=[Process_choosen];
n=length(Process_all)+1;
z=zeros(1,n);
z(v)=1;
base=pow2(0:n-1);
code=uint64(z*(base.'));

end
