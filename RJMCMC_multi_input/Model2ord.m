function [ code ] = Model2ord( Process_choosen,Noise_choosen,Process_all,Noise_all)
v=[Process_choosen,Noise_choosen+length(Process_all)*ones(size(Noise_choosen,1),size(Noise_choosen,2))];
n=length(Process_all)+length(Noise_all);
z=zeros(1,n);
z(v)=1;
base=pow2(0:n-1);
code=uint64(z*(base.'));

end

