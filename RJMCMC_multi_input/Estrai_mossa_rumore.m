
if q==0
    B=1;
elseif q==length(Noise_all)
    B=0;
    num=lambdaB^(q-1)/factorial(q-1);
    den=lambdaB^(q)/factorial(q);
    D=c*min(1,num/den);  
else
    num=lambdaB^(q+1)/factorial(q+1);
    den=lambdaB^(q)/factorial(q);
    B=c*min(1,num/den);
    num=lambdaB^(q-1)/factorial(q-1);
    den=lambdaB^(q)/factorial(q);
    D=c*min(1,num/den);  
end
