clear all;
clc;

% Constantes
A = [-1 1; 0 0];
B = [0 1; 1 0];
C = [1 0; 0 1];
D = [0 0; 0 0];

% Modelo de sistema continuo
temperatura_ss = ss(A,B,C,D);

% Convertir modelo continuo a modelo discreto
Ts = 0.5; % Tiempo de muestreo
temperatura_d = c2d(temperatura_ss,Ts);

% Asignar entradas de control y perturbación
temperatura_d = setmpcsignals(temperatura_d, 'MV', [1], 'UD', [2]);

% Configuración de MPC
H = 120; %Horizonte de predicción
HC = 120; % Horizonte de control
mpc_temperatura = mpc(temperatura_d, Ts,H,HC); 

% Asignación de pesos
mpc_temperatura.Weights.OutputVariables = [1 0];
mpc_temperatura.Weights.ManipulatedVariables = [0]; % Penalización de la variable de control.

% Restricciones en las variables de control
mpc_temperatura.MV(1).Min = -0.5;
mpc_temperatura.MV(1).Max = 0.5;

% Generación de datos de entrenamiento
Tas = 10:1:35;
Tos = 15:1:30;
T0s = 15:1:30;

X_data = [];
Y_data = [];

for i = 1:length(Tas)
    Ta = Tas(i);
    for j = 1:length(Tos)
    Tobj = Tos(j);
    for k = 1:length(T0s)
        T0 = T0s(k);
        options = mpcsimopt(mpc_temperatura);
        options.PlantInitialState = [T0s 0];

        sim("SimulinkTemperatura.slx");
        X_regression = ans.result(1:200,:);
        Y_regression = ans.Y_value(1:200,:);      
        ta_m = ones(200,1) * Ta;
        to_m = ones(200,1) * Tobj;
        t0_m = ones(200,1) * T0;
        X_data = [X_data; X_regression ta_m to_m t0_m];
        Y_data = [Y_data; Y_regression];      
        end
    end
end

% Guardar datos de entrenamiento en archivos CSV
writematrix(X_data, 'X.csv'); 
writematrix(Y_data,'Y.csv');

%% Generacion de datos de test
% IMPORTANTE: Comentar el codigo de arriba ya que se necesitaria mucha memoria para 
% almacenar toda la informacion.

% Definir variables iniciales
T0 = 25;       % Temperatura inicial
Ta = 25;       % Temperatura ambiente
CL = 0;        % Carga térmica
Tobj = 20;     % Temperatura objetivo
setPoint = [192 82 177 129 106 118 101 295];  % Punto de configuración

% Ejecutar la simulación en Simulink
sim("SimulinkTemperatura.slx");

% Inicializar variables
data = [];      % Matriz para almacenar datos de prueba
count = 0;      % Contador para identificar la fila actual
start = 1;      % Punto de inicio para cortar el resultado de la simulación

% Iterar sobre el vector setPoint
for i = 1:length(setPoint)
    
    row = setPoint(i);  % Fila actual
    result = ans.simulacion;  % Resultado de la simulación
    
    % Cortar el resultado de la simulación y agregar a la matriz "data"
    data = [data; result(start:count*300 + row,:)];
    
    % Actualizar contador y punto de inicio para la siguiente iteración
    count = count + 1;
    start = count*300 + 1;
end

% Escribir la matriz "data" en un archivo .csv
writematrix(data, 'data_test.csv');
