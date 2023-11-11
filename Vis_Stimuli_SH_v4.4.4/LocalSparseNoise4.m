function LocalSparseNoise4(window)
    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_RFGrat Para_Noise Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar  Para_MvSinGratSF Para_MvSinGratTF Para_Spontaneous Para_RFCourse Para_LocalSparseNoise4; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 
    
try
    %% Initiate contrast value
    contrastpix = [255, Para_Monitor.MeanPixel,0];  

    %% READ STIMULI 
    % Read stimuli_file and each trial will be
    % sequence_trial{i}, i = 1,2,...,NumStim; %[[position, color],...]
        % each patch in each trial will be sequence_trial{i}(j,:); 
        % j = 1, 2,..., length(sequence_trial{i}(:,2));
    NumStim=10000; 
    fid = fopen('Seq_stimuli\LocalSparseNoise20000.txt' );
    cac = textscan( fid, '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s', 'CollectOutput'  ...
                    ,   true, 'Delimiter', ':;'  ); % 35*20*0.02 = 14 patches - the maximum per trial
    for i=1:NumStim
        sequence_trial{i} = reshape(str2num(cac{1}{i}),2, [])';
    end
    
    % Get patch size
    SquareWidth = 2*Distance*tan(Para_LocalSparseNoise4.SquareDeg/2*pi/180); 
    SquarePiexl=round(SquareWidth*(Winwidth/Dispwidth)); %size of the square in pixel 
    xPiexlLeft = round((Winwidth-SquarePiexl*Para_LocalSparseNoise4.column)/2);
    yPiexlLeft = round((Winheight-SquarePiexl*Para_LocalSparseNoise4.row)/2);

%     BaseFrames=round(Para_LocalSparseNoise4.BaselineTime/1000*FR);
%     OnFrames=round(Para_LocalSparseNoise4.StimTime/1000*FR); %the number of frames showing the simulation pattern
%     OffFrames=round((Para_LocalSparseNoise4.ISI-Para_LocalSparseNoise4.StimTime-Para_LocalSparseNoise4.BaselineTime)/1000*FR); %the number of frames showing the background intensity.
    
    % build squares with different pixel values
    for i=1:3
        tex(i)=Screen('MakeTexture', window,zeros([SquarePiexl SquarePiexl])+contrastpix(i));    
    end
    
    % build triggering square
    trigger_squ(1) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % give the highest contrast
    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));
    
    SquareLocationIndices={}; %trial_number * maxdotnumber cell  
    SquareContrIndices={}; %trial_number * maxdotnumber cell 
    for i=1:NumStim %Trial_number
        for j= 1:length(sequence_trial{i}(:,2)) 
            patch_in_trial = sequence_trial{i}(j,:); % patches in trial eg.[25,1]
            x=mod(patch_in_trial(1),Para_LocalSparseNoise4.column);
            y=fix(patch_in_trial(1)/Para_LocalSparseNoise4.column);
            SquareLocationIndices{i,j}=[xPiexlLeft+x*SquarePiexl yPiexlLeft+y*SquarePiexl xPiexlLeft+(x+1)*SquarePiexl yPiexlLeft+(y+1)*SquarePiexl];
            SquareContrIndices{i,j}=patch_in_trial(2);
        end
    end
    
    %% Give priority before 'Flip', loading window
    HideCursor;
	priorityLevel=MaxPriority(window);
	Priority(priorityLevel);
    Screen('FillRect', window, contrastpix(2)); %gray background 
	Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);
	Screen('TextSize',window,round(Para_front.SizeofText));
    Screen('DrawText',window,'loading......',0,0,Para_front.maxpixel*0.8);
    Screen('Flip', window);
    
    %% Give priority before 'Flip'
    HideCursor;
	priorityLevel=MaxPriority(window);
	Priority(priorityLevel);
    
    %% Before recording: Time before trigger
    % Start presentation, but wait Para_Trigger.BeforeTime = 500 ms to start recording/trigger
    tic;
    Screen('FillRect',window,contrastpix(2)); %gray background 
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
    % Para_LocalSparseNoise4.Displaydelay = 10000 ms
    tic;
    Screen('FillRect', window,contrastpix(2)); %gray background 
    Screen('Flip', window);
    while toc<Para_LocalSparseNoise4.Displaydelay/1000
        [mX, mY, buttons] = GetMouse;
        if buttons(2)
           Priority(0); 
           ShowCursor;
           return;
        end        
    end    

    for i=1:NumStim
        if Para_LocalSparseNoise4.BaselineTime>0
            tic;
            Screen('FillRect', window,contrastpix(2)); %gray background 
            Screen('Flip', window);
            while toc<Para_LocalSparseNoise4.BaselineTime/1000
                [mX, mY, buttons] = GetMouse;
                if buttons(2)
                   Priority(0); 
                   ShowCursor;
                   return;
                end        
            end
        end

        tic;
        Screen('FillRect', window,contrastpix(2)); %gray background 
        for j=1:length(sequence_trial{i}(:,2)) 
            Screen('DrawTexture', window, tex(SquareContrIndices{i,j}),[],SquareLocationIndices{i,j});
        end
        Screen('Flip', window);
        while toc<Para_LocalSparseNoise4.StimTime/1000
            [mX, mY, buttons] = GetMouse;
            if buttons(2)
               Priority(0); 
               ShowCursor;
               return;
            end        
        end    
        toc

        if Para_LocalSparseNoise4.ISI> ...
                Para_LocalSparseNoise4.StimTime + Para_LocalSparseNoise4.BaselineTime
            tic;
            Screen('FillRect', window,contrastpix(2)); %gray background 
            Screen('Flip', window);
            while toc<(Para_LocalSparseNoise4.ISI...
                    - Para_LocalSparseNoise4.StimTime...
                    - Para_LocalSparseNoise4.BaselineTime)/1000
                [mX, mY, buttons] = GetMouse;
                if buttons(2)
                   Priority(0); 
                   ShowCursor;
                   return;
                end        
            end 
        end
    end
    Priority(0); 
    ShowCursor;
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    Screen('CloseAll');
    Priority(0);
    psychrethrow(psychlasterror);
end 