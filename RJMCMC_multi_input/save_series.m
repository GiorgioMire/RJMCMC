function [Series]=save_series(Series,residual)
global mc
Series.sq(mc.it)=mc.q;
Series.sk(mc.it)=mc.k;
Series.slambA(mc.it)=mc.lambdaA;
Series.slambB(mc.it)=mc.lambdaB;
Series.svA(mc.it)=mc.sigmaA^2;
Series.svB(mc.it)=mc.sigmaB^2;
Series.svarEps(mc.it)=var(residual);
Series.Residuals(mc.it,:)=residual;
end