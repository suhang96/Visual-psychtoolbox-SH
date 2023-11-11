function init_load(window)

% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function runs following:
    % Initial load before GUI
    
    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_RFGrat Para_Noise Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 
    
try
    Screen('FillRect',window, Para_front.background);
    Screen('TextSize',window,round(Para_front.SizeofText));
    Screen('DrawText',window,'program loading......',0,0,Para_front.maxpixel*0.8);
    trigger_squ = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));
    Screen('DrawTexture', window, trigger_squ,[],Para_Trigger.Location);
    Screen('Flip', window);
catch
    Screen('CloseAll');
    Priority(0);
    psychrethrow(psychlasterror);
end