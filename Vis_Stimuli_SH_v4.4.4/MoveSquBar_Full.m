function MoveSquBar(window)

% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function presents moving bar stimulation (full screen ONLY).
% [Need to give stimulation sequence to Para_MoveSquBar.StimulationFile in inti_para.m]
% This function runs following:
% Gray screen w/ DARK TRIGGER(left bottom): Para_Trigger.BeforeTime = 1000 ms
% Start recording:
    % Gray screen w/ BRIGHT TRIGGER(left bottom): Para_Trigger.StimTime = 80 ms
    % Gray screen w/o TRIGGER for baseline: Para_MoveSquBar.Displaydelay = 10000 ms
    % Moving bar with Para_MoveSquBar.Contrast = Para_Monitor.MaximalContrast:
        % Each trial is Para_MoveSquBar.ISI 
            % Gray screen (for baseline): Para_MoveSquBar.BaselineTrialTime = 5000 ms;
            % Each stimulation takes (moving_distance_pixel/speed_pixel) time:
                % trial dependent: ~20.7247s for intrinsic 0/180 degrees;
                % ~11.8812s for intrinsic 90/270 degrees
            % Gray screen (for recover): Para_MoveSquBar.ISI - Para_MoveSquBar.BaselineTrialTime - (moving_distance_pixel/speed_pixel)
% Stimulation progarm can be quit while each stimulation was presented
% Intrinsic imaging [Keller et al. 2020] 
    % To estimate the visual area locations and their 
    % retinotopic maps using intrinsic imaging, we presented a narrow white bar
    % (5°) on a black background, slowly drifting (10° per second) in one of
    % the cardinal directions (10 to 20 trials per direction). In addition, we
    % presented 25° patches of gratings at different retinotopic locations
    % (usually one nasal and one temporal, 20 trials each). Gratings were
    % presented for 2 s at 8 different directions (0.25 s each) followed by
    % 13 s of grey screen.

    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_Noise Para_RFGrat Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous Para_RFCourse; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 
try
    %% Contrast setup
    %[contrastpix lums] = gammacorrection(Para_MoveSquBar.Contrast);
    
    %background = contrastpix(3-Para_MoveSquBar.Background); % black or grey background
    % define what background
    if Para_MoveSquBar.Background
        background = Para_Monitor.MeanPixel; % grey background when Para_MoveSquBar.Background = 1;
        background_lum = Para_Monitor.Meanlum;
        bar_lum_bright = (1+Para_MoveSquBar.Contrast)*background_lum;
        bar_pixel_value_bright = exp(log((bar_lum_bright-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor);
        bar_lum_dark = (1-Para_MoveSquBar.Contrast)*background_lum;
        bar_pixel_value_dark = exp(log((bar_lum_dark-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor);
    else 
        background = 0; % black background when Para_MoveSquBar.Background = 0;
        background_lum = Para_Monitor.BaseFactor;
        bar_pixel_value_bright = 255;
        bar_pixel_value_dark = 0;
    end 
    % bar contrast is defined as Weber contrast
    % Weber contrast is defined as (Ifeature-Ibackground)/Ibackground
    % representing the luminance of the features and the background, respectively. 
    % The measure is also referred to as Weber fraction, since it is the term that 
    % is constant in Weber's Law. Weber contrast is commonly used in cases 
    % where small features are present on a large uniform background, i.e., 
    % where the average luminance is approximately equal to the background luminance.

    
    %% Input stimulations from file
    % input stimulation file
    sequence=load([PATHSTR '\Seq_stimuli' Para_MoveSquBar.StimulationFiles{Para_MoveSquBar.StimulationFile}]);
    angle=sequence(:,1);
    angle=mod(angle, 360);
    NumStim=length(angle);
    
    %% Draw the trigger for the beginning of the recording
    % build triggering square
    trigger_squ(1) =  Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % trigger-bright
    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));

    %% Generate Frames for each trial
    % Draw bar length, width and moving speed with different angles for each trail
    bar_length_pixel=round(abs(Winheight*cosd(angle))+abs(Winwidth*sind(angle)));  % bar length in pixel  
    bar_width_pixel=round(tand(Para_MoveSquBar.WidthDeg/2)*Distance*2*Winwidth/Dispwidth);    % bar width in pixel
    moving_distance_pixel=round(abs(Winheight*sind(angle))+abs(Winwidth*cosd(angle)))+bar_width_pixel; % moving distance in pixel
    speed_pixel=tand(Para_MoveSquBar.Speed/2)*Distance*2*Winwidth/Dispwidth;   % moving speed in pixel/s
    pixel_per_frame=speed_pixel/FR;    % travelling distance in pixel for each frame

    % get frame numbers for each part
    stim_frames=round(moving_distance_pixel/speed_pixel*FR); % the number of frames for each stimulation

    % get moving pixels/frame in x/y direction with angles
    mx=pixel_per_frame*cosd(angle);
    my=pixel_per_frame*sind(angle);    
    
    % generate movement for each trials
    origin=[]; % the coordinates of starting position of bar center in pixel
    for i=1:NumStim
        dx=bar_width_pixel*cosd(angle(i))/2; % the x of bar width in pixel
        dy=bar_width_pixel*sind(angle(i))/2; % the y of bar width in pixel
        switch floor(angle(i)/90)  % [NEED TO UNDERSTAND LATER]
            case 0
                temp=(Winwidth*sind(angle(i))-Winheight*cosd(angle(i)))/2;
                origin=[origin; [temp*sind(angle(i))-dx -1*temp*cosd(angle(i))-dy]];
            case 1
                temp=(Winheight*cosd(angle(i))+Winwidth*sind(angle(i)))/2;
                origin=[origin; [Winwidth-temp*sind(angle(i))-dx temp*cosd(angle(i))-dy]];
            case 2
                temp=(Winheight*cosd(angle(i))-Winwidth*sind(angle(i)))/2;
                origin=[origin; [Winwidth+temp*sind(angle(i))-dx Winheight-temp*cosd(angle(i))-dy]];
            case 3
                temp=(Winheight*cosd(angle(i))+Winwidth*sind(angle(i)))/2;
                origin=[origin; [temp*sind(angle(i))-dx Winheight-temp*cosd(angle(i))-dy]];
        end
    end
    origin=round(origin);
    
    %% Give priority before 'Flip'
    HideCursor;
    priorityLevel=MaxPriority(window);
	Priority(priorityLevel);
    
    %% Before recording: Time before trigger
    % Start presentation, but wait Para_Trigger.BeforeTime = 500 ms to start recording/trigger
    tic;
    Screen('FillRect',window,background); 
    Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location); % DARK TRIGGER
    Screen('Flip', window);
    while toc<Para_Trigger.BeforeTime/1000
        [mX, mY, buttons] = GetMouse;
        if buttons(2)
           Priority(0); 
           ShowCursor;
           return;
        end        
    end    
        
    %% present TRIGGER to start recording (RECORDING DATA STARTS HERE]
    % 1. Trigger time: Para_Trigger.StimTime=80
    tic;
    Screen('DrawTexture', window, trigger_squ(1),[],Para_Trigger.Location); % BRIGHT TRIGGER
    Screen('Flip', window);
    while toc<Para_Trigger.StimTime/1000
        [mX, mY, buttons] = GetMouse;
        if buttons(2)
           Priority(0); 
           ShowCursor;
           return;
        end        
    end    
    
    % 2. Present background to get baseline activity recording for
    % Para_MoveSquBar.Displaydelay = 10000 ms
    tic;
    Screen('FillRect',window,background); %gray background 
    Screen('Flip', window);
    while toc<Para_MoveSquBar.Displaydelay/1000
        [mX, mY, buttons] = GetMouse;
        if buttons(2)
           Priority(0); 
           ShowCursor;
           return;
        end        
    end
  
    % 3. Present Stimulation of each trial  
    for i=1:NumStim
        % (1) Baseline activity for each trial
        tic;
        Screen('FillRect',window,background);
        Screen('Flip', window);
        % bright or dark
        if Para_MoveSquBar.ContrastFlag 
            barframe=Screen('MakeTexture', window, bar_pixel_value_bright+zeros(bar_length_pixel(i), bar_width_pixel));
        else
            barframe=Screen('MakeTexture', window, bar_pixel_value_dark+zeros(bar_length_pixel(i), bar_width_pixel));
        end
        barRect=[0 0 bar_width_pixel bar_length_pixel(i)];
        while toc<Para_MoveSquBar.BaselineTrialTime/1000
            [mX, mY, buttons] = GetMouse;
            if buttons(2)
               Priority(0); 
               ShowCursor;
               return;
            end        
        end
        
        % (2) Moving Stimuli
        tic;
        for j=1:stim_frames
            Screen('DrawTexture', window, barframe, barRect, CenterRectOnPoint(barRect, origin(i,1)+mx(i)*(j-1), origin(i,2)+my(i)*(j-1)),angle(i));
            Screen('Flip', window);
            [X, Y, buttons] = GetMouse;
            if buttons(2)
               Priority(0); 
               ShowCursor;
               return;
            end
        end
        moving_time_MvSquBar(i) = toc;
        
        % (3) Recovery of baseline for each trial with static stimuli
        tic;
        Screen('FillRect',window,background);
        Screen('Flip', window);
        while toc<((Para_MoveSquBar.ISI-Para_MoveSquBar.BaselineTrialTime)/1000 - moving_time_MvSquBar(i))
            [mX, mY, buttons] = GetMouse;
            if buttons(2)
               Priority(0); 
               ShowCursor;
               return;
            end
        end
    end
    moving_time_MvSquBar % print moving time
    Priority(0); 
    ShowCursor;
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    Screen('CloseAll');
    Priority(0);
    psychrethrow(psychlasterror);
end %try..catch..