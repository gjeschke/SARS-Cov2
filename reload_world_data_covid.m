function [world_data_covid,time_stamp,TLCs] = reload_world_data_covid
% Don't, don't, don't look at how this is done
% it is extremely inefficient
% I won't even sign my name here
% (but it works and needs to run only once a day)
% would work much faster with newer Matlab functions, which are not,
% however, available before version 2019

% record time of the data download
time_stamp = datetime; 

% initialize one data field, sorry no comments
world_data_covid.XXX.TLC = 'XXX';
world_data_covid.XXX.country = 'XXX';
world_data_covid.XXX.population = [];
world_data_covid.XXX.positives = [];
world_data_covid.XXX.deaths = [];
world_data_covid.XXX.C1_School_closing = [];
world_data_covid.XXX.C1_Flag = false;
world_data_covid.XXX.C2_Workplace_closing = [];
world_data_covid.XXX.C2_Flag = false;
world_data_covid.XXX.C3_Cancel_public_events = [];
world_data_covid.XXX.C3_Flag = false;
world_data_covid.XXX.C4_Restrictions_on_gatherings = [];
world_data_covid.XXX.C4_Flag = false;
world_data_covid.XXX.C5_Close_public_transport = [];
world_data_covid.XXX.C5_Flag = false;
world_data_covid.XXX.C6_Stay_at_home_requirements = [];
world_data_covid.XXX.C6_Flag = false;
world_data_covid.XXX.C7_Restrictions_on_internal_movement = [];
world_data_covid.XXX.C7_Flag = false;
world_data_covid.XXX.C8_International_travel_controls = [];
world_data_covid.XXX.H1_Public_information_campaign = [];
world_data_covid.XXX.H1_Flag = false;
world_data_covid.XXX.H2_Testing_policy = [];
world_data_covid.XXX.H3_Contact_tracing = [];
world_data_covid.XXX.H4_Emergency_investment_in_healthcare = [];
world_data_covid.XXX.H5_Investment_in_vaccines = [];
world_data_covid.XXX.ConfirmedCases = zeros(1,365);
world_data_covid.XXX.ConfirmedDeaths = zeros(1,365);
world_data_covid.XXX.NewCases = zeros(1,365);
world_data_covid.XXX.NewDeaths = zeros(1,365);
world_data_covid.XXX.StringencyIndex = zeros(1,365);
world_data_covid.XXX.cases_smoothed = zeros(1,365);
world_data_covid.XXX.cases_fit_curve = zeros(1,365);
world_data_covid.XXX.cases_rmsd = [];
world_data_covid.XXX.cases_deviation = [];
world_data_covid.XXX.cases_t_half = [];
world_data_covid.XXX.cases_t_rise = [];
world_data_covid.XXX.cases_rise_10 = [];
world_data_covid.XXX.cases_rise_90 = [];
world_data_covid.XXX.cases_t_max = [];
world_data_covid.XXX.cases_t_fall = [];
world_data_covid.XXX.cases_fall_10 = [];
world_data_covid.XXX.cases_fall_90 = [];
world_data_covid.XXX.deaths_smoothed = zeros(1,365);
world_data_covid.XXX.deaths_fit_curve = zeros(1,365);
world_data_covid.XXX.deaths_rmsd = [];
world_data_covid.XXX.deaths_deviation = [];
world_data_covid.XXX.deaths_t_half = [];
world_data_covid.XXX.deaths_t_rise = [];
world_data_covid.XXX.deaths_rise_10 = [];
world_data_covid.XXX.deaths_rise_90 = [];
world_data_covid.XXX.deaths_t_max = [];
world_data_covid.XXX.deaths_t_fall = [];
world_data_covid.XXX.deaths_fall_10 = [];
world_data_covid.XXX.deaths_fall_90 = [];
world_data_covid.XXX.valid_cases_rise = false;
world_data_covid.XXX.valid_cases_fall = false;
world_data_covid.XXX.valid_deaths_rise = false;
world_data_covid.XXX.valid_deaths_fall = false;
world_data_covid.XXX.predictor_cases_rise = false;
world_data_covid.XXX.predictor_cases_fall = false;
world_data_covid.XXX.predictor_deaths_rise = false;
world_data_covid.XXX.predictor_deaths_fall = false;
world_data_covid.XXX.stringency_valid = false;
world_data_covid.XXX.continent = '';

% download data from EU Open Data and initialize countries
websave('world_data_covid19.csv','https://opendata.ecdc.europa.eu/covid19/casedistribution/csv');
fid = fopen('world_data_covid19.csv','rt');
fgetl(fid);
nl = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    nl = nl + 1;
    arguments = split(tline,',');
    this_country = arguments{7};
    TLC = arguments{9};
    if ~isempty(TLC) && ~isfield(world_data_covid,TLC) && ~strcmpi(TLC,'N/A')
        world_data_covid.(TLC).TLC = TLC;
        world_data_covid.(TLC).country = this_country;
        world_data_covid.(TLC).population = [];
        world_data_covid.(TLC).positives = zeros(1,365);
        world_data_covid.(TLC).deaths = zeros(1,365);
        world_data_covid.(TLC).C1_School_closing = zeros(1,365);
        world_data_covid.(TLC).C1_Flag = zeros(1,365);
        world_data_covid.(TLC).C2_Workplace_closing = zeros(1,365);
        world_data_covid.(TLC).C2_Flag = zeros(1,365);
        world_data_covid.(TLC).C3_Cancel_public_events = zeros(1,365);
        world_data_covid.(TLC).C3_Flag = zeros(1,365);
        world_data_covid.(TLC).C4_Restrictions_on_gatherings = zeros(1,365);
        world_data_covid.(TLC).C4_Flag = zeros(1,365);
        world_data_covid.(TLC).C5_Close_public_transport = zeros(1,365);
        world_data_covid.(TLC).C5_Flag = zeros(1,365);
        world_data_covid.(TLC).C6_Stay_at_home_requirements = zeros(1,365);
        world_data_covid.(TLC).C6_Flag = zeros(1,365);
        world_data_covid.(TLC).C7_Restrictions_on_internal_movement = zeros(1,365);
        world_data_covid.(TLC).C7_Flag = zeros(1,365);
        world_data_covid.(TLC).C8_International_travel_controls = zeros(1,365);
        world_data_covid.(TLC).H1_Public_information_campaign = zeros(1,365);
        world_data_covid.(TLC).H1_Flag = zeros(1,365);
        world_data_covid.(TLC).H2_Testing_policy = zeros(1,365);
        world_data_covid.(TLC).H3_Contact_tracing = zeros(1,365);
        world_data_covid.(TLC).H4_Emergency_investment_in_healthcare = zeros(1,365);
        world_data_covid.(TLC).H5_Investment_in_vaccines = zeros(1,365);
        world_data_covid.(TLC).ConfirmedCases = zeros(1,365);
        world_data_covid.(TLC).ConfirmedDeaths = zeros(1,365);
        world_data_covid.(TLC).NewCases = zeros(1,365);
        world_data_covid.(TLC).NewDeaths = zeros(1,365);
        world_data_covid.(TLC).StringencyIndex = zeros(1,365);
        world_data_covid.(TLC).cases_smoothed = zeros(1,365);
        world_data_covid.(TLC).cases_fit_curve = zeros(1,365);
        world_data_covid.(TLC).cases_rmsd = [];
        world_data_covid.(TLC).cases_deviation = [];
        world_data_covid.(TLC).cases_t_half = [];
        world_data_covid.(TLC).cases_t_rise = [];
        world_data_covid.(TLC).cases_rise_10 = [];
        world_data_covid.(TLC).cases_rise_90 = [];
        world_data_covid.(TLC).cases_t_max = [];
        world_data_covid.(TLC).cases_t_fall = [];
        world_data_covid.(TLC).cases_fall_10 = [];
        world_data_covid.(TLC).cases_fall_90 = [];
        world_data_covid.(TLC).deaths_smoothed = zeros(1,365);
        world_data_covid.(TLC).deaths_fit_curve = zeros(1,365);
        world_data_covid.(TLC).deaths_rmsd = [];
        world_data_covid.(TLC).deaths_deviation = [];
        world_data_covid.(TLC).deaths_t_half = [];
        world_data_covid.(TLC).deaths_t_rise = [];
        world_data_covid.(TLC).deaths_rise_10 = [];
        world_data_covid.(TLC).deaths_rise_90 = [];
        world_data_covid.(TLC).deaths_t_max = [];
        world_data_covid.(TLC).deaths_t_fall = [];
        world_data_covid.(TLC).deaths_fall_10 = [];
        world_data_covid.(TLC).deaths_fall_90 = [];
        world_data_covid.(TLC).valid_cases_rise = false;
        world_data_covid.(TLC).valid_cases_fall = false;
        world_data_covid.(TLC).valid_deaths_rise = false;
        world_data_covid.(TLC).valid_deaths_fall = false;
        world_data_covid.(TLC).predictor_cases_rise = false;
        world_data_covid.(TLC).predictor_cases_fall = false;
        world_data_covid.(TLC).predictor_deaths_rise = false;
        world_data_covid.(TLC).predictor_deaths_fall = false;
        world_data_covid.(TLC).continent = '';
        world_data_covid.(TLC).stringency_valid = false;
    end
end
fclose(fid);

world_data_covid = rmfield(world_data_covid,'XXX');

% add populations, data from World Bank API (you can Google)
fid = fopen('API_SP.POP.TOTL_DS2_en_csv_v2_1120881.csv','rt');
fgetl(fid);
nl = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    nl = nl + 1;
    arguments = split(tline,',');
    if length(arguments) < 6
        continue;
    end
    this_TLC = arguments{2};
    indicator_code = arguments{5};
    this_TLC = this_TLC(2:end-1);
    indicator_code = indicator_code(2:end-1);
    if isfield(world_data_covid,this_TLC) && strcmp(indicator_code,'SP.POP.TOTL')
        for k = 6:length(arguments)
            pop = arguments{k};
            pop = str2double(pop(2:end-1));
            if ~isnan(pop) && ~isempty(pop) && pop ~= 0 
                world_data_covid.(this_TLC).population = pop;
            end
        end
    end
end
fclose(fid);

% add missing populations, data from World Bank API or internet
TLCs = fieldnames(world_data_covid);
for k = 1:length(TLCs)
    if isempty(world_data_covid.(TLCs{k}).population) || world_data_covid.(TLCs{k}).population == 0
        world_data_covid.(TLCs{k}).population = read_world_data_population(TLCs{k});
    end
end

% add gross domestic product per capita, data from World Bank API
TLCs = fieldnames(world_data_covid);
for k = 1:length(TLCs)
    world_data_covid.(TLCs{k}).GDP_per_capita = read_world_data_GDP_per_capita(TLCs{k});
end

% Data starts at January 1st (with zeroes)
startdate = datetime('2020-01-01');
highest_date = 0;

% download Oxford stringency index data and extract it
% this is somewhat dangerous, should they change their format, as they
% already did once
websave('OxCGRT_latest.csv','https://github.com/OxCGRT/covid-policy-tracker/raw/master/data/OxCGRT_latest.csv');
fid = fopen('OxCGRT_latest.csv','rt');
fgetl(fid);
nl = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    nl = nl + 1;
    arguments = split(tline,',');
    TLC = arguments{2};
    if isfield(world_data_covid,TLC)
        date = datetime(arguments{3},'InputFormat','yyyyMMdd');
        days = between(startdate,date,'days');
        poi = 1 + caldays(days);
        if poi > highest_date
            highest_date = poi;
        end
        world_data_covid.(TLC).C1_School_closing(poi) = str2double(arguments{4});
        world_data_covid.(TLC).C1_Flag(poi) = str2double(arguments{5});
        world_data_covid.(TLC).C2_Workplace_closing(poi) = str2double(arguments{6});
        world_data_covid.(TLC).C2_Flag(poi) = str2double(arguments{7});
        world_data_covid.(TLC).C3_Cancel_public_events(poi) = str2double(arguments{8});
        world_data_covid.(TLC).C3_Flag(poi) = str2double(arguments{9});
        world_data_covid.(TLC).C4_Restrictions_on_gatherings(poi) = str2double(arguments{10});
        world_data_covid.(TLC).C4_Flag(poi) = str2double(arguments{11});
        world_data_covid.(TLC).C5_Close_public_transport(poi) = str2double(arguments{12});
        world_data_covid.(TLC).C5_Flag(poi) = str2double(arguments{13});
        world_data_covid.(TLC).C6_Stay_at_home_requirements(poi) = str2double(arguments{14});
        world_data_covid.(TLC).C6_Flag(poi) = str2double(arguments{15});
        world_data_covid.(TLC).C7_Restrictions_on_internal_movement(poi) = str2double(arguments{16});
        world_data_covid.(TLC).C7_Flag(poi) = str2double(arguments{17});
        world_data_covid.(TLC).C8_International_travel_controls(poi) = str2double(arguments{18});
        world_data_covid.(TLC).H1_Public_information_campaign(poi) = str2double(arguments{24});
        world_data_covid.(TLC).H1_Flag(poi) = str2double(arguments{25});
        world_data_covid.(TLC).H2_Testing_policy(poi) = str2double(arguments{26});
        world_data_covid.(TLC).H3_Contact_tracing(poi) = str2double(arguments{27});
        world_data_covid.(TLC).H4_Emergency_investment_in_healthcare(poi) = str2double(arguments{28});
        world_data_covid.(TLC).H5_Investment_in_vaccines(poi) = str2double(arguments{29});
        world_data_covid.(TLC).H5_Investment_in_vaccines(poi) = str2double(arguments{29});
        world_data_covid.(TLC).ConfirmedCases(poi) = str2double(arguments{31});
        world_data_covid.(TLC).ConfirmedDeaths(poi) = str2double(arguments{32});
        world_data_covid.(TLC).StringencyIndex(poi) = str2double(arguments{33});
        world_data_covid.(TLC).stringency_valid = true;
    end
end
fclose(fid);

% compute all daily new positive tests and deaths by differentiation of
% cumulated data

for k=1:length(TLCs)
    TLC = TLCs{k};
    world_data_covid.(TLC).NewCases(2:365) = diff(world_data_covid.(TLC).ConfirmedCases);
    world_data_covid.(TLC).NewDeaths(2:365) = diff(world_data_covid.(TLC).ConfirmedDeaths);
    world_data_covid.(TLC).NewCases(world_data_covid.(TLC).NewCases<0) = 0;
    world_data_covid.(TLC).NewDeaths(world_data_covid.(TLC).NewDeaths<0) = 0;
end

% now extract actual data from EU open data, terribly inefficient way of
% doing it, all countries should be read at once, but I already had
% programmed read_world_data_covid19 before
for kc = 1:length(TLCs)
    TLC = TLCs{kc};
    [cases,deaths,~,TLC,continent] = read_world_data_covid19(world_data_covid.(TLC).country);
    world_data_covid.(TLC).EUCases(1:length(cases)) = cases;
    world_data_covid.(TLC).EUDeaths(1:length(deaths)) = deaths;
    world_data_covid.(TLC).continent = continent;
end

% save the data and time stamp
save world_data_covid19 world_data_covid time_stamp
end