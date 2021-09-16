function [fitresult, gof, coeffs, xcoh1] = expoFit(dat)
%  Create a fit with eq:  a*x^b+c
%
%  Data for 'untitled fit 1' fit:
%      X Input : xdat
%      Y Output: dat
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
% Coefficients:
%  (1)  a = slope
%  (2)  b = "bend" (i.e. exp increasing or decreasing)
%  (3)  c = Y-intercept

%% if isnan

if isnan(dat)
    fitresult = NaN;
    gof = NaN;
    coeffs = NaN;
    xcoh1 = NaN;
elseif length(dat) == 1
    fitresult = NaN;
    gof = NaN;
    coeffs = NaN;
    xcoh1 = NaN;
else
%% Remove NaNs
dat = dat(~isnan(dat));

if length(dat) < 3
    fitresult = NaN;
    gof = NaN;
    coeffs = NaN;
    xcoh1 = NaN;
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
xdat = 1:length(dat);

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData(xdat, dat);

% Set up fittype and options.
ft = fittype( 'power2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.104559210420619 0.761444168670496 -0.0039368783835652];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Save coefficients
coeffs = coeffvalues(fitresult);

% Plot fit with data.
% fig = figure( 'Name', 'ExpoFit' );
% h = plot( fitresult, xData, yData );
% legend( h, 'dat vs. xdat', 'ExpoFit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'xdat', 'Interpreter', 'none' );
% ylabel( 'dat', 'Interpreter', 'none' );
% grid on
% close(fig)
%% At what # of MU pairs does coh = 1 based on this eq?
a = coeffs(1);
b = coeffs(2);
c = coeffs(3);

y = 1;
temp = (y-c)/a;
    if temp < 0
        xcoh1 = NaN;
    else
        xcoh1 = nthroot(temp,b);
    end
end
end
end
