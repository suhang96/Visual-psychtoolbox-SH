function MoveSquGrat(window)

% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function presents moving square grating stimulation (full screen).
% [Need to give stimulation sequence to Para_MoveSquBar.StimulationFile in inti_para.m]
% This function runs following on gray background:
% Gray screen w/ DARK TRIGGER(left bottom): Para_Trigger.BeforeTime = 1000 ms
% Start recording:
    % Gray screen w/ BRIGHT TRIGGER(left bottom): Para_Trigger.StimTime = 80 ms
    % Gray screen w/o TRIGGER for baseline: Para_MoveSquBar.Displaydelay = 10000 ms
    % Moving bar with Para_MoveSquBar.Contrast = Para_Monitor.MaximalContrast:
        % Each trial is Para_MoveSquGrat.ISI=10000 ms
            % Static Stimuli (baseline): Para_MoveSquGrat.BaselineTrialTime = 2000 ms;
            % Moving Stimuli: Para_MoveSquGrat.Tmoving=2000 ms;
            % Static Stimuli (for recover): Para_MoveSquGrat.ISI - Para_MoveSquGrat.Tmoving - Para_MoveSquGrat.BaselineTrialTime
% Stimulation progarm can be quit while each stimulation was presented
% Parameters to change:
% Para_MoveSquGrat.StimulationFiles
% Para_MoveSquGrat.FullFlag=1; % the flag of whether using full screen stimulation. 1=full screen, 0=subscreen
% Para_MoveSquGrat.SpatFreqDeg=0.04; % 0.04 cycle/degree
% Para_MoveSquGrat.DutyCycle=20;   % 20 percent of reciprocal of spatial frequency
% Para_MoveSquGrat.TempFreq=2;     % Hz
% Para_MoveSquGrat.Contrast=0.4;
    
    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_Noise Para_RFGrat Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous Para_RFCourse; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 
    
try
    %% Contrast setup
    [contrastpix lums] = gammacorrection(Para_MoveSquGrat.Contrast);
    inc=lums(2)-lums(1);%%%%%%amplitude of sinusoidal function in luminance

    %% Input stimulations from file
    % input stimulation file
    sequence=load([PATHSTR '\Seq_stimuli' Para_MoveSquGrat.StimulationFiles{Para_MoveSquGrat.StimulationFile}]);
	angle=sequence(:,1)-180; % -180, otherwise the direction is opposite
    angle=mod(sequence(:,1), 360);
	NumStim=length(angle);
    
    %% Draw the trigger for the beginning of the recording
    % build triggering square
    trigger_squ(1) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % trigger-bright
    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));
    % frames for triggers
    before_trigger_frames = round(Para_Trigger.BeforeTime/1000*FR); % the number of frames before the trigger  
    trigger_frames = round(Para_Trigger.StimTime/1000*FR); % the number of frames showing the trigger for Para_Trigger.StimTime=80;   

    %% Generate Frames for each trial
    % get frame numbers for each part
    baseline_trial_frames = round(Para_MoveSquGrat.BaselineTrialTime/1000*FR); % the number of frames before the stimulation in each trial
    moving_frames=round(Para_MoveSquGrat.Tmoving/1000*FR); %  frames
    ISI_frames = round(Para_MoveSquGrat.ISI/1000*FR); 
    
    SpatFreqPix = 1/(tand(1/Para_MoveSquGrat.SpatFreqDeg/2)*Distance*2*Winwidth/Dispwidth);  %cycle per pixel  
    BarWidthPix = Para_MoveSquGrat.DutyCycle/(100*SpatFreqPix);  %bar width in pixel
    f=SpatFreqPix*2*pi; 
	a=cosd(angle)*f;
	b=sind(angle)*f;
    
    frames=round(FR/Para_MoveSquGrat.TempFreq);% temporal period, in frames, of the drifting grating
    moving_frame_indices=mod(0:(moving_frames-1),frames) + 1;
    phase=(1:frames)/frames*2*pi;  % grating

    % Full screen or not
    if Para_MoveSquGrat.FullFlag
        [x,y]=meshgrid(1:Winwidth,1:Winheight);
        rectwin=[0 0 Winwidth Winheight];
    else
%       CenterX=round(RF_X*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_width_start);
%       CenterY=round(RF_Y*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_height_start);
        CenterX=round((RF_X)*Para_RFCourse.SquareSize(1));
        CenterY=round((RF_Y)*Para_RFCourse.SquareSize(2));
        patch_size_pixel = round(tand(Para_MoveSquGrat.MaskSize/2)*Distance*2*Winwidth/Dispwidth); % grid size in pixels;
        diameter = round(patch_size_pixel);
        [x,y]=meshgrid(1:diameter,1:diameter);
        rectwin= CenterRectOnPoint([0 0 diameter diameter], CenterX, CenterY);
        mask=((x-diameter/2).^2+(y-diameter/2).^2)<=(diameter*diameter/4);
    end
    
    %% Give priority before 'Flip'
    HideCursor;
    priorityLevel=MaxPriority(window);
	Priority(priorityLevel);

    %% Before recording: Time before trigger
    % Start presentation, but wait Para_Trigger.BeforeTime = 500 ms to start recording/trigger
    for m=1:before_trigger_frames
        Screen('FillRect',window,contrastpix(2)); %gray background 
        Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location); % DARK TRIGGER
        Screen('Flip', window);
    end
        
    %% present TRIGGER to start recording (RECORDING DATA STARTS HERE]
    % 1. Trigger time: Para_Trigger.StimTime=80
    for m=1:trigger_frames 
        Screen('DrawTexture', window, trigger_squ(1),[],Para_Trigger.Location); % BRIGHT TRIGGER
        Screen('Flip', window);
    end
    
    % 2. Present background to get baseline activity recording for
    % Para_MoveSquGrat.Displaydelay = 10000 ms
    tic;
    Screen('FillRect',window,contrastpix(2)); %gray background 
    Screen('Flip', window);
    while toc<Para_MoveSquGrat.Displaydelay/1000
        [mX, mY, buttons] = GetMouse;
        if buttons(2)
           Priority(0); 
           ShowCursor;
           return;
        end        
    end    
    
    % 3. Present Stimulation of each trial  
    for j=1:NumStim
        % draw grating
        tex = [];       
        for k=1:frames
            if Para_MoveSquGrat.FullFlag
                m=mod(a(j)*x+b(j)*y+phase(k),2*pi) <= f*BarWidthPix;
            else
                m=mod(a(j)*x+b(j)*y+phase(k),2*pi) <= f*BarWidthPix.*mask;
            end
            texdata = exp(log((lums(2)+inc*m-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor); % transform luminance to pixel value
            tex(k)=Screen('MakeTexture', window, texdata); % make black-white grating inside mask; gray background
        end
        
        % Baseline activity for each trial
        for i=1:baseline_trial_frames % Para_MoveSquBar.BaselineTrialTime
            Screen('FillRect',window,contrastpix(2)); %gray background 
            Screen('DrawTexture', window, tex(moving_frame_indices(1)), [], rectwin);
            Screen('Flip', window);
        end
        
        for i = 1:moving_frames
            Screen('DrawTexture', window, tex(moving_frame_indices(i)), [], rectwin);
            Screen('Flip', window);
            [X, Y, buttons] = GetMouse;
            if buttons(2)
               Priority(0); 
               ShowCursor;
               return;
            end
        end
        
        for i=(moving_frames+1):(ISI_frames-baseline_trial_frames-moving_frames)
            Screen('DrawTexture', window, tex(moving_frame_indices(moving_frames)), [], rectwin);
            Screen('Flip', window);
        end
    end
    
    Priority(0);
    ShowCursor;
    %PsychSerial('Close',portA); 

catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    Screen('CloseAll');
    Priority(0);
    psychrethrow(psychlasterror);
end 