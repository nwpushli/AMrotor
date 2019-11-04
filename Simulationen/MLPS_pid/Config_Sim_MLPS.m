%% ================Rotor===================================================

cnfg.cnfg_rotor.name = 'MLPS - Rotor';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 1e-5;%D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 10;

% Rotor Config
pos.MLL = 113e-3;
pos.MLR = 623e-3;
pos.EddyR2 = 665e-3;

% nur Welle, Komponenten als disc-Objekte
raW = 0.004;
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 raW 0], [0.702 raW 0]};

% Welle mit Versteifung bei Lagerzapfen und bei Scheibe
raW = 0.004;
riW = 0;
raL = raW*1.2;
riL = 0;
raR = raW*1.2;
riR = 0;
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 raW riW], [0.094 raW riW], ... % Welle
    [0.094 raL riL], [0.132 raL riL], [0.132 raW riW], ... % Lagerhuelse 1
    [0.350 raW riW], [0.350 raR riR], [0.376 raR riR], [0.376 raW riW],... % Rotorscheibe, Abschnitt E,F,E
    [0.604 raW riW], [0.604 raL riL], [0.642 raL riL], ... % Lagerhuelse 2
    [0.642 raW riW], [0.702 raW riW], [0.702 0 0]}; % Welle


% FEM Config
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.01;
% cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean, symmetric.

% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'grobes Netz';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.04;
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean, symmetric.

    
%% =========================Komponenten====================================
count = 0;
cnfg.cnfg_component = []; 

%% Massescheiben
count = count+1;
cnfg.cnfg_component(count).name = 'ML_Lauefer_L'; % inkl. Spannhuelsen
cnfg.cnfg_component(count).type = 'Disc';
cnfg.cnfg_component(count).position = pos.MLL;                 %disc position [m]
cnfg.cnfg_component(count).radius = 46e-3;  
cnfg.cnfg_component(count).m = 0.85074;                       %disc mass [kg]
cnfg.cnfg_component(count).Jx = 4.840066e-4;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jz = 4.036839e-4;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz;     %disc polar mom. of inertia [kg*m^2]

count = count+1;
cnfg.cnfg_component(count).name = 'Massescheibe'; % inkl. Spannhuelsen+Fanglagerhuelsen+SChrauben+Muttern
cnfg.cnfg_component(count).type = 'Disc';
cnfg.cnfg_component(count).position = 363e-3;                 %disc position [m]
cnfg.cnfg_component(count).radius = 96e-3;  
cnfg.cnfg_component(count).m = 1.276499;                       %disc mass [kg]
cnfg.cnfg_component(count).Jx = 1.487212e-3;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jz = 2.832751e-3;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz;     %disc polar mom. of inertia [kg*m^2]

count = count+1;
cnfg.cnfg_component(count).name = 'ML_Lauefer_R'; % inkl. Spannhuelsen
cnfg.cnfg_component(count).type = 'Disc';
cnfg.cnfg_component(count).position = pos.MLR;                 %disc position [m]
cnfg.cnfg_component(count).radius = 46e-3;  
cnfg.cnfg_component(count).m = 0.85074;                       %disc mass [kg]
cnfg.cnfg_component(count).Jx = 4.840066e-4;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jz = 4.036839e-4;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz;     %disc polar mom. of inertia [kg*m^2]

%% Lager

% fuer in MLPS eingebauten Rotor
% kSchaetzung = 1.1e5; % geschaetzt fuer P=5000
kSchaetzung = 3.5e4; % geschaetzt fuer P=3000
% dSchaetzung = 200; %vgl. MA Maierhofer S.34
% dSchaetzung = 20; % fuer P=5000, da d=200 viel zu hohe Daempfungen liefert
dSchaetzung = 90; % fuer P=3000, da d=200 viel zu hohe Daempfungen liefert
kML = kSchaetzung;
dML = dSchaetzung;%dSchaetzung;
count = count +1;
cnfg.cnfg_component(count).name = 'Axiales Lager Links';
cnfg.cnfg_component(count).position=pos.MLL;                        %[m]
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleAxialBearing';
cnfg.cnfg_component(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_component(count).damping = 0;

count = count + 1;
cnfg.cnfg_component(count).name = 'Torque Lager Links';
cnfg.cnfg_component(count).position=pos.MLL;                        %[m]
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleTorqueBearing';
cnfg.cnfg_component(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_component(count).damping = 0;

% count = count + 1;
% cnfg.cnfg_component(count).name = 'Isotropes Lager 1';
% cnfg.cnfg_component(count).position=pos.MLL;                        %[m]
% cnfg.cnfg_component(count).type='Bearings';
% cnfg.cnfg_component(count).subtype='SimpleBearing';
% cnfg.cnfg_component(count).stiffness=kML;%0.0670680e7*0.5;         %[N/m]
% cnfg.cnfg_component(count).damping = dML;%299.275;
% 
% count = count + 1;
% cnfg.cnfg_component(count).name = 'Isotropes Lager 2';
% cnfg.cnfg_component(count).position=pos.MLR;                        %[m]
% cnfg.cnfg_component(count).type='Bearings';
% cnfg.cnfg_component(count).subtype='SimpleBearing';
% cnfg.cnfg_component(count).stiffness=kML;%0.0670680e7*0.5;         %[N/m]
% cnfg.cnfg_component(count).damping = dML;%299.275;

%% ====================Sensoren============================================
cnfg.cnfg_sensor=[];
count = 0; 

% Sensoren fuer eingebauten Rotor in MLPS
count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyL1';
cnfg.cnfg_sensor(count).position=0.071;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'WegMLL';
cnfg.cnfg_sensor(count).position=0.113;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyL2';
cnfg.cnfg_sensor(count).position=0.155;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Laser';
cnfg.cnfg_sensor(count).position=0.363;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyR1';
cnfg.cnfg_sensor(count).position=0.581;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='WegMLR';
cnfg.cnfg_sensor(count).position=0.623;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyR2';
cnfg.cnfg_sensor(count).position=pos.EddyR2;
cnfg.cnfg_sensor(count).type='Displacementsensor';


% count = count + 1;
% cnfg.cnfg_sensor(count).name='KraftMLL';
% cnfg.cnfg_sensor(count).position=0.113;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='KraftLaser';
% cnfg.cnfg_sensor(count).position=0.363;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='KraftMLR';
% cnfg.cnfg_sensor(count).position=0.623;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='ReglerKraftMLL';
cnfg.cnfg_sensor(count).position=pos.MLL;
cnfg.cnfg_sensor(count).type='ControllerForceSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='ReglerKraftMLR';
cnfg.cnfg_sensor(count).position=pos.MLR;
cnfg.cnfg_sensor(count).type='ControllerForceSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='AnregungsKraftMLL';
cnfg.cnfg_sensor(count).position=pos.MLL;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='AnregungKraftMLR';
cnfg.cnfg_sensor(count).position=pos.MLR;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';


%% =========================Lasten=========================================
cnfg.cnfg_load=[];
count = 0;

% Kraft in feste Richtung, Sprung
% count = count + 1;
% cnfg.cnfg_load(count).name='Const. Kraft'; 
% cnfg.cnfg_load(count).position=363e-3;
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).type='Force_constant_fix';

% Unwuchten
% count = count + 1;
% cnfg.cnfg_load(count).name = 'Kleine Unwucht';
% cnfg.cnfg_load(count).position = 363e-3;
% cnfg.cnfg_load(count).betrag = 10e-3;%5e-6;
% cnfg.cnfg_load(count).winkellage = 0;
% cnfg.cnfg_load(count).type='Unbalance_static';

% Sinusförmige Anregungskraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Sinus Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).frequency_x= 500;  %in Hz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y= 50;
% cnfg.cnfg_load(count).type='Force_timevariant_fix';

% Whirl, Anregungskraft beschreibt Ellipse
% count = count + 1;
% cnfg.cnfg_load(count).name='Whirl Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= 10;
% cnfg.cnfg_load(count).frequency= 500;  %in Hz
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd';

% Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft MLL';
% cnfg.cnfg_load(count).position=pos.MLL; 
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_start= 0;
% cnfg.cnfg_load(count).t_end= 1; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft MLR';
% cnfg.cnfg_load(count).position=pos.MLR; 
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).frequency_x_0 = 200; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 0;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_start= 0;
% cnfg.cnfg_load(count).t_end= 1; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% whirl-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 1000;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_start = 0.1;%2; % Startzeitpunkt
% cnfg.cnfg_load(count).t_end= 0.6;%endzeitpunkt des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';

% Look Up table Kraft
count = count + 1;
cnfg.cnfg_load(count).name='Random Kraft MLL';
cnfg.cnfg_load(count).position=pos.MLL; 
cnfg.cnfg_load(count).LUT.time = 0:1e-3:5;
cnfg.cnfg_load(count).LUT.Fx = rand(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Fy = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Fz = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Mx = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.My = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Mz = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).type='Force_timevariant_LUT';

% Look Up table Kraft
count = count + 1;
cnfg.cnfg_load(count).name='Random Kraft MLR';
cnfg.cnfg_load(count).position=pos.MLR; 
cnfg.cnfg_load(count).LUT.time = 0:1e-3:5;
cnfg.cnfg_load(count).LUT.Fx = rand(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Fy = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Fz = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Mx = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.My = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Mz = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).type='Force_timevariant_LUT';
%% ========================PID-Regler======================================
cnfg.cnfg_pid_controller=[];
count = 0;

%% ======================Active Magnetic Bearing========================
cnfg.cnfg_activeMagneticBearing = [];
count = 0;

electricalP = 5000;%5000; %A/m
electricalI = 1500;%1500; %A/ms
electricalD = 5;%5; %As/m

count = count + 1;
cnfg.cnfg_activeMagneticBearing(count).name = 'AMB1';
cnfg.cnfg_activeMagneticBearing(count).position = pos.MLL;
cnfg.cnfg_activeMagneticBearing(count).pidType = 'pidControllerLinear'; % type of the created pidController-object
cnfg.cnfg_activeMagneticBearing(count).kx = -1e5; %N/m, kx und ki aus Messung Dietz
cnfg.cnfg_activeMagneticBearing(count).ki = 50; %A/N
cnfg.cnfg_activeMagneticBearing(count).targetDisplacementX = 0;
cnfg.cnfg_activeMagneticBearing(count).targetDisplacementY = 0;
cnfg.cnfg_activeMagneticBearing(count).electricalP = electricalP; %A/m
cnfg.cnfg_activeMagneticBearing(count).electricalI = electricalI; %A/ms
cnfg.cnfg_activeMagneticBearing(count).electricalD = electricalD; %As/m

count = count + 1;
cnfg.cnfg_activeMagneticBearing(count).name = 'AMB2';
cnfg.cnfg_activeMagneticBearing(count).position = pos.MLR;
cnfg.cnfg_activeMagneticBearing(count).pidType = 'pidControllerLinear'; % type of the created controller-object
%kx und ki aus Messung Dietz
cnfg.cnfg_activeMagneticBearing(count).kx = -1e5; %N/m
cnfg.cnfg_activeMagneticBearing(count).ki = 50; %A/N
cnfg.cnfg_activeMagneticBearing(count).targetDisplacementX = 0;
cnfg.cnfg_activeMagneticBearing(count).targetDisplacementY = 0;
cnfg.cnfg_activeMagneticBearing(count).electricalP = electricalP; %A/m
cnfg.cnfg_activeMagneticBearing(count).electricalI = electricalI; %A/ms
cnfg.cnfg_activeMagneticBearing(count).electricalD = electricalD; %As/m