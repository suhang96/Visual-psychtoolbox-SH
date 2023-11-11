% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function runs following:
% FitGamma.
%
% Shows how function FitGamma may be used to fit various functions through measured gamma data.
% We typically call FitGamma in scripts that perform calibrations to generate a full gamma table.
%
% NOTE: FitGamma uses the MATLAB optimization toolbox.
%
% NOTE: FitGamma is now a little obsolete, as we typically call it through
% the function CalibrateFitGamma. That function has more fit options, but
% is also more tied to our calibration structure.  
%
% Also see RefitCalGamma, CalibrateFitGamma, FitGamma.
%
% 8/7/00  dhb  Wrote it.
% 3/5/05  dhb  A few more tests.
% 6/5/10  dhb  Made sure this still runs OK.  A few small tweaks.

% Clear
clear; close all

% Note that FitGamma assumes that a measurement
% was made of the output for maximum device
% input (255 in this case).  The measurements
% are also assumed to be dark subtracted, so
% that the output for input 0 is zero by
% definition.  Correction for ambient (flare)
% is handled separately from gamma correction
% in our code.
MonitorA_measure = xlsread('gammaMeasure_SH_monitorA.xlsx');
MonitorA_GammaInput = MonitorA_measure(:,1)/255;
% MonitorA_GammaInput_origin = MonitorA_measure(:,1);
MonitorA_GammaData = MonitorA_measure(:,2)/MonitorA_measure(end,2);

% Plot the data
figure; clf; hold on
plot(MonitorA_GammaInput,MonitorA_GammaData,'+');

% Fit simple gamma power function
output = linspace(0,1,length(MonitorA_GammaInput))';
[simpleFit,simpleX] = FitGamma(MonitorA_GammaInput,MonitorA_GammaData,output,1);
plot(output,simpleFit,'r');
fprintf(1,'Found exponent %g\n\n',simpleX(1));
% Luminance = 0.0077 + (MonitorA_GammaInput_origin./256.*1).^1.96738;
% Fit extended gamma power function.
% Here the fit is the same as for the simple function.
% 
[extendedFit,extendedX] = FitGamma(MonitorA_GammaInput,MonitorA_GammaData,output,2);
plot(output,extendedFit,'g'); 
fprintf(1,'Found exponent %g, offset %g\n\n',extendedX(1),extendedX(2));
% By passing other values of fitType (last arg to FitGamma), you can
% fit other parametric forms or spline the data.  See "help FitGamma"
% for information.  FitGamma can also be called with fitType set to
% zero to cause it to fit all of its forms and let you know which
% one produces the lowest fit error.
% Plot the data
% figure; clf; hold on
% plot(MonitorA_GammaInput,MonitorA_GammaData,'+');
% for i = 1:7
%     theFit(:,i) = FitGamma(MonitorA_GammaInput,MonitorA_GammaData,output,i); %#ok<SAGROW>
% end
% plot(output,theFit,'.','MarkerSize',2);
% fprintf('\n');
% theFit0 = FitGamma(MonitorA_GammaInput,MonitorA_GammaData,output,0);
% plot(output,theFit0);
% 
% For grins, we can use the parameters from the extended fit to
% invert the gamma function.  The inversion isn't perfect,
% particularly at the low end.  This is because the fit isn't
% perfect there.  Because the gamma function is so flat, a
% small error in fit is amplified on the inversion, when
% the inversion is examined in the input space.  On the
% other hand, the same flatness means that the actual display
% error resulting from the inversion error is small.
%
% Analytial inverse functions are not currently implemented
% for other parametric fits.  Typically we do the inversion
% by inverse table lookup in the actual calibration routines.
    % maxInput = max(MonitorA_GammaInput);
    % invertedInput = InvertGammaExtP(extendedFit,maxInput,MonitorA_GammaData);
    % figure; clf; hold on
    % plot(MonitorA_GammaInput,invertedInput,'r+');
    % axis('square');
    % axis([0 maxInput 0 maxInput]);
    % plot([0 maxInput],[0 maxInput],'r');

% Under OS 9, we had a function CopyText that would copy a matrix to
% the clipboard.  That went away in OS/X, but I left the code here
% just to document what the interesting variables are.
% CopyText([typicalGammaInput,typicalGammaData]);
% CopyText([output,extendedFit]);
figure;hold on
plot(MonitorA_measure(:,1),0.3121+7.4030e-04.*(MonitorA_measure(:,1)).^1.96738,'b');
plot(MonitorA_measure(:,1),MonitorA_measure(:,2),'+');
