%% Toma de tiempo
% La idea es poder tomar el tiempo de cpu que toma el controlador para 
% obtener la informacion necesaria.

%% Constantes
T0 = 25; Ta= 25;
Tobjs = 10:2:34;
CL = 0;
%% Controlador MPC
A = [-1 1; 0 0];
B = [0 1; 1 0];
C = [1 0; 0 1];
D = [0 0; 0 0];

temperatura_ss = ss(A,B,C,D);

Ts = 0.5; % Tiempo de muestreo
temperatura_d = c2d(temperatura_ss,Ts);

temperatura_d = setmpcsignals(temperatura_d, 'MV', [1], 'UD', [2]);

H = 120;
HC = 120;
mpc_temperatura = mpc(temperatura_d, Ts,H,HC); 
mpc_temperatura.Weights.OutputVariables = [1 0];
mpc_temperatura.Weights.ManipulatedVariables = [0]; % Penalizacion de la variable de control.
mpc_temperatura.MV(1).Min = -0.5;
mpc_temperatura.MV(1).Max = 0.5;

%% Simulacion
%times_cputime = zeros(1,length(Tobjs));
times_tictoc = zeros(1,length(Tobjs));
for i = 1:length(Tobjs)
    Tobj = Tobjs(i);
    tic;
    %tStart = cputime;
    sim("SimulinkTemperatura.slx");
    %tEnd = cputime - tStart;
    %times_cputime(i) = tEnd;
    times_tictoc(i) = toc;
end

