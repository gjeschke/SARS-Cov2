function conv_cases = convolute_cases(cases,shift,width)
% Convolutes time course of cases with a Gaussian
%
% G. Jeschke, 2020

% Matlab convolution approximately doubles data length to do it right
time = -length(cases):length(cases);
% Gaussian function, not normalized
Gauss = exp(-(time-shift).^2/(2*width^2));
% normalize numerically
Gauss = Gauss/sum(Gauss);
% do the convolution
conv_cases = conv(cases,Gauss);
% extract only positive time data
conv_cases = conv_cases(length(cases)+1:2*length(cases));

