function MoveSinGratCtrtuning(window)% Shuhan Huang @ Fishell lab Updated on 10/05/2021% shuhan_huang@g.harvard.edu% This function presents moving sino grating stimulation with different contrast with masks.% This function runs following on gray background:% Gray screen w/ DARK TRIGGER(left bottom): Para_Trigger.BeforeTime = 1000 ms% Start recording:    % Gray screen w/ BRIGHT TRIGGER(left bottom): Para_Trigger.StimTime = 80 ms    % Gray screen w/o TRIGGER for baseline: Para_MvSinGratContrast.Displaydelay = 10000 ms    % Moving bar with Para_MvSinGratContrast.Contrast = Para_Monitor.MaximalContrast:        % Each trial is Para_MvSinGratContrast.ISI=6000 ms [Keller et al. 2020]            % Static Stimuli (baseline): Para_MvSinGratContrast.BaselineTrialTime = 1000 ms;            % Moving Stimuli: Para_MvSinGratContrast.Tmoving=2000 ms;            % Static Stimuli (for recover): Para_MvSinGratContrast.ISI -                                          % Para_MvSinGratContrast.Tmoving -                                          % Para_MvSinGratContrast.BaselineTrialTime = 3000 ms;% Stimulation progarm can be quit with Mouse(2);% Parameters to change:%     Para_MvSinGratContrast.StimulationFiles = {'\Contrast_10reps.txt', [NEED TO RE-GENERATE FILES AFTER GAMMACHECK]%         '\Contrast_10reps_random1.txt',%         '\Contrast_10reps_random2.txt',%         '\Contrast_10reps_random3.txt',%         '\Contrast_10reps_random4.txt',%         '\Contrast_10reps_random5.txt',%         '\Contrast_10reps_random6.txt',%         '\Contrast_10reps_random7.txt',%         '\Contrast_10reps_random8.txt',%         '\Contrast_10reps_random9.txt',%         '\Contrast_10reps_random10.txt'};%     Para_MvSinGratContrast.StimulationFile = 5;%     Para_MvSinGratContrast.Angle = 0;%     Para_MvSinGratContrast.Displaydelay = 1000;  %time before display of stimulation in ms%     Para_MvSinGratContrast.SpatFreqDeg=0.04;   %cycle/degree%     Para_MvSinGratContrast.TempFreq=2;     %Hz%     Para_MvSinGratContrast.BaselineTrialTime = 1000;%     Para_MvSinGratContrast.Tmoving = 2000;%     Para_MvSinGratContrast.ISI = 6000;%     Para_MvSinGratContrast.Size = 15;  % 10, 15, 20%     Para_MvSinGratContrast.FullFlag = 0;%     [Keller et al. 2020] Contrast tuning. We simultaneously presented classical and inverse%     stimuli with several test contrasts (0, 2−6, 2−5, …, 1). %     Stimuli were presented for 2 s interleaved by 4 s of grey screen %     (10 trials per stimulus combination).    %% Global parameters    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight;     global Para_Monitor Para_front Para_subpanel Para_Trigger Para_Noise Para_RFGrat Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous Para_RFCourse;     global RF_X RF_Y;   % the center of RF    global FrontRect;     try    [contrastpix lums]=gammacorrection(Para_Monitor.MaximalContrast);        %% Prepare stimulations    % Decide how many orientations to present     % Input stimulations from file    sequence=load([PATHSTR '\Seq_stimuli' Para_MvSinGratContrast.StimulationFiles{Para_MvSinGratContrast.StimulationFile}]);    contrast_sequence = sequence(:,1);      %% Draw the trigger for the beginning of the recording    % build triggering square    trigger_squ(1) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % trigger-bright    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));    %% Generate Frames for each trial    % get frame numbers for moving    moving_frames=round(Para_MvSinGratContrast.Tmoving/1000*FR); %  frames    % Prepare gray screen and prepare to draw the trigger    SpatFreqPix=1/(tand(1/Para_MvSinGratContrast.SpatFreqDeg/2)*Distance*2*Winwidth/Dispwidth);      f=SpatFreqPix*2*pi; 	    a=cosd(Para_MvSinGratContrast.Angle-180)*f;    b=sind(Para_MvSinGratContrast.Angle-180)*f;    frames=round(FR/Para_MvSinGratContrast.TempFreq);    phase=(1:frames)/frames*2*pi;  % grating    movieFrameIndices0=mod(0:(moving_frames-1),frames) + 1;    movieFrameIndices1=frames-mod(0:(moving_frames-1),frames);    dirindex=fix(Para_MvSinGratContrast.Angle/180);        % 0 for 0<=angle<180, frameindex=1:frames; 1 for angle>=180, frameindex=frames:1    if dirindex ==0        movieFrameIndices=movieFrameIndices0;    else        movieFrameIndices=movieFrameIndices1;    end        %% Give priority before 'Flip', loading window    HideCursor;	priorityLevel=MaxPriority(window);	Priority(priorityLevel);    Screen('FillRect', window, contrastpix(2)); %gray background 	Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);	Screen('TextSize',window,round(Para_front.SizeofText));    Screen('DrawText',window,'loading......',0,0,Para_front.maxpixel*0.8);    Screen('Flip', window);    %% calculate mask size stimulation    % The stimulation has to be masked    if Para_MvSinGratContrast.FullFlag        [x,y]=meshgrid(1:Winwidth,1:Winheight);        rectwin=[0 0 Winwidth Winheight];    else    % if masked   %     CenterX=round(RF_X*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_width_start);%     CenterY=round(RF_Y*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_height_start);        CenterX=round((RF_X)*Para_RFCourse.SquareSize(1));        CenterY=round((RF_Y)*Para_RFCourse.SquareSize(2));        diameter= round(tand(Para_MvSinGratContrast.Size/2)*Distance*2*Winwidth/Dispwidth);        [x_mask,y_mask]=meshgrid(1:diameter,1:diameter);        rectwin= CenterRectOnPoint([0 0 diameter diameter], CenterX, CenterY);        mask=((x_mask-diameter/2).^2+(y_mask-diameter/2).^2)<=(diameter*diameter/4);    end        Para_MvSinGratContrast.tex = [];    for contrast_ind = 1:length(contrast_sequence)        % update contrast        [contrastpix lums]=gammacorrection(contrast_sequence(contrast_ind));        inc=lums(2)-lums(1); %amplitude of sinusoidal function in luminance        for k = 1:frames            if Para_MvSinGratContrast.FullFlag                m=sin(a*x+b*y+phase(k));                texdata_full = exp(log((lums(2)+inc*m-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor); % transform luminance to pixel value                Para_MvSinGratContrast.tex(contrast_ind,k)=Screen('MakeTexture', window, texdata_full);             else                m_mask=sin(a*x_mask+b*y_mask+phase(k)).*mask;                texdata_mask = exp(log((lums(2)+inc*m_mask-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor); % transform luminance to pixel value                Para_MvSinGratContrast.tex(contrast_ind,k)=Screen('MakeTexture', window, texdata_mask);                 end        end    end        %% Give priority before 'Flip'    HideCursor;	priorityLevel=MaxPriority(window);	Priority(priorityLevel);    [contrastpix lums]=gammacorrection(Para_Monitor.MaximalContrast);    %% Before recording: Time before trigger    % Start presentation, but wait Para_Trigger.BeforeTime = 500 ms to start recording/trigger    tic;    Screen('FillRect',window,contrastpix(2)); %gray background     Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location); % DARK TRIGGER    Screen('Flip', window);    while toc<Para_Trigger.BeforeTime/1000        [mX, mY, buttons] = GetMouse;        if buttons(2)           Priority(0);            ShowCursor;           return;        end            end                %% present TRIGGER to start recording (RECORDING DATA STARTS HERE]    % 1. Trigger time: Para_Trigger.StimTime=80    tic;    Screen('DrawTexture', window, trigger_squ(1),[],Para_Trigger.Location); % BRIGHT TRIGGER    Screen('Flip', window);    while toc<Para_Trigger.StimTime/1000        [mX, mY, buttons] = GetMouse;        if buttons(2)           Priority(0);            ShowCursor;           return;        end            end            % 2. Present background to get baseline activity recording for    % Para_MoveSquGrat.Displaydelay = 10000 ms    tic;    Screen('FillRect', window, contrastpix(2)); %gray background     Screen('Flip', window);    while toc<Para_MvSinGratContrast.Displaydelay/1000        [mX, mY, buttons] = GetMouse;        if buttons(2)           Priority(0);            ShowCursor;           return;        end            end            % 3. Present Stimulation of each trial      for j=1:length(contrast_sequence) % each size trial        % (1) Baseline activity for each trial with static stimuli        tic; % Para_MoveSquBar.BaselineTrialTime        Screen('FillRect', window, contrastpix(2));        Screen('Flip', window);        while toc<Para_MvSinGratContrast.BaselineTrialTime/1000            [mX, mY, buttons] = GetMouse;            if buttons(2)               Priority(0);                ShowCursor;               return;            end                end                 % (2) Moving Stimuli        moving_frame_i = 0;        tic;        for moving_frame_i = 1:moving_frames            Screen('DrawTexture', window, Para_MvSinGratContrast.tex(j,movieFrameIndices(moving_frame_i)), [], rectwin);            Screen('Flip', window);            [mX, mY, buttons] = GetMouse;            if buttons(2)               Priority(0);                ShowCursor;               return;            end         end        moving_time_SinGratContrastTuning(j) = toc;                % (3) Recovery of baseline for each trial with static stimuli        tic;        Screen('FillRect', window,contrastpix(2));        Screen('Flip', window);        while toc<((Para_MvSinGratContrast.ISI-Para_MvSinGratContrast.BaselineTrialTime)/1000 - moving_time_SinGratContrastTuning(j))            [mX, mY, buttons] = GetMouse;            if buttons(2)               Priority(0);                ShowCursor;               return;            end                end      end    moving_time_SinGratContrastTuning % print moving time    Priority(0);     ShowCursor;catch    %this "catch" section executes in case of an error in the "try" section    %above.  Importantly, it closes the onscreen window if its open.    Screen('CloseAll');    Priority(0);    psychrethrow(psychlasterror);end 