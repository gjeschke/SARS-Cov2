function [fit_curve,sc,full_curve,full_rise,full_decay] = fit_covid_time_course_cumulative(v,taxis,data)
% [fit_curve,sc,full_curve,full_rise,full_decay] = fit_covid_time_course_cumulative(v,taxis,data)
%
% the model consists of a sigmoidal rising branch (generalized logistic
% function) and a stretched exponential decay
%
% v     parameter vector
%       v(1)    half-time of rising branch relative to taxis
%       v(2)    split-time between branches at maximum, relative to taxis
%       v(3)    time constant of rise
%       v(4)    time constant of decay
%       v(5)    exponent alpha of generalized logistic function, default: 1
%       v(6)    stretch exponent of stretched exponential fct, default: 1
% taxis time axis
% data  real-world data relative to taxis
%
% fit_curve     best fit model, given parameters v
%
% G. Jeschke, 4.6.2020

% set default stretch exponents
if length(v) < 5
    v = [v 1 1];
end

if length(v) < 6
    v = [v 1];
end

full_axis = 1:366; % 2020 has 366 days

% normalized argument
x = (taxis-v(1))/v(3);
full_x = (full_axis-v(1))/v(3);
rise = (1+exp(-x)).^(-v(5));
full_rise = (1+exp(-full_x)).^(-v(5));
full_decay = [];

[~,split_poi] = min(abs(taxis-v(2)));

if split_poi < length(taxis) % unles pure rise case
    x = (taxis(split_poi+1:end)-v(2))/v(4);
    decay = exp(-(x.^v(6)));
    full_x = (full_axis(split_poi+1:end)-v(2))/v(4);
    full_decay = exp(-(full_x.^v(6)));
    shift = 0;
    while 1+shift < length(decay) && abs(decay(1+shift+1)-rise(split_poi+shift+1)) < abs(decay(1+shift)-rise(split_poi+shift))
        shift = shift + 1;
    end
    raw_curve = [rise(1:split_poi+shift) decay(1+shift:end)];
    full_raw_curve = [full_rise(1:split_poi+shift) full_decay(1+shift:end)];
    full_decay(1:1+shift) = 0;
else % pure rise case
    raw_curve = rise;
    full_raw_curve = full_rise;
end

% minimum mean square deviation amplitude scaling, analytical expression
sc = sum(cumsum(raw_curve).*cumsum(data(1:length(raw_curve))))/sum(cumsum(raw_curve).^2);
fit_curve = sc*raw_curve;
full_curve = sc*full_raw_curve;
full_rise = sc*full_rise;
full_decay = sc*full_decay;

