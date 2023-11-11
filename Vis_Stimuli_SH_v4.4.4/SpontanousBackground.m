function SpontanousBackground(window)

% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function runs following:
% Gray screen w/ DARK TRIGGER(left bottom): Para_Trigger.BeforeTime = 1000 ms
% Start recording:
    % Gray screen w/ BRIGHT TRIGGER(left bottom): Para_Trigger.StimTime = 80 ms
    % Gray screen w/o TRIGGER for Spontanous Background:  Para_Spontaneous.Time = 300000; % 300,000 ms = 5 min
    
    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_RFGrat Para_Noise Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 
try
    %% Draw the trigger for the beginning of the recording
    % build triggering square
    trigger_squ(1) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % trigger-bright
    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));
    
    %% Give priority before 'Flip', loading window
    HideCursor;
	priorityLevel=MaxPriority(window);
	Priority(priorityLevel);
    
    %% Before recording: Time before trigger
    % Start presentation, but wait Para_Trigger.BeforeTime = 500 ms to start recording/trigger
    tic;
    Screen('FillRect',window,Para_Monitor.MeanPixel); %gray background 
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
        
    % 2. Present background to get spontaneous activity recording for Para_Spontaneous.Time
    tic;
    Screen('FillRect', window,Para_Monitor.MeanPixel); %gray background 
    Screen('Flip', window);
    while toc<Para_Spontaneous.Time/1000
        [mX, mY, buttons] = GetMouse;
        if buttons(2)
           Priority(0); 
           ShowCursor;
           return;
        end        
    end    
    
    Priority(0);
    ShowCursor;
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    Screen('CloseAll');
    Priority(0);
    ShowCursor;
    psychrethrow(psychlasterror);
end 
