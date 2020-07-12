function [rmsd,fit_curve,param,smoothed,full_curve,full_rise,full_decay] = full_fit_covid19_cumulative(taxis,data,options,generalized_logistic,stretched_exponential)
% fits the logistic-exponential model to an epidemic curve
% applicable to a single Covid-19 wave, unless data have been doctored, as test data after a certain time uusually have been

% default smoothing filter is a moving average over one week
if ~exist('options','var') || ~isfield(options,'filter') || isempty(options.filter)
    options.filter = ones(1,7);
end

% legacy moving average
smoothed = zeros(1,length(data));
for k = 7:length(data)
    smoothed(k) = sum(data(k-length(options.filter)+1:k).*options.filter)/sum(options.filter);
end
flenh = length(options.filter)/2; 
smoothed = interp1(taxis(1)+flenh-1:1:length(data)+taxis(1)-flenh-1,smoothed(length(options.filter):length(data)),taxis,'pchip',0);

% initialize parameter vector
v = zeros(1,4);
% split time, time that separates rising and decaying side
% starting value is maximum of smoothed data
[amp,mapoi] = max(smoothed);
v(2) = taxis(mapoi);
% half-time of rise
[~,hpoi] = min(abs(smoothed(1:mapoi)-amp/2));
v(1) = taxis(hpoi);
% rise time estimate
v(3) = (v(2)-v(1))/2;
% decay time estimate
[~,dpoi] = min(abs(smoothed(mapoi+1:end)-exp(-1)*amp));
v(4) = taxis(mapoi+dpoi)-taxis(mapoi);
v = v(1:4);

% the function can fit a generalized logistic function and a stretched
% exponential decay, but this never improved fits significantly
if exist('generalized_logistic','var') && generalized_logistic
    v = [v 1];
end

if exist('stretched_exponential','var') && stretched_exponential
    v = [v 1];
end

% fit parameters by rmsd minimization
[v,rmsd] = fminsearch(@rmsd_covid_time_course_cumulative,v,[],taxis,data);
% compute the fitted curves
[fit_curve,sc,full_curve,full_rise,full_decay] = fit_covid_time_course_cumulative(v,taxis,data);

% report parameters back in a nicer format
param.t_half = v(1);
param.t_max = v(2);
param.t_rise = v(3);
param.t_fall = v(4);
param.sc = sc;
