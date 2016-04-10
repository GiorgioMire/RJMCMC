function [Sets]=Inizializza_insiemi()
global mc
clear t
%u{1}=U
%u{2}=V
%u{3}=W
%u{4}=P
%u{5}=Q
%u{6}=R
%u{7}=X
%u{8}=Y
%u{9}=Z
%u{10}=L
%u{11}=M
%u{12}=N
Sets.Process_all={@(t,u,y)y(t-1) ...
    @(t,u,y)u{1}(t)^2};
   
Sets.Noise_all={%@(t,u,y,e)e(t-1)...
            @(t,u,y,e)e(t-1)*u{2}(t-1)...
            @(t,u,y,e)e(t-1)*u{3}(t-1)...
            @(t,u,y,e)e(t-1)*u{4}(t-1)};


mc.Process_avaiable=1:length(Sets.Process_all);
mc.Process_choosen=[];

     
mc.Noise_avaiable=1:length(Sets.Noise_all);
mc.Noise_choosen=[];

end