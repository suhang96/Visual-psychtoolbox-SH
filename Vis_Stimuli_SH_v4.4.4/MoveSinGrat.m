function MoveSinGrat(window)% Shuhan Huang @ Fishell lab Updated on 10/05/2021% shuhan_huang@g.harvard.edu% This function presents moving sino grating stimulation (full screen or mask).% This function runs following on gray background:% Gray screen w/ DARK TRIGGER(left bottom): Para_Trigger.BeforeTime = 1000 ms% Start recording:    % Gray screen w/ BRIGHT TRIGGER(left bottom): Para_Trigger.StimTime = 80 ms    % Gray screen w/o TRIGGER for baseline: Para_MvSinGrat.Displaydelay = 10000 ms    % Moving bar with Para_MvSinGrat.Contrast = Para_Monitor.MaximalContrast:        % Each trial is Para_MvSinGrat.ISI=6000 ms (2s stimuli, 4s grey        % screen)            % Static Stimuli(Para_MvSinGrat.Static = 1) or Grey screen(Para_MvSinGrat.Static = 0) for FULL field and grey screen for mask(baseline): Para_MvSinGrat.BaselineTrialTime = 1000 ms;            % Moving Stimuli: Para_MvSinGrat.Tmoving=2000 ms;            % Static Stimuli(Para_MvSinGrat.Static = 1) or Grey screen(Para_MvSinGrat.Static = 0) for FULL field and grey screen for mask (for recover): Para_MvSinGrat.ISI - Para_MvSinGrat.Tmoving - Para_MvSinGrat.BaselineTrialTime% Stimulation progarm can be quit with Mouse(2);% Parameters to change:%     Para_MvSinGrat.StimulationFiles = {'\d12sequence_5reps.txt', '\d4sequence.txt'};%     Para_MvSinGrat.StimulationFile = 1;%     Para_MvSinGrat.Displaydelay = 10000;  %time before display of stimulation in ms%     Para_MvSinGrat.FullFlag=1; % the flag of whether using full screen stimulation. 1=full screen, 0=subscreen%     Para_MvSinGrat.SpatFreqDeg=0.04;   %cycle/degree%     Para_MvSinGrat.SpatFreqRG=[0.005 0.64]; % range of spatial frequency%     Para_MvSinGrat.TempFreq=2;     %Hz%     Para_MvSinGrat.Contrast = Para_Monitor.MaximalContrast;%     Para_MvSinGrat.BaselineTrialTime = 1000;%     Para_MvSinGrat.Tmoving = 2000;%     Para_MvSinGrat.ISI = 5000;%     Para_MvSinGrat.Size = 15;%     Para_MvSinGrat.Static = 0; % 1-use static grating during ISI; 0-use grey screen    %% Global parameters    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight;     global Para_Monitor Para_front Para_subpanel Para_Trigger Para_Noise Para_RFGrat Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous Para_RFCourse;     global RF_X RF_Y;   % the center of RF    global FrontRect;     try    %% Contrast setup    % update contrast    [contrastpix lums]=gammacorrection(Para_MvSinGrat.Contrast);    inc=lums(2)-lums(1); %amplitude of sinusoidal function in luminance    %% Prepare stimulations    % Decide how many orientations to present     % Input stimulations from file    sequence=load([PATHSTR '\Seq_stimuli' Para_MvSinGrat.StimulationFiles{Para_MvSinGrat.StimulationFile}]);    angle = mod(sequence(:,1), 360); % make sure angle is [0,360)     %% Draw the trigger for the beginning of the recording    % build triggering square    trigger_squ(1) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % trigger-bright    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));    %% Generate Frames for each trial    % Decide if stimulation is full screen or not    % if full screen    [x,y]=meshgrid(1:Winwidth,1:Winheight);    rectwin=[0 0 Winwidth Winheight];    % if masked%     CenterX=round(RF_X*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_width_start);%     CenterY=round(RF_Y*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_height_start);    CenterX=round((RF_X)*Para_RFCourse.SquareSize(1));    CenterY=round((RF_Y)*Para_RFCourse.SquareSize(2));    diameter= round(tand(Para_MvSinGrat.Size/2)*Distance*2*Winwidth/Dispwidth);    [x_mask,y_mask]=meshgrid(1:diameter,1:diameter);    rectwin_mask= CenterRectOnPoint([0 0 diameter diameter], CenterX, CenterY);    mask=((x_mask-diameter/2).^2+(y_mask-diameter/2).^2)<=(diameter*diameter/4);            % get frame numbers for moving    moving_frames=round(Para_MvSinGrat.Tmoving/1000*FR); %  frames    % Prepare gray screen and prepare to draw the trigger    angle_range=(0:30:150)-180;    SpatFreqPix=1/(tand(1/Para_MvSinGrat.SpatFreqDeg/2)*Distance*2*Winwidth/Dispwidth);      f=SpatFreqPix*2*pi; 	    a=cosd(angle_range)*f;    b=sind(angle_range)*f;    frames=round(FR/Para_MvSinGrat.TempFreq);    phase=(1:frames)/frames*2*pi;  % grating    movieFrameIndices0=mod(0:(moving_frames-1),frames) + 1;    movieFrameIndices1=frames-mod(0:(moving_frames-1),frames);    orindex=mod(angle, 180)/30+1;   % orientation index is the index for Para_MvSinGrat.tex(orindex, frameindex)    dirindex=fix(angle/180);        % 0 for 0<=angle<180, frameindex=1:frames; 1 for angle>=180, frameindex=frames:1          %% Give priority before 'Flip', loading window    HideCursor;	priorityLevel=MaxPriority(window);	Priority(priorityLevel);    Screen('FillRect', window, contrastpix(2)); %gray background 	Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);	Screen('TextSize',window,round(Para_front.SizeofText));    Screen('DrawText',window,'loading......',0,0,Para_front.maxpixel*0.8);    Screen('Flip', window);    %% calculate each angle stimulation    for j=1:length(angle_range)        for k = 1:frames            m=sin(a(j)*x+b(j)*y+phase(k));            texdata_full = exp(log((lums(2)+inc*m-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor); % transform luminance to pixel value            Para_MvSinGrat.tex(2,j,k)=Screen('MakeTexture', window, texdata_full);             m_mask=sin(a(j)*x_mask+b(j)*y_mask+phase(k)).*mask;            texdata_mask = exp(log((lums(2)+inc*m_mask-Para_Monitor.BaseFactor)/Para_Monitor.AmpFactor)/Para_Monitor.GammaFactor); % transform luminance to pixel value            Para_MvSinGrat.tex(1,j,k)=Screen('MakeTexture', window, texdata_mask);                  end    end        %% Give priority before 'Flip'    HideCursor;	priorityLevel=MaxPriority(window);	Priority(priorityLevel);        %% Before recording: Time before trigger    % Start presentation, but wait Para_Trigger.BeforeTime = 500 ms to start recording/trigger    tic;    Screen('FillRect',window,contrastpix(2)); %gray background     Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location); % DARK TRIGGER    Screen('Flip', window);    while toc<Para_Trigger.BeforeTime/1000        [mX, mY, buttons] = GetMouse;        if buttons(2)           Priority(0);            ShowCursor;           return;        end            end                %% present TRIGGER to start recording (RECORDING DATA STARTS HERE]    % 1. Trigger time: Para_Trigger.StimTime=80    tic;    Screen('DrawTexture', window, trigger_squ(1),[],Para_Trigger.Location); % BRIGHT TRIGGER    Screen('Flip', window);    while toc<Para_Trigger.StimTime/1000        [mX, mY, buttons] = GetMouse;        if buttons(2)           Priority(0);            ShowCursor;           return;        end            end            % 2. Present background to get baseline activity recording for    % Para_MoveSquGrat.Displaydelay = 10000 ms    tic;    Screen('FillRect', window,contrastpix(2)); %gray background     Screen('Flip', window);    while toc<Para_MvSinGrat.Displaydelay/1000        [mX, mY, buttons] = GetMouse;        if buttons(2)           Priority(0);            ShowCursor;           return;        end            end            % 3. Present Stimulation of each trial      for j=1:length(angle) % each orientation trial        if dirindex(j)==0            movieFrameIndices=movieFrameIndices0;        else            movieFrameIndices=movieFrameIndices1;        end                        % (1) Baseline activity for each trial with static stimuli        tic; % Para_MoveSquBar.BaselineTrialTime        % if want static stimuli for baseline        if Para_MvSinGrat.FullFlag            if Para_MvSinGrat.Static                Screen('DrawTexture', window, Para_MvSinGrat.tex(Para_MvSinGrat.FullFlag+1,orindex(j),movieFrameIndices(1)), [], rectwin);            else                Screen('FillRect', window,contrastpix(2)); %gray background             end        else            Screen('FillRect', window,contrastpix(2)); %gray background         end        Screen('Flip', window);        while toc<Para_MvSinGrat.BaselineTrialTime/1000            [mX, mY, buttons] = GetMouse;            if buttons(2)               Priority(0);                ShowCursor;               return;            end                end                 % (2) Moving Stimuli        moving_frame_i = 0;        tic;        for moving_frame_i = 1:moving_frames            if Para_MvSinGrat.FullFlag                Screen('DrawTexture', window, Para_MvSinGrat.tex(Para_MvSinGrat.FullFlag+1,orindex(j),movieFrameIndices(moving_frame_i)), [], rectwin);            else                Screen('DrawTexture', window, Para_MvSinGrat.tex(Para_MvSinGrat.FullFlag+1,orindex(j),movieFrameIndices(moving_frame_i)), [], rectwin_mask);            end            Screen('Flip', window);            [mX, mY, buttons] = GetMouse;            if buttons(2)               Priority(0);                ShowCursor;               return;            end         end        moving_time_sinGrating(j) = toc;                % (3) Recovery of baseline for each trial with static stimuli        tic;        if Para_MvSinGrat.FullFlag            Screen('DrawTexture', window, Para_MvSinGrat.tex(Para_MvSinGrat.FullFlag+1,orindex(j),movieFrameIndices(moving_frame_i)), [], rectwin);            if Para_MvSinGrat.Static                Screen('DrawTexture', window, Para_MvSinGrat.tex(Para_MvSinGrat.FullFlag+1,orindex(j),movieFrameIndices(1)), [], rectwin);            else                Screen('FillRect', window,contrastpix(2)); %gray background             end        else            Screen('FillRect', window,contrastpix(2)); %gray background         end        Screen('Flip', window);        while toc<((Para_MvSinGrat.ISI-Para_MvSinGrat.BaselineTrialTime)/1000 - moving_time_sinGrating(j))            [mX, mY, buttons] = GetMouse;            if buttons(2)               Priority(0);                ShowCursor;               return;            end                end      end    moving_time_sinGrating % print moving time    Priority(0);     ShowCursor;    %print(moving_time)catch    %this "catch" section executes in case of an error in the "try" section    %above.  Importantly, it closes the onscreen window if its open.    Screen('CloseAll');    Priority(0);    psychrethrow(psychlasterror);end 