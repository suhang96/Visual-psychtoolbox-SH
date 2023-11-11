function MoveSinGratSFtuning(window)% Shuhan Huang @ Fishell lab Updated on 10/05/2021% shuhan_huang@g.harvard.edu% This function presents moving sino grating stimulation with different TF with masks.% This function runs following on gray background:% Gray screen w/ DARK TRIGGER(left bottom): Para_Trigger.BeforeTime = 1000 ms% Start recording:    % Gray screen w/ BRIGHT TRIGGER(left bottom): Para_Trigger.StimTime = 80 ms    % Gray screen w/o TRIGGER for baseline: Para_MvSinGratTF.Displaydelay = 10000 ms    % Moving grating with Para_MvSinGratTF.Contrast = Para_Monitor.MaximalContrast:        % Each trial is Para_MvSinGratTF.ISI=6000 ms [Keller et al. 2020]            % Static Stimuli (baseline): Para_MvSinGratTF.BaselineTrialTime = 1000 ms;            % Moving Stimuli (full or patch on RF): Para_MvSinGratTF.Tmoving=2000 ms;            % Static Stimuli (for recover): Para_MvSinGratTF.ISI -                                          % Para_MvSinGratTF.Tmoving -                                          % Para_MvSinGratTF.BaselineTrialTime = 3000 ms;% Stimulation progarm can be quit with Mouse(2);% Parameters to change:%     Para_MvSinGratTF.StimulationFiles = {'\TF_10reps.txt', [NEED TO RE-GENERATE FILES AFTER GAMMACHECK]%         '\TF_10reps_random1.txt',%         '\TF_10reps_random2.txt',%         '\TF_10reps_random3.txt',%         '\TF_10reps_random4.txt',%         '\TF_10reps_random5.txt',%         '\TF_10reps_random6.txt',%         '\TF_10reps_random7.txt',%         '\TF_10reps_random8.txt',%         '\TF_10reps_random9.txt',%         '\TF_10reps_random10.txt'};%     Para_MvSinGratTF.StimulationFile = 5;%     Para_MvSinGratTF.Angle = 90;%     Para_MvSinGratTF.Displaydelay = 1000;  %time before display of stimulation in ms%     Para_MvSinGratTF.Contrast=Para_Monitor.MaximalContrast;%     Para_MvSinGratTF.SpatFreq=0.04;     %     Para_MvSinGratTF.BaselineTrialTime = 1000;%     Para_MvSinGratTF.Tmoving = 2000;%     Para_MvSinGratTF.ISI = 6000;%     Para_MvSinGratTF.Size = 15;  % 10, 15, 20%     Para_MvSinGratTF.FullFlag = 0;    %% Global parameters    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight;     global Para_Monitor Para_front Para_subpanel Para_Trigger Para_Noise Para_RFGrat Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratTF Para_ManualBar ...           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_MvSinGratSF Para_MvSinGratTF Para_Spontaneous Para_RFCourse;     global RF_X RF_Y;   % the center of RF    global FrontRect;     try    [contrastpix lums]=gammacorrection(Para_Monitor.MaximalContrast);    inc=lums(2)-lums(1); %amplitude of sinusoidal function in luminance    %% Prepare stimulations    % Decide how many orientations to present     % Input stimulations from file    sequence=load([PATHSTR '\Seq_stimuli' Para_MvSinGratTF.StimulationFiles{Para_MvSinGratTF.StimulationFile}]);    TF_sequence = sequence(:,1);      %% Draw the trigger for the beginning of the recording    % build triggering square    trigger_squ(1) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % trigger-bright    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));        %% Give priority before 'Flip', loading window    HideCursor;	priorityLevel=MaxPriority(window);	Priority(priorityLevel);    Screen('FillRect', window, contrastpix(2)); %gray background 	Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);	Screen('TextSize',window,round(Para_front.SizeofText));    Screen('DrawText',window,'loading......',0,0,Para_front.maxpixel*0.8);    Screen('Flip', window);    %% Generate Frames for each trial    % get frame numbers for moving    % Prepare gray screen and prepare to draw the trigger    moving_frames=round(Para_MvSinGratTF.Tmoving/1000*FR); %  frames    SpatFreqPix=1/(tand(1/Para_MvSinGratTF.SpatFreq/2)*Distance*2*Winwidth/Dispwidth);      f=SpatFreqPix*2*pi; 	    a=cosd(Para_MvSinGratTF.Angle-180)*f;    b=sind(Para_MvSinGratTF.Angle-180)*f;            % calculate mask size stimulation    % The stimulation has to be masked    if Para_MvSinGratTF.FullFlag        [x,y]=meshgrid(1:Winwidth,1:Winheight);        rectwin=[0 0 Winwidth Winheight];    else    % if masked   %       CenterX=round(RF_X*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_width_start);%       CenterY=round(RF_Y*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_height_start);        CenterX=round((RF_X)*Para_RFCourse.SquareSize(1));        CenterY=round((RF_Y)*Para_RFCourse.SquareSize(2));        diameter= round(tand(Para_MvSinGratTF.Size/2)*Distance*2*Winwidth/Dispwidth);        [x_mask,y_mask]=meshgrid(1:diameter,1:diameter);        rectwin= CenterRectOnPoint([0 0 diameter diameter], CenterX, CenterY);        mask=((x_mask-diameter/2).^2+(y_mask-diameter/2).^2)<=(diameter*diameter/4);    end        % calculate grating    Para_MvSinGratTF.tex = [];    for i = 1:length(TF_sequence)        frames=round(FR/TF_sequence(i));        phase=(1:frames)/frames*2*pi;  % grating        movieFrameIndices0=mod(0:(moving_frames-1),frames) + 1;        movieFrameIndices1=frames-mod(0:(moving_frames-1),frames);            dirindex=fix(Para_MvSinGratTF.Angle/180);        % 0 for 0<=angle<180, frameindex=1:frames; 1 for angle>=180, frameindex=frames:1        if dirindex ==0            movieFrameIndices(i,:)=movieFrameIndices0;        else            movieFrameIndices(i,:)=movieFrameIndices1;        end        % update TF        for k = 1:frames            if Para_MvSinGratTF.FullFlag                m=sin(a*x+b*y+phase(k));                texdata_full = exp(log((lums(2)+inc*m-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor); % transform luminance to pixel value                Para_MvSinGratTF.tex(i,k)=Screen('MakeTexture', window, texdata_full);             else                m_mask=sin(a*x_mask+b*y_mask+phase(k)).*mask;                texdata_mask = exp(log((lums(2)+inc*m_mask-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor); % transform luminance to pixel value                Para_MvSinGratTF.tex(i,k)=Screen('MakeTexture', window, texdata_mask);                 end        end    end    %% Give priority before 'Flip'    HideCursor;	priorityLevel=MaxPriority(window);	Priority(priorityLevel);    %% Before recording: Time before trigger    % Start presentation, but wait Para_Trigger.BeforeTime = 500 ms to start recording/trigger    tic;    Screen('FillRect',window,contrastpix(2)); %gray background     Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location); % DARK TRIGGER    Screen('Flip', window);    while toc<Para_Trigger.BeforeTime/1000        [mX, mY, buttons] = GetMouse;        if buttons(2)           Priority(0);            ShowCursor;           return;        end            end                %% present TRIGGER to start recording (RECORDING DATA STARTS HERE]    % 1. Trigger time: Para_Trigger.StimTime=80    tic;    Screen('DrawTexture', window, trigger_squ(1),[],Para_Trigger.Location); % BRIGHT TRIGGER    Screen('Flip', window);    while toc<Para_Trigger.StimTime/1000        [mX, mY, buttons] = GetMouse;        if buttons(2)           Priority(0);            ShowCursor;           return;        end            end            % 2. Present background to get baseline activity recording for    % Para_MoveSquGrat.Displaydelay = 10000 ms    tic;    Screen('FillRect', window, contrastpix(2)); %gray background     Screen('Flip', window);    while toc<Para_MvSinGratTF.Displaydelay/1000        [mX, mY, buttons] = GetMouse;        if buttons(2)           Priority(0);            ShowCursor;           return;        end            end            % 3. Present Stimulation of each trial      for j=1:length(TF_sequence) % each size trial        % (1) Baseline activity for each trial with static stimuli        tic; % Para_MoveSquBar.BaselineTrialTime        Screen('FillRect', window, contrastpix(2));        Screen('Flip', window);        while toc<Para_MvSinGratTF.BaselineTrialTime/1000            [mX, mY, buttons] = GetMouse;            if buttons(2)               Priority(0);                ShowCursor;               return;            end                end                 % (2) Moving Stimuli        moving_frame_i = 0;        tic;        for moving_frame_i = 1:moving_frames            Screen('DrawTexture', window, Para_MvSinGratTF.tex(j,movieFrameIndices(j,moving_frame_i)), [], rectwin);            Screen('Flip', window);            [mX, mY, buttons] = GetMouse;            if buttons(2)               Priority(0);                ShowCursor;               return;            end         end        moving_time_SinGratTFTuning(j) = toc;                % (3) Recovery of baseline for each trial with static stimuli        tic;        Screen('FillRect', window,contrastpix(2));        Screen('Flip', window);        while toc<((Para_MvSinGratTF.ISI-Para_MvSinGratTF.BaselineTrialTime)/1000 - moving_time_SinGratTFTuning(j))            [mX, mY, buttons] = GetMouse;            if buttons(2)               Priority(0);                ShowCursor;               return;            end                end      end    moving_time_SinGratTFTuning % print moving time    Priority(0);     ShowCursor;catch    %this "catch" section executes in case of an error in the "try" section    %above.  Importantly, it closes the onscreen window if its open.    Screen('CloseAll');    Priority(0);    psychrethrow(psychlasterror);end 