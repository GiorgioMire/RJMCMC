
if k==0
    B=1;
elseif k==length(Process_all)
    B=0;
    num=lambdaA^(k-1)/factorial(k-1);
    den=lambdaA^(k)/factorial(k);
    D=c*min(1,num/den); 
    clear num den
else
    num=lambdaA^(k+1)/factorial(k+1);
    den=lambdaA^(k)/factorial(k);
    B=c*min(1,num/den);
      clear num den
    num=lambdaA^(k-1)/factorial(k-1);
    den=lambdaA^(k)/factorial(k);
    D=c*min(1,num/den);  
end
