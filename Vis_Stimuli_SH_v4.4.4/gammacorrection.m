function [pixels lums]=gammacorrection(contrast)

% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function runs following:
% input contrast value for sinusoid grating, output corresponding luminance
% and pixel value:
%     pixels = round([pixel_max,pixel_mean,pixel_min]);
%     lums = [Imin meanlum Imax];
    % Use formula of Michelson contrast:
    % (also known as the visibility) is commonly used for
    % patterns where both bright and dark features are equivalent and take up 
    % similar fractions of the area (e.g. sine-wave gratings). 
    % The Michelson contrast is defined as (Imax-Imin)/(Imax+Imin), I is
    % luminance.

        % Imax+Imin = 2 * meanlum
        % Imax - Imin = 2 * meanlum * contrast
        % Imin = meanlum * (1-contrast)
        % Imax = 2 * meanlum - Imin = meanlum * (1+contrast)

    % input the real measured luminance-pixel chart
    % For monitor A, use 8% brightness for mean 20 cd/m^2 with 15cm distance.
    % Check the luminance chart to get accurate pixel for specific contrasts 
    % Fitting with simple power function
    % Exponent for device 1 is 1.96738
    % Simple power function fit, RMSE: 0.0146421
    % Fitting with extended power function
    % Extended power function fit, RMSE: 0.0146421
    % Found exponent 1.96738, offset 0
    % Luminance_max = 40.49 @ 255
    % Luminance_min = Para_Monitor.BaseFactor = 0.3121 @ 0
    % Para_Monitor.AmpFactor = 7.4030e-04;
    % Para_Monitor.GammaFactor = 1.96738;
    % pixel_value = exp(log((luminance-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor)
    % luminance = Para_Monitor.BaseFactor + Para_Monitor.AmpFactor * (pixel_value)^Para_Monitor.GammaFactor

    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_Noise Para_RFGrat Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 
    

    meanlum = Para_Monitor.Meanlum;
    % luminance for contrasts
    Imin = meanlum * (1-contrast);
    Imax = meanlum * (1+contrast);
    lums = [Imin meanlum Imax];
    % pixel value for conra
    pixel_max = exp(log((Imax-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor);
    pixel_mean = exp(log((meanlum-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor);
    if Imin == Para_Monitor.BaseFactor
        pixel_min = 0;
    else
        pixel_min = exp(log((meanlum-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor);
    end
    pixels = round([pixel_max,pixel_mean,pixel_min]);

%         % bk=115;
%         % x = 2.95+3e-5*bk^2.13;
%         % y=3.936*4-3*x;
%         % wk=exp(log((y-2.95)/3e-5)/2.13)
%         %contrast = luminance difference/mean luminance = (stimulus luminance-background luminance)/background luminance
%         % pix=132;
%         % black=2.95;
%         % lum=black+3e-5*pix^2.13;
%         % contrast = (background-black)/background;
%         % background = black/(1-contrast);
%         ctrmax = 0.4;
%         if contrast > ctrmax
%             contrast = ctrmax ; % the highest contrast which can be achieved is 0.25 if we keep the background at this level.
%             disp('reset the contrast to the max value');
%         end
%         baselum = 2.95;
%         meanlum = baselum/(1-ctrmax); %this mean luminance is derived from contrast of 0.25 based on the minimal luminance.
%         lowlum = meanlum*(1-contrast);
%         highlum = meanlum*2-lowlum;
%         lums = [lowlum meanlum highlum]; % low to high
%         if lowlum == baselum
%             lowpix = 0;
%         else
%             lowpix = exp(log((lowlum-baselum)/3e-5)/2.13);
%         end
%         meanpix = exp(log((meanlum-baselum)/3e-5)/2.13);
%         highpix = exp(log((highlum-baselum)/3e-5)/2.13);
%         pixels = round([highpix meanpix lowpix]); % high to low
%         %  
%         % To determine the maximal contrast:
%         % baselum = 2.95;
%         % maxpix = 255;
%         % maxlum = 2.95+3e-5*maxpix^2.13;
%         % maxcontrast = (maxlum-baselum)/(maxlum+baselum);
%         % meanlum = (baselum+maxlum)/2;
%         % meanpix = exp(log((meanlum-baselum)/3e-5)/2.13);
%         % It turns out that the maxcontrast = 0.40459;
%         % and meanpix = 184.1669;
% 
%         %  test: Weber contrast: c=(I-Ib)/Ib; maxcontrast=  1.3590;
%         % bklum = 2.95;
%         % highlum = (contrast*bklum)+bklum;
%         % highpix = exp(log((highlum-bklum)/3e-5)/2.13);
%         % pixels = [highpix 0 0];
%     end