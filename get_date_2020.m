function myday = get_date_2020(absday)
% Computes date in 2020 from number of the day
% absday is rounded to the next integer
%
% G. Jeschke, 11.07.2020

last_day_2019 = datetime('31.12.2019','InputFormat','dd.MM.yyyy');

myday = char(last_day_2019 + caldays(round(absday)));