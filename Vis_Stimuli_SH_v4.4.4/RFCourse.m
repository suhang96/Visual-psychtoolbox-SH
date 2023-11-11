function RFCourse(window)
    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_RFGrat Para_Noise Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar  Para_MvSinGratSF Para_MvSinGratTF Para_Spontaneous Para_RFCourse; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 
    
try
    sequence_all=load([PATHSTR '\Seq_stimuli' '\RFCourse6x10.txt']);       % sequence is a 2-D array which saves the squence>>
                                                % of locations where the squares appear and the 
                                                % contrast for each location. first column, location;
                                                % second column contrast.
    NumStim=120; %the number of stimuli for one repetition 
    sequence = sequence_all(1:Para_RFCourse.repetition*NumStim,:);
    BaseFrames=round(Para_RFCourse.BaselineTime/1000*FR);
    OnFrames=round(Para_RFCourse.StimTime/1000*FR); %the number of frames showing the simulation pattern
    OffFrames=round((Para_RFCourse.ISI-Para_RFCourse.StimTime-Para_RFCourse.BaselineTime)/1000*FR); %the number of frames showing the background intensity.
    contrastpix = [255, Para_Monitor.MeanPixel,0];  
    
    % build squares with different pixel values
    for i=1:3
        tex(i)=Screen('MakeTexture', window,zeros([Para_RFCourse.SquareSize(2) Para_RFCourse.SquareSize(1)])+contrastpix(i));    
    end
    
    % build triggering square
    trigger_squ(1) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % give the highest contrast
    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));
    
    SquareLocationIndices=[];
    SquareContrIndices=[];
    for i=1:(Para_RFCourse.repetition*NumStim)
        x=mod(sequence(i,1),Para_RFCourse.column);
        y=fix(sequence(i,1)/Para_RFCourse.column);
        SquareLocationIndices=[SquareLocationIndices;[x*Para_RFCourse.SquareSize(1) y*Para_RFCourse.SquareSize(2) (x+1)*Para_RFCourse.SquareSize(1) (y+1)*Para_RFCourse.SquareSize(2)]];
        SquareContrIndices=[SquareContrIndices sequence(i,2)];
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
    % Para_RFCourse.Displaydelay = 10000 ms
    tic;
    Screen('FillRect', window,contrastpix(2)); %gray background 
    Screen('Flip', window);
    while toc<Para_RFCourse.Displaydelay/1000
        [mX, mY, buttons] = GetMouse;
        if buttons(2)
           Priority(0); 
           ShowCursor;
           return;
        end        
    end    

    for i=1:(Para_RFCourse.repetition*NumStim) 
        for m=1:BaseFrames  
            Screen('FillRect',window,contrastpix(2));
            Screen('Flip', window);
            if buttons(2)
                Priority(0); 
                ShowCursor;
                return;
            end
        end
        for m=1:OnFrames  
            Screen('DrawTexture', window, tex(SquareContrIndices(i)),[],SquareLocationIndices(i,:));
            Screen('Flip', window);
            if buttons(2)
                Priority(0); 
                ShowCursor;
                return;
            end
        end
        for m=1:OffFrames
            Screen('FillRect',window,contrastpix(2));
            Screen('Flip', window);            
            [mX, mY, buttons] = GetMouse;
            if buttons(2)
                Priority(0); 
                ShowCursor;
                return;
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