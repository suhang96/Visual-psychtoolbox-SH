
function ReceptiveFieldMapping_2p1dir(window)
% The direction index is a bit confusing
% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function runs following:
% Gray screen w/ DARK TRIGGER(left bottom): Para_Trigger.BeforeTime = 1000 ms
% Start recording:
    % Gray screen w/ BRIGHT TRIGGER(left bottom): Para_Trigger.StimTime = 80 ms
    % Gray screen w/o TRIGGER for baseline: Para_RFGrat.Displaydelay=10000 ms
    % Receptive field 13*8 with Para_RFGrat.Contrast = Para_Monitor.MaximalContrast:
        % Each stimulation block is composed of 104 trials / position, 
        % [canceled] There is Para_RFGrat.interrep = 0 ms in between stimulation blocks.
        %
        % Each trial is Para_RFGrat.ISI = 4000 ms.
            % Gray screen (for baseline): Para_RFGrat.BaselineTrialTime = 1000 ms;
            % Each stimulation - patch on grey screen(includes 1 cardinal orientation) is Para_RFGrat.StimTime = 2000 ms; 
            % Gray screen (for recover): Para_RFGrat.ISI - Para_RFGrat.BaselineTrialTime - Para_RFGrat.StimTime = 1000 ms.
% Stimulation progarm can be quit with mouse(2).

% Receptive field mapping. Stimuli consisted of either a 20° circular
% grating patch on a grey screen (classical stimulus) or a 20° grey circular
% patch on a full-field grating (that is, large gratings covering the entire
% screen, approximately 120 × 90°; inverse stimulus) with a 15° 
% spacing between the centre of the patches (regular grid). For two-photon
% calcium-imaging experiments, stimuli were presented for 1 s at a single
% direction or for 2 s at the four cardinal directions (0.5 s each). 
% Stimulation periods were interleaved by 2 s of grey screen. We recorded 5 to
% 10 trials per stimulus condition. [Keller et al. 2020] 

    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_RFGrat Para_Noise Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 
try
    %% Contrast setup
    [contrastpix, lums] = gammacorrection(Para_RFGrat.Contrast); 
    inc=lums(2)-lums(1);
    
    %% Draw the trigger for the beginning of the recording
    % build triggering square
    trigger_squ(1) =  Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % trigger-bright
    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));

    %% Input stimulations from file
    % Para_RFGrat.StimulationFile = '\RFreps_10reps.txt' is a 1-D array which saves 
    % the squence of locations where the patches appear
    % for each location. First column: location; Second column: contrast.
    % '\RFreps_10reps.txt' has 10 sequences of 112 stimuli (14*8), so Para_RFGrat.MaxRep = 10.
    sequence_all=load([PATHSTR '\Seq_stimuli' Para_RFGrat.StimulationFile]); 
    NumStim=Para_RFGrat.grid_num_total; % the number of stimuli for one repetition 
    sequence = sequence_all(1:Para_RFGrat.repetition*NumStim); % Para_RFGrat.MaxRep = 10 in '\seqRF_10reps.txt'
    
    %% Generate Frames for each trial
    moving_frames=round(Para_RFGrat.StimTime/1000*FR); % the number of frames showing the simulation in each trial
    moving_frames_angle = moving_frames; % for one cardinal orientation;
    
    %% Draw patches for each trail
    SpatFreqPix=1/(tand(1/Para_RFGrat.SpatFreqDeg/2)*Distance*2*Winwidth/Dispwidth);  
    f=SpatFreqPix*2*pi;
    Angles = [Para_RFGrat.Angle];
    Angles = mod(Angles, 360);
    frames=round(FR/Para_RFGrat.TempFreq);
    phase=(1:frames)/frames*2*pi;  % grating
    movieFrameIndices0=mod(0:(moving_frames_angle-1),frames) + 1;
    %movieFrameIndices1=frames-mod(0:(moving_frames_angle-1),frames);
    for t = 1:length(Angles) 
        a(t)=cosd(Angles(t)-180)*f;
        b(t)=sind(Angles(t)-180)*f;
        dirindex(t)=fix(Angles(t)/180);        % 0 for 0<=angle<180, frameindex=1:frames; 1 for angle>=180, frameindex=frames:1
    end
    % patch size in pixel, center of the patch
    patch_size_pixel = round(tand(Para_RFGrat.patchSize/2)*Distance*2*Winwidth/Dispwidth); % grid size in pixels;
    diameter = round(patch_size_pixel);
    [x_mask,y_mask]=meshgrid(1:diameter,1:diameter);
    mask=((x_mask-diameter/2).^2+(y_mask-diameter/2).^2)<=(diameter*diameter/4);
    
    for i=1:(Para_RFGrat.repetition*NumStim)
        x=mod(sequence(i),Para_RFGrat.grid_width+1); % x = [0,13]; b = mod( a , m ) returns the remainder after division of a by m
        y=fix(sequence(i)/(Para_RFGrat.grid_width+1)); % y = [0,7]; Y = fix( X ) rounds each element of X to the nearest integer toward zero.
        CenterX=round(x*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_width_start);
        CenterY=round(y*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_height_start);
        rectwin{i}= CenterRectOnPoint([0 0 diameter diameter], CenterX, CenterY);
    end
    for t = 1:length(Angles)
        for k = 1:frames
            m_mask=sin(a(t)*x_mask+b(t)*y_mask+phase(k)).*mask;
            texdata_mask = exp(log((lums(2)+inc*m_mask-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor); % transform luminance to pixel value
            Para_RFGrat.tex(t,k)=Screen('MakeTexture', window, texdata_mask);     
        end
    end

    %% Give priority before 'Flip'
    HideCursor;
    priorityLevel=MaxPriority(window);      
    Priority(priorityLevel);
    Screen('FillRect', window, contrastpix(2)); %gray background 
	Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);
	Screen('TextSize',window,round(Para_front.SizeofText));
    Screen('DrawText',window,'loading......',0,0,Para_front.maxpixel*0.8);
    Screen('Flip', window);
    
    %% Before recording: Time before trigger
    % Start presentation, but wait Para_Trigger.BeforeTime = 500 ms to start recording/trigger
    tic;
    Screen('FillRect',window,contrastpix(2)); 
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
    % Para_RFGrat.Displaydelay = 10000 ms
    tic;
    Screen('FillRect',window,contrastpix(2)); %gray background 
    Screen('Flip', window);
    while toc<Para_RFGrat.Displaydelay/1000
        [mX, mY, buttons] = GetMouse;
        if buttons(2)
            Priority(0); 
            ShowCursor;
            return;
        end        
    end
    
    % 3. Present Stimulation of each trial
    for i=1:(Para_RFGrat.repetition*NumStim)
        % Baseline activity for each trial
        tic;
        Screen('FillRect',window,contrastpix(2)); %gray background 
        Screen('Flip', window);
        while toc<Para_RFGrat.BaselineTrialTime/1000
            [mX, mY, buttons] = GetMouse;
            if buttons(2)
               Priority(0); 
               ShowCursor;
               return;
            end        
        end
        
        %(2) Moving stimuli
        tic;
        for t = 1:length(Angles)
%             if dirindex(t) ==0
%                 movieFrameIndices=movieFrameIndices0;
%             else
%                 movieFrameIndices=movieFrameIndices1;
%             end
            for moving_frame_i = 1:moving_frames_angle
                Screen('DrawTexture', window, Para_RFGrat.tex(t,movieFrameIndices0(moving_frame_i)), [], rectwin{i});
                Screen('Flip', window);
                [mX, mY, buttons] = GetMouse;
                if buttons(2)
                   Priority(0); 
                   ShowCursor;
                   return;
                end 
            end
        end
        moving_time_receptiveField(i) = toc;
        %moving_time_receptiveField(i)
        % (3) Recovery of baseline for each trial with static stimuli
        tic;
        Screen('FillRect',window,contrastpix(2));
        Screen('Flip', window);
        while toc<((Para_RFGrat.ISI-Para_RFGrat.BaselineTrialTime)/1000 - moving_time_receptiveField(i))
            [mX, mY, buttons] = GetMouse;
            if buttons(2)
               Priority(0); 
               ShowCursor;
               return;
            end
        end
%         % Set waittime between repetitions: Para_RFGrat.interrep = 0 ms
%         if mod(i,NumStim) == 0  
%             WaitSecs(Para_RFGrat.interrep/1000);
%         end
    end
    
    moving_time_receptiveField % print moving time
    % End priority after stimulation
    Priority(0); 
    ShowCursor;
    
catch
    % this "catch" section executes in case of an error in the "try" section
    % above. Importantly, it closes the onscreen window if its open.
    Screen('CloseAll');
    Priority(0);
    psychrethrow(psychlasterror);
end 
