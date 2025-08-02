% =========================================================================
% Project      : Green Electricity
% Filename     : inputs.m
% Author       : Mohammad Izadi
% Created On   : 01-06-2024
% Last Updated : 30-06-2025
% Version      : v0.1.1 - Input data for renewable green electricity
% Modified By  : Ali Izadi -
%
% Description  :
% Dependencies :
% 'pv_capacity_factors_typical_year_8760.csv'
% 'wind_capacity_factors_typical_year_8760.csv'
% This version also supports PV and Wind Capacity Factor analysis for the
% following countries:
% Albania, Austria, Bosnia and Herzegovina, Belgium, Bulgaria, Switzerland,
% Cyprus, Czech Republic, Germany, Denmark, Estonia, Spain, Finland, France,
% Great Britain, Greece, Croatia, Hungary, Ireland, Italy, Lithuania,
% Luxembourg, Latvia, Moldova, Montenegro, North Macedonia, Malta,
% Netherlands, Norway, Poland, Portugal, Romania, Serbia, Sweden,
% Slovenia, Slovakia
%
% Usage Notes  :
% Change Log   :
% v0.1.1 - 30/07/2025 - Using the distribution of annual capacity factor for both PV and wind turbine in Typical year
% =========================================================================

%% Inputs for PV and Wind Capacity Factors
% Select country
selected_country = 'Netherlands';

% Power densities
power_density_pv   = 0.05;     % [kW/m^2] typical for ground-mounted PV
power_density_wind = 0.003;    % [kW/m^2] typical for onshore wind farms

% --- Load PV Capacity Factors ---
pkg load io  % Required for csv2cell
pv_file = 'pv_capacity_factors_typical_year_8760.csv';
pv_raw = csv2cell(pv_file);
pv_countries = pv_raw(1, :);
pv_data = cell2mat(pv_raw(2:end, :));

PV_CF = struct();
for i = 1:length(pv_countries)
    cname = strrep(pv_countries{i}, ' ', '_');
    PV_CF.(cname) = pv_data(:, i);
end

% --- Load Wind Capacity Factors ---
wind_file = 'wind_capacity_factors_typical_year_8760.csv';
wind_raw = csv2cell(wind_file);
wind_countries = wind_raw(1, :);
wind_data = cell2mat(wind_raw(2:end, :));

Wind_CF = struct();
for i = 1:length(wind_countries)
    cname = strrep(wind_countries{i}, ' ', '_');
    Wind_CF.(cname) = wind_data(:, i);
end

% Set PV and Wind capacity factors for selected country
pv_cf_selected     = PV_CF.(selected_country);
% --- Validation for input data dimensions, PV  ---
if length(pv_cf_selected) ~= 8760
    error('pv_cf_selected must contain 8760 hourly values (one year at hourly resolution).');
end

wind_cf_selected   = Wind_CF.(selected_country);
% --- Validation for input data dimensions, Wind
if length(wind_cf_selected) ~= 8760
    error('wind_cf_selected must contain 8760 hourly values (one year at hourly resolution).');
end

cf_pv_annual_ave   = sum(pv_cf_selected)/(365*24);   % Annual average of PV Capacity Factor for the selected country
cf_wind_annual_ave = sum(wind_cf_selected)/(365*24); % Annual average of Wind Capacity Factor for the selected country


% Read CSV file as a cell array
%irradiationdata = csv2cell('Climate370_irradiation.csv');
%irradiationdata = csv2cell('irradiation19.csv');
%windspeeddata = csv2cell('Climate370_windspeed.csv');
%windspeeddata   = csv2cell('Velocity19.csv');

Deltat=1; %weather data time resolution [h]
months_hours = [744, 672, 744, 720, 744, 720, 744, 744, 720, 744, 720, 744];
%% general
Demand=365*24*10000;  %total demand [kWh] of a year
Demand_day=Demand/365; %Average daily Demand
%alpha=0.3;    %pv to total demand ratio, scale [0 1], Wind Turbine to total demand ratio=1-alpha======
%beta=3;       %battery capacity per hour-demend ratio, scale [0 10]
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



