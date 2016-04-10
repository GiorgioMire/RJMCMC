function [Sett]=Settings_by_GUI()
close all
try
    load('Setting_struct.mat');
   parameters = fieldnames(Sett);
   for j=1:length(parameters)
       value{j}=getfield(Sett,parameters{j});
   end
 
catch
 S=struct();
 parameters={'lambdaP',...
     'lambdaN',...
'sigmaP',...
'sigmaN',...
'sigmaEP',...
'sigmaEN',...
'cc',...
'dynamicOrder',...
'niter',...
'windowSize',...
'plot_residual',...
'repeat',...
'burnin',...
'periodo_salvataggi',...
'alphaLA',...
'alphaLB',...
'betaLA',...
'betaLB',...
'betaA',...
'betaB',...
'alphaA',...
'alphaB',...
'betaE',...
'alphaE'...
}
for j=1:length(parameters)
 value{j}=nan;
end
end

% load('Settings.mat')
% parameters = fieldnames(Settings_struct)
%  Create and then hide the UI as it is being constructed.
   f = figure('Visible','off','Units','normalized','Position',[0.01,0.01,1-0.2,1-0.3]);
set(gcf, 'MenuBar', 'None')
   set(gcf,'units','characters')
pos=get(gcf,'position');
   %  Construct the components.
  
   
   nmax=round(pos(4)/4);
   lineh=2;
   columnsize=30;
   for j=1:length(parameters)
   
   ncol=idivide(uint64(j),uint64(nmax));
   htext(j) = uicontrol('Parent',f,'Style','text','String',parameters{j},'Units','characters','Position',[1+2*ncol*columnsize,pos(4)-lineh*mod(j,nmax)-3-(j>=nmax)*lineh,columnsize,lineh]);
   
   end
   
      for j=1:length(parameters)
         ncol=idivide(uint64(j),uint64(nmax));  
   hvalue(j) = uicontrol('Callback',{@field_callback,parameters{j}},'Parent',f,'Style','edit','String',num2str(value{j}),'Units','characters','Position',[1+(2*ncol+1)*columnsize,pos(4)-lineh*mod(j,nmax)-3-(j>=nmax)*lineh,columnsize,lineh])
   end
%    align([htext],'Left','Fixed',0.01);
   %Make the UI visible.
   % Assign the a name to appear in the window title.
f.Name = 'PARAMETRI ALGORITMO RJMCMC';

% Move the window to the center of the screen.
movegui(f,'center')
   f.Visible = 'on';
   function field_callback(obj,evt,arg1)
 str=sprintf('Sett.%s=%f;',arg1,str2num(obj.String))
 eval(str)
 save('Setting_struct.mat','Sett');
   end
uiwait(gcf)
end
