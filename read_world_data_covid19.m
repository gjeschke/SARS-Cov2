function [cases,deaths,dates,TLC,continent] = read_world_data_covid19(country)
% https://data.europa.eu/euodp/de/data/dataset/covid-19-coronavirus-data/resource/260bbbde-2316-40eb-aec3-7cd7bfc2f590
% very pedestrian reader of the Covid-19 data for one country from the EU Open data file
%
% country   is their way of writing the country name

startdate = datetime('01/01/2020','InputFormat','dd/MM/yyyy');
cases = zeros(1,365);
deaths = zeros(1,365);
dates = cell(1,365);


fid = fopen('world_data_covid19.csv','rt');
fgetl(fid);
nl = 0;
mapoi = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    nl = nl + 1;
    arguments = split(tline,',');
    this_country = arguments{7};
    if strcmpi(this_country,country)
        TLC = arguments{9};
        continent = arguments{11};
        date = datetime(arguments{1},'InputFormat','dd/MM/yyyy');
        days = between(startdate,date,'days');
        poi = 1 + caldays(days);
        if poi > 0
            dates{poi} = date;
            cases(poi) = str2double(arguments{5});
            deaths(poi) = str2double(arguments{6});
            if poi > mapoi
                mapoi = poi;
            end
        end
    end
end
fclose(fid);
cases = cases(1:mapoi);
deaths = deaths(1:mapoi);
dates = dates(1:mapoi);
cases(cases<0) = 0;
deaths(deaths<0) = 0;