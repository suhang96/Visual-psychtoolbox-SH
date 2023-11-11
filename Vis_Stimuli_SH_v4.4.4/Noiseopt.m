function Noiseopt(window)
% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% from Leena, need to modify and record noise if needed
    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_RFGrat Para_Noise Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 
try
    trigger_squ(1) =  Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % give the highest contrast
    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));
    squsizepixel=tand(Para_Noise.SquSizeDeg/2)*Distance*2*Winwidth/Dispwidth;
    n_trig=round(Para_Trigger.StimTime/1000*FR);
    n_stop = round(Para_Noise.StopTime/1000*FR);
    OnFrames=round(Para_Noise.StimTime/1000*FR); %the number of frames showing the simulation pattern
    OffFrames=round(Para_Noise.ISI/1000*FR); %the number of frames showing the background intensity.

    row=round(Winheight/squsizepixel);
    column=round(Winwidth/squsizepixel);
    patt=rand(row,column);
    nsimage=imresize(patt,squsizepixel)*Para_Noise.maxpixel;    
    tex(1)=Screen('MakeTexture', window,nsimage);
    background=Para_Noise.background;
    tex(2)=Screen('MakeTexture', window,zeros(size(nsimage))+background);
    trigger_frames = round(Para_Trigger.StimTime/1000*FR); % the number of frames showing the trigger for Para_Trigger.StimTime=80;   

    % show the movie
    HideCursor;
	priorityLevel=MaxPriority(window);
    buttons=zeros(1,3);
	Priority(priorityLevel);
    [mX, mY, buttons] = GetMouse;
    while any(buttons) % if already down, wait for release
        [mX, mY, buttons] = GetMouse;
    end
    Screen('DrawText',window,'Ready!left:start  middle:exit',10,30,Para_Noise.maxpixel);
    Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);
    Screen('Flip', window);
    while ~buttons(2)    
        [mX, mY, buttons] = GetMouse;
        if buttons(1)
            for m=1:trigger_frames 
                Screen('FillRect',window,tex(2)); %gray background 
                Screen('DrawTexture', window, trigger_squ(1),[],Para_Trigger.Location); % BRIGHT TRIGGER
                Screen('Flip', window);
            end

            % 2. Present background to get baseline activity recording for
            % Para_MoveSquGrat.Displaydelay = 10000 ms
            tic;
            Screen('FillRect',window,tex(2)); %gray background 
            Screen('Flip', window);
            while toc<Para_Noise.Displaydelay/1000
                [mX, mY, buttons] = GetMouse;
                if buttons(2)
                   Priority(0); 
                   ShowCursor;
                   return;
                end        
            end    
            for j=1:Para_Noise.repetition
                for ii = 1:length(Para_Noise.ISI)
                    for i=1:n_trig
                        Screen('DrawTexture', window, tex(2));
                        Screen('DrawTexture', window, trigger_squ(1),[],Para_Trigger.Location);
                        Screen('Flip', window);
                        [mX, mY, buttons] = GetMouse;
                        if buttons(2)
                            break;
                        end
                    end
                    if buttons(2)
                        break;
                    end
                    for i=n_trig+1:n_stop
                        Screen('DrawTexture', window, tex(2));
                        Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);
                        Screen('Flip', window);
                        [mX, mY, buttons] = GetMouse;
                        if buttons(2)
                            break;
                        end
                    end
                    if buttons(2)
                        break;
                    end
                    for i=1:OnFrames
                        Screen('DrawTexture', window, tex(1));
                        Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);
                        Screen('Flip', window);
                        [mX, mY, buttons] = GetMouse;
                        if buttons(2)
                            break;
                        end
                    end
                    if buttons(2)
                        break;
                    end
                    for i=1:OffFrames(ii)
                        Screen('DrawTexture', window, tex(2));
                        Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);
                        Screen('Flip', window);
                        [mX, mY, buttons] = GetMouse;
                        if buttons(2)
                            break;
                        end                    
                    end
                    if buttons(2)
                        break;
                    end
                end
                if buttons(2)
                    break;
                end
            end
        end
        %while any(buttons) % if already down, wait for release
        %    [mX, mY, buttons] = GetMouse;
        %end
    end
  
    Priority(0); 
    
    while any(buttons) % if already down, wait for release
        [mX, mY, buttons] = GetMouse;
    end
    ShowCursor;
    %PsychSerial('Close',portA);
   
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    Screen('CloseAll');
    Priority(0);
    psychrethrow(psychlasterror);
end %try..catch..
