function rmsd = rmsd_covid_time_course_cumulative(v,taxis,data)

% compute the fit curve for the supplied parameters
fit_curve = fit_covid_time_course_cumulative(v,taxis,data);

% compute root mean square deviation
rmsd = sqrt(sum((cumsum(fit_curve)-cumsum(data(1:length(fit_curve)))).^2));
