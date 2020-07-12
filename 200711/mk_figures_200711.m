function mk_figures_200711(fignum)
% Creates the figures for The Wave 2
%
% Gunnar Jeschke, 11.07.-12.07.2020

% add next higher directory, where the subroutines are, to Matlab path
addpath('..');

% if the user does not supply a figure number, display Figure 2 (USA)
if ~exist('fignum','var') || isempty(fignum)
    fignum = 2;
end

% select the country corresponding to the requested figure number,
% here is where you can insert additional countries, but note that the
% model is applicable only to European and North American countries
% you need the international three-letter code:
% https://www.worldatlas.com/aatlas/ctycodes.htm

switch fignum
    case 1
        TLC = 'CAN';
    case 2
        TLC = 'USA';
    case 3
        TLC = 'FRA';
    case 4
        TLC = 'SWE';
    case 5
        TLC = 'DEU';
    case 6
        TLC = 'CHE';
    otherwise % default if an undefined figure number is requested
        fprintf(1,'Warning: Undefined figure number. Defaulting to 2 (USA)\n');
        TLC = 'USA';
end

% end of fit range for convolutiomn
% exception for Canada, longer range for convolution fit, since peak of
% death curve is passed much later
if strcmp(TLC,'CAN')
    last_day = 130;
else
    last_day = 116;
end

% end of fit range for logistic-exponential model
endfit = 152;

% exception for France, scale down plot range for better view
% excludes a few data points, but does not create a wrong impression
if strcmp(TLC,'FRA')
    scale_down1 = 0.6;
    scale_down2 = 0.6;
else
    scale_down1 = 1;
    scale_down2 = 1;
end

% load data as of 10.07.2020
% you can use later data loaded with reload_world_data_covid, but
% the model will probably not apply very long after July 12th
data = load('world_data_covid19_200710.mat');

% extra the test and death data from EU Open data (probably mostly
% originally from the Johns Hopkins database)
% the data from the Oxford file are cumulative and are updated later
tests = data.world_data_covid.(TLC).EUCases;
deaths = data.world_data_covid.(TLC).EUDeaths;
poi = length(tests); % last day for which data are supplied

% display does not start earlier than February 1st
display_range = [32,poi];

% Generate one-week moving averages by digital filtering
b = ones(1,7)/7;
a = 1;
sm_tests = filter(b,a,tests);
sm_deaths = filter(b,a,deaths);

% top left panel
figure(1); clf; hold on
set(gcf,'defaultAxesColorOrder',[[0.75,0,0]; [0,0,0]]);
yyaxis left
plot(tests,'.','MarkerSize',14,'Color',[0.75,0,0]);
plot(sm_tests,'-','LineWidth',2.5,'Color',[0.75,0.4,0.4]);
ylabel('Daily number of tests'); 
axis([display_range(1),display_range(2),0,scale_down1*1.05*max(tests)]);
yyaxis right
plot(deaths,'k.','MarkerSize',14);
plot(sm_deaths,'-','LineWidth',2.5,'Color',[0.5,0.5,0.5]);
plot([last_day,last_day],[0,sm_deaths(last_day)],':','Color',[0,0.5,0],'LineWidth',2);
set(gca,'FontSize',14);
axis([display_range(1),display_range(2),0,scale_down1*1.05*max(deaths)]);
xlabel(sprintf('%s to %s',get_date_2020(display_range(1)),get_date_2020(display_range(2))));
ylabel('Daily number of deaths'); 
title(TLC);

fprintf(1,'Convolution range until %s\n',get_date_2020(last_day)); 

% Fit the convolution parameters and do the convolution
[conv_tests,~,shift,width,scaling] = fit_tests_to_deaths(tests,deaths,last_day);

% top right panel
figure(2); clf; hold on
set(gcf,'defaultAxesColorOrder',[[0.75,0,0]; [0,0,0]]);
yyaxis left
plot(conv_tests/scaling,'.','MarkerSize',14,'Color',[0.75,0,0]);
ylabel('Daily number of tests'); 
axis([display_range(1),display_range(2),0,scale_down2*1.05*max(deaths)/scaling]);
% plot(sm_conv_tests,'-','LineWidth',2,'Color',[0.75,0.4,0.4]);
yyaxis right
plot(deaths,'k.','MarkerSize',14);
plot(sm_deaths,'-','LineWidth',2,'Color',[0.25,0.25,0.25]);
set(gca,'FontSize',14);
axis([display_range(1),display_range(2),0,scale_down2*1.05*max(deaths)]);
xlabel(sprintf('%s to %s',get_date_2020(display_range(1)),get_date_2020(display_range(2))));
ylabel('Daily number of deaths'); 

fprintf(1,'Convolution with shift %4.1f, width %3.1f, and scaling %4.1f%%\n',shift,width,100*scaling);
title(sprintf('Convolution with shift of %4.1f and width of %3.1f days',shift,width));
fprintf(1,'Fit range until %s\n',get_date_2020(endfit)); 

taxis = 1:endfit; % time axis (days)
extrap_range = endfit+1:length(conv_tests); % range for extrapolation

% fit the positive tests (convoluted) by the logistic-exponential model
[~,fit_curve,param,~,full_curve_tests] = full_fit_covid19_cumulative(taxis,conv_tests);
full_curve_tests = full_curve_tests(1:length(conv_tests));

yyaxis left
plot(taxis,fit_curve/scaling,'-','LineWidth',3,'Color',[0.8,0.3,0]);
plot([endfit,endfit],[0,conv_tests(endfit)/scaling],':','Color',[0,0.5,0],'LineWidth',2);
plot(extrap_range,full_curve_tests(extrap_range)/scaling,':','LineWidth',2.5,'Color',[0.8,0.3,0]);

fprintf('Test fit with rise time %4.1f days and half time at day %s\n',param.t_rise,get_date_2020(param.t_half));

% fith the death numbers by the logistic-exponential model
[~,fit_curve,param,~,full_curve_deaths] = full_fit_covid19_cumulative(taxis,deaths);

full_curve_deaths = full_curve_deaths(1:length(deaths));

yyaxis right
plot(taxis,fit_curve,'-','LineWidth',3,'Color',[0,0,0.6]);
plot(extrap_range,full_curve_deaths(extrap_range),':','LineWidth',2.5,'Color',[0,0,0.6]);

fprintf('Death fit with rise time %4.1f days and half time at day %s\n',param.t_rise,get_date_2020(param.t_half));

% compute cumulated deviations of the data from the prediction (full range) 
deviation_tests = cumsum(conv_tests-full_curve_tests);
deviation_deaths = cumsum(deaths-full_curve_deaths);

% bottom left panel
figure(3); clf; hold on;
set(gcf,'defaultAxesColorOrder',[[0.75,0,0]; [0,0,0]]);
yyaxis left
plot(deviation_tests/scaling,'.','MarkerSize',14,'Color',[0.75,0,0]);
ylabel('Cumulated deviation from test prediction');
yyaxis right
plot(deviation_deaths,'.','MarkerSize',14,'Color',[0,0,0]);
ylabel('Cumulated deviation from death prediction');
set(gca,'FontSize',14);
axis([last_day,display_range(2),1.25*min([min(deviation_tests(last_day:end)),...
    min(deviation_deaths(last_day:end))]),...
    1.1*max([max(deviation_tests(last_day:end)),max(deviation_deaths(last_day:end))])]);
xlabel(sprintf('%s to %s',get_date_2020(last_day),get_date_2020(display_range(2))));
title('Deviation from exponential decay predictions');

fprintf(1,'Deviation of predicted number of tests since %s: %i\n',get_date_2020(endfit+1),deviation_tests(end)/scaling);
fprintf(1,'Deviation of predicted number of deaths since %s: %i\n',get_date_2020(endfit+1),deviation_deaths(end));

fprintf(1,'Current lethality: %4.2f%%\n',100*sm_deaths(end)/(full_curve_tests(end)/scaling));
fprintf(1,'Lethality in excess over prediction: %4.2f%%\n',100*deviation_deaths(end)/(deviation_tests(end)/scaling));

lethality = scaling*100*sm_deaths(last_day+1:end)./(conv_tests(last_day+1:end)+1e-6);

% bottom right panel
figure(4); clf; hold on;
plot(last_day+1:display_range(2),lethality,'k.','MarkerSize',18);
set(gca,'FontSize',14);
axis([last_day+1,display_range(2)+1,0.9*min(lethality),1.05*max(lethality)]);
xlabel(sprintf('%s to %s',get_date_2020(last_day+1),get_date_2020(display_range(2))));
ylabel('Lethality (% of positive  tests)'); 
title('Trend of lethality among positive SARS-Cov2 tests');