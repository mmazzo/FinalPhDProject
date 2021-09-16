function [fitresult, gof, coeffs, pseudoA] = expodecayFit(dat)
%CREATEFIT(DAT)
%  Create a decaying exponential fit:  y = a*x^b+c
%
%  Data:
%      Y Output: dat
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%% If isnan
if isnan(dat)
    fitresult = NaN;
    gof = NaN;
    coeffs = NaN;
    pseudoA = NaN;
elseif length(dat) == 1
    fitresult = NaN;
    gof = NaN;
    coeffs = NaN;
    pseudoA = NaN;
else

%% Remove NaNs
dat = dat(~isnan(dat));

if length(dat) < 3
    fitresult = NaN;
    gof = NaN;
    coeffs = NaN;
    pseudoA = NaN;
else
%% Check for outlier points at end of data set
diffs = diff(dat);

if abs(diffs(end)) > 1
    if abs(diffs(end-1)) < 1
        if abs(diffs(end-2)) < 1
            dat = dat(1:end-1);
        end
    end
end

%% Create x vector
xdat = 2:length(dat)+1;

%% Fit: Exponential decay
[xData, yData] = prepareCurveData(xdat, dat);

% Set up fittype and options.
ft = fittype( 'power2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [132.017584800342 -0.351447188884657 -0.816513622725634];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );


% Save coefficients
coeffs = coeffvalues(fitresult);

% Plot fit with data.
% fig = figure( 'Name', 'Expo. Decay Fit' );
% h = plot( fitresult, xData, yData );
% legend( h, 'dat', 'Expo. Decay Fit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% ylabel( 'dat', 'Interpreter', 'none' );
% grid on
% close(fig)
%% Find the point at which the change in % variance explained with 
%  an additional MU added to the analysis is < 0.1
a = coeffs(1);
b = coeffs(2);
c = coeffs(3);

for x = 1:500
    y(x) = a*(x^b)+c;
end

pseudoA = find(diff(y) > -0.1,1,'first');
end
end
end
