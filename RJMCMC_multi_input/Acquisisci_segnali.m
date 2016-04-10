% data=('D:\Underwater\RJMCMC_multi_input\SIMPLE_SIMULATION_DATA\Simulazioni_salvate\Simulation2016_04_07_17_12_01__2016_04_07_17_19_55.mat')
% load(data)
u{1}=Simulation.U;
u{2}=Simulation.V;
u{3}=Simulation.W;
u{4}=Simulation.P;
u{5}=Simulation.Q;
u{6}=Simulation.R;
u{7}=Simulation.X;
u{8}=Simulation.Y;
u{9}=Simulation.Z;
u{10}=Simulation.L;
u{11}=Simulation.M;
u{12}=Simulation.N;
% y=u{1};
inputs_names='UVWPQRXYZLMN';
eestim=zeros(1,length(u{1}));