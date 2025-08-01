pkg load io
%% Balance equation:     P_ren_tot + P_b + P_g = P_dem
% P_ren>=0 ; P_dem>=0
% battery charging :    P_b<0
% battery discharging : P_b>0
%grid withdrawal : P_g>0
%grid injection :  P_g<0
%%
clear all;clc; close all
warning("off");
inputs;
irradiationdata  = cell2mat(irradiationdata);
winddata         = cell2mat(windspeeddata);


% Create a vector for the months based on the number of data points in each month
months = [];
for month = 1:12
    months = [months, repmat(month, 1, months_hours(month))]; % Assign the month number to each hour
end
grid_with_final=[];
PR   = [];
MHE   = [];
GwE   = [];
GiE   = [];
NSH   = [];
Gamma = [0.2:0.1:4]';
for alpha=0:0.1:1
  gridwithdrawal=[]; %sum of the energy withdrawn from the grid
  gridinjection=[];  %sum of the energy injected into the grid
  GiE_Gamma   = [];
  beta = 1;
  for gamma  = 0.2:0.1:4
    run('BestGamma.m');
  end
  PowerRealization = 100+sum(GiE_Gamma(:,4:15),2)/1e4/365/24;
  % Utilization = sum(MHE(:,4:15),2)/sum(months_hours)*100;
  Criteria = PowerRealization/100;
  Best= max(Criteria);
  indx = find(Criteria == Best);
  gamma = Gamma(indx);
  disp(['Best Gamma: ', num2str(Gamma(indx))]);

  for beta=0:0.5:5
      run('Alpha_Beta.m');
  end
end
%  grid_with_final=[grid_with_final;gridwithdrawal];

xlswrite('GE_data.xlsx', PR, 'PR');                            % Save Summary Sheet
xlswrite('GE_data.xlsx', MHE, 'MHE');                          % Save Summary Sheet
xlswrite('GE_data.xlsx', GwE, 'GwE');                          % Save Summary Sheet
xlswrite('GE_data.xlsx', GiE, 'GiE');                          % Save Summary Sheet
%xlswrite('Velocity.xlsx', winddata);                          % Save Summary Sheet
##%% result
##alpha = 0:0.5:1;  % Row values (11 elements)
##beta = 0:5:10;   % Column values (11 elements)
##
##figure;
##hold on; % Keep all plots on the same figure
##
##% Plot each row as a separate line
##for i = 1:length(alpha)
##    plot(beta, grid_with_final(i,:), 'DisplayName', sprintf('\\alpha = %.2f', alpha(i)));
##end
##
##hold off;
##xlabel('\beta'); ylabel('grid withdrawal [kWh');
##title('Plot of grid withdrawal vs \beta for different \alpha values');
##legend show; % Display the legend
##grid on; % Add grid for better visualization


