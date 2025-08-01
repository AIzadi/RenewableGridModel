%% data
% Read CSV file as a cell array
%irradiationdata = csv2cell('Climate370_irradiation.csv');
irradiationdata = csv2cell('irradiation19.csv');
%windspeeddata = csv2cell('Climate370_windspeed.csv');
windspeeddata = csv2cell('Velocity19.csv');

Deltat=1; %weather data time resolution [h]
months_hours = [744, 672, 744, 720, 744, 720, 744, 744, 720, 744, 720, 744];
%% general
Demand=365*24*10000;  %total demand [kWh] of a year
Demand_day=Demand/365; %Average daily Demand
%alpha=0.3;    %pv to total demand ratio, scale [0 1], windturbin to total demand ratio=1-alpha======
%beta=3;     %battery capacity per hour-demend ratio, scale [0 10]
PowerDemand=Demand/(sum(months_hours)/Deltat).*ones(sum(months_hours)/Deltat,1); %Demand power [kW] during a year
%% PV
%Nominal power=445w
eta_pv=0.24; %efficiency of pv technologies
%n_p=25; %number of PV panels
A_pv=1.849; %Area of pv technologies [m^2]  (1812 x 1046mm   1787 x 1035 mm)

%% Wind Turbine
v_cutin=  3.6;      %cut-in speed: Minimum wind speed at which the turbine starts generating power [m/s]
v_cutout=  20;      %cou-out speed: Maximum wind speed at which the turbine will stop operating Maximum wind speed at which the turbine will stop operating [m/s]
v_rated=  12.5;       %Rated speed [m/s]
A_sw= 28.27;         %Sweep Area :Area swept by turbine blades [m^2]
rho=1.225;          %Air density[kg/m^3]
p_w_rated=  10000 ;  %rated power [W]


%% Energy staorage system
s_b= 100 ; %Unit size of the ESS [kWh]
%n_b=ceil(Demand_day*beta/24/s_b);%realizing the number of required ESS modules
P_b_max_ch=100; %max power of charging the battery [kW]
P_b_max_dis=75; %max power of discharging the battery [kW]
eta_ch=0.95;  %charge efficiency
eta_dis=0.95;  %discharge efficiency
E_max=1; %maximum allowable state of charge SOC
E_min= 0.05; %minimum allowable state of charge SOC
E_b_o= 0.9; %initial SOC of battery , scale[0 1]
z_b= 0.008; %self-discharge rate



