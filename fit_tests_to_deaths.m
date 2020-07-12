function [conv_tests,rmsd,shift,width,sc] = fit_tests_to_deaths(tests,deaths,last_day)
% fits curve of positive test curve to death curve by convolution of the
% former with a shifted Gaussian
%
% G. Jeschke, 2020

v0 = [11,2]; % default starting values, 11 days shift, 2 days std. dev.

% root mean square minimization of the cumulated data, see below
[v,rmsd] = fminsearch(@rmsd_convoluted_to_cumulative,v0,[],tests,deaths(1:last_day));

% compute the convolution with the fitted parameters
conv_tests = convolute_cases(tests,v(1),v(2));

cum_tests = cumsum(conv_tests(1:last_day));
cum_deaths = cumsum(deaths(1:last_day));

% compute vertical scaling
sc = sum(cum_deaths.*cum_tests)/sum(cum_tests.^2);
conv_tests = sc*conv_tests;

% report back the paraemeters with interpretable names
shift = v(1);
width = v(2);

function rmsd = rmsd_convoluted_to_cumulative(v,tests,deaths)

% reject negative shifts, not an elegant way, but avoids using the
% optimization toolbox
if v(1) < 0
    rmsd = 1e6;
    return
end

% do the convolution
conv_tests = convolute_cases(tests,v(1),v(2));

% cumulated curves
cum_tests = cumsum(conv_tests(1:length(deaths)));
cum_deaths = cumsum(deaths);

% vertical scaling, this is an analytical minimum rmsd expression
sc = sum(cum_deaths.*cum_tests)/sum(cum_tests.^2);

% report back normalized root mean square error
rmsd = sqrt(sum(cum_deaths-sc*cum_tests).^2/cum_deaths(end));
