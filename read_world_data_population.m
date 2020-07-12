function population = read_world_data_population(TLC)
% https://data.worldbank.org/indicator/SP.POP.TOTL
% for some countries that they don't list, this function has Wikipedia data

population = [];

% South Korea is missing in this data set
if strcmpi(TLC,'KOR')
    population = 51709098;
end
% Taiwan is missing in this data set
if strcmpi(TLC,'CNG1925')
    population = 23574274;
end
% Taiwan is missing in this data set
if strcmpi(TLC,'TWN')
    population = 23574274;
end
% Iran is missing in this data set
if strcmpi(TLC,'IRN')
    population = 83183741;
end

% Bahamas are missing in this data set
if strcmpi(TLC,'BHS')
    population = 385637; % data from Wikipedia
    return
end
% Congo is missing in this data set
if strcmpi(TLC,'COG')
    population = 5244359; % data from Wikipedia
    return
end
% Democratic Republic of the Congo is missing in this data set
if strcmpi(TLC,'COD')
    population = 101780263; % data from Wikipedia
    return
end
% Egypt is missing in this data set
if strcmpi(TLC,'EGY')
    population = 100075480; % data from Wikipedia
    return
end
% Gambia is missing in this data set
if strcmpi(TLC,'GMB')
    population = 2173999; % data from Wikipedia
    return
end
% Guernsey is missing in this data set
if strcmpi(TLC,'GGY')
    population = 62792; % data from Wikipedia
    return
end
% Jersey is missing in this data set
if strcmpi(TLC,'JEY')
    population = 107800; % data from Wikipedia
    return
end
% Montserrat is missing in this data set
if strcmpi(TLC,'MSF')
    population = 4649; % data from Wikipedia
    return
end
% Taiwan is missing in this data set
if strcmpi(TLC,'TWN')
    population = 23574274; % data from Wikipedia
    return
end
% Venezuela is missing in this data set
if strcmpi(TLC,'VEN')
    population = 28887118; % data from Wikipedia
    return
end
% West Sahara is missing in this data set
if strcmpi(TLC,'ESH')
    population = 567402; % data from Wikipedia
    return
end
% Yemen is missing in this data set
if strcmpi(TLC,'YEM')
    population = 28498683; % data from Wikipedia
    return
end

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
    if strcmp(this_TLC,TLC) && strcmp(indicator_code,'SP.POP.TOTL')
        for k = 6:length(arguments)
            pop = arguments{k};
            pop = str2double(pop(2:end-1));
            if ~isnan(pop) && ~isempty(pop)
                population = pop;
            end
        end
    end
end
fclose(fid);
