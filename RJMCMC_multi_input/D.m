function [ p] = D(c,lambda,n,nmax )

num=(lambda^(n-1))/factorial(n-1);
den=(lambda^(n))/factorial(n);
p=c*min(1,num/den);



end

