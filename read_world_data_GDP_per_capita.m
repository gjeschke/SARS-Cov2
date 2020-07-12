function GDP_per_capita = read_world_data_GDP_per_capita(TLC)
% https://data.worldbank.org/indicator/NY.GDP.PCAP.CD
% for Taiwan, data from another source is inserted

GDP_per_capita = [];


% Taiwan is missing in this data set and sometimes has a seven-letter
% three-letter code
if strcmpi(TLC,'CNG1925')
    GDP_per_capita = 605e9/23574274;
end
% Taiwan is missing in this data set
if strcmpi(TLC,'TWN')
    GDP_per_capita = 605e9/23574274;
end



fid = fopen('API_NY.GDP.PCAP.CD_DS2_en_csv_v2_1210407.csv','rt');
fgetl(fid);
nl = 0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    nl = nl + 1;
%     [date,rem] = strtok(tline,',');
%     [time,rem] = strtok(rem,',');
%     [canton,rem] = strtok(rem,',');
%     [number,rem] = strtok(rem',');
%     ncumul_tested = str2doubble(number);
    arguments = split(tline,',');
    if length(arguments) < 6
        continue;
    end
    this_TLC = arguments{2};
    indicator_code = arguments{4};
    this_TLC = this_TLC(2:end-1);
    indicator_code = indicator_code(2:end-1);
    if strcmp(this_TLC,TLC) && strcmp(indicator_code,'NY.GDP.PCAP.CD')
        for k = 5:length(arguments)
            pop = arguments{k};
            pop = str2double(pop(2:end-1));
            if ~isnan(pop) && ~isempty(pop)
                GDP_per_capita = pop;
            end
        end
    end
end
fclose(fid);
