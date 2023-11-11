function ManualBar(window)

% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function runs following:
% A manual bar with mouse control
% adapted from SpriteDemo, code from Leena, need to be modified if need to use

    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_Noise Para_RFGrat Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 

try    
%
% ------ Parameters ------
    barpara=[Para_ManualBar.LengthDeg Para_ManualBar.WidthDeg Para_ManualBar.Angle Para_ManualBar.Foreground Para_ManualBar.Background];
    steps=[Para_ManualBar.DeltaLength Para_ManualBar.DeltaWidth Para_ManualBar.DeltaAngle Para_ManualBar.DeltaBright Para_ManualBar.DeltaBright];
    barlengthpix=round(tand(barpara(1)/2)*Distance*2*Winwidth/Dispwidth);  % bar length in pix
    barwidthpix=round(tand(barpara(2)/2)*Distance*2*Winwidth/Dispwidth);    % bar length in pix
    barangle=barpara(3);
    KbName('UnifyKeyNames');
    foregroundMinusbackground=barpara(4)-barpara(5);
    Screen('TextSize',window,round(Para_subpanel.SizeofText));
    % Hide the mouse cursor.
    HideCursor;
    % ------ Animation Setup ------
    Screen('FillRect',window,Para_ManualBar.Background);
    Screen('Flip', window);          
    barframe = Screen('MakeTexture', window, Para_ManualBar.Background + foregroundMinusbackground*ones(barlengthpix, barwidthpix));
    barRect = [0 0 barwidthpix barlengthpix]; % 
    escapeKey = KbName('0)');
    mX = 0; % The x-coordinate of the mouse cursor
    mY = 0; % The y-coordinate of the mouse cursor
    changelen=0;%flag for changing bar's length; Use key '1' to change
    changewid=0;%flag for changing bar's width; Use key '2' to change
    changeang=0;%flag for changing bar's angle; Use key '3' to change
    changecon=0;%flag for changing bar's contrast; use key '4' to change
    changefore=0;%flag for changing bar's brightness: use key '5' to change
    changeback=0;%flag for changing background: use key '6' to change
    [ keyIsDown0, seconds, keyCode ] = KbCheck;
    %[mX, mY, buttons0] = GetMouse;
        % Exit the demo as soon as the user presses a mouse button.
    while ~keyCode(escapeKey)
      
        [ keyIsDown1, seconds, keyCode ] = KbCheck;
        if keyIsDown1-keyIsDown0==1
            switch find(keyCode)
                case 49
                    if changelen==1
                        changelen=~changelen;  %flag for changing bar's length; Use key '1' to change
                    else
                        changelen=~changelen;
                        changewid=0;
                        changeang=0;
                        changefore=0;
                        changeback=0;
                    end
                case 50
                    if changewid==1
                        changewid=~changewid;  %flag for changing bar's width; Use key '2' to change
                    else
                        changelen=0;
                        changewid=~changewid; 
                        changeang=0;
                        changefore=0;
                        changeback=0;
                    end
                case 51
                    if changeang==1
                        changeang=~changeang;  %flag for changing bar's angle; Use key '3' to change
                    else
                        changelen=0;
                        changewid=0; 
                        changeang=~changeang;
                        changefore=0;
                        changeback=0;
                    end
                case 52
                    changecon=~changecon;  %flag for changing bar's contrast; use key '4' to change
                    temp=Para_ManualBar.Background;
                    Para_ManualBar.Background=Para_ManualBar.Foreground;
                    Para_ManualBar.Foreground=temp;
                    foregroundMinusbackground=(-1)*foregroundMinusbackground;
                    Screen('FillRect',window, Para_ManualBar.Background);
                    barframe = Screen('MakeTexture', window, Para_ManualBar.Background + foregroundMinusbackground*ones(barlengthpix,barwidthpix));
                case 53
                    if changefore==1
                        changefore=~changefore; %flag for changing bar's brightness: use key '5' to change
                    else
                        changelen=0;
                        changewid=0; 
                        changeang=0;
                        changefore=~changefore;
                        changeback=0;                        
                    end                     
                case 54
                    if changeback==1
                        changeback=~changeback; %flag for changing background: use key '6' to change
                    else
                        changelen=0;
                        changewid=0; 
                        changeang=0;
                        changefore=0;
                        changeback=~changeback;                        
                    end
            end
        end
        keyIsDown0=keyIsDown1;
        
        if any([changelen changewid changeang changefore changeback])
            if changelen
                Screen('DrawText',window,['Changing Length: ' num2str(barpara(1))  '(deg)'], 0, 0, Para_ManualBar.Foreground);
            end
            if changewid
                Screen('DrawText',window,['Changing Width: ' num2str(barpara(2)) '(deg)'], 0, 0, Para_ManualBar.Foreground);           
            end
            if changeang
                Screen('DrawText',window,['Changing Angle: ' num2str(barpara(3)) '(deg)'], 0, 0, Para_ManualBar.Foreground);
            end
            if changefore
                Screen('DrawText',window,['Changing Foreground Brightness: ' num2str(barpara(4))], 0, 0, Para_ManualBar.Foreground);
            end
            if changeback
                Screen('FillRect',window,Para_ManualBar.Background);
                Screen('DrawText',window,['Changing Background Brightness: ' num2str(barpara(5))], 0, 0, Para_ManualBar.Foreground);
            end            
            [a, b, buttons1] = GetMouse;
            if buttons1(1)
                barpara=abs(barpara+steps.*[changelen changewid changeang changefore changeback]);
                Para_ManualBar.LengthDeg=barpara(1);
                Para_ManualBar.WidthDeg=barpara(2);
                Para_ManualBar.Angle=barpara(3);
                Para_ManualBar.Foreground=barpara(4);
                Para_ManualBar.Background=barpara(5);
            end
            if buttons1(3)
                barpara=abs(barpara-steps.*[changelen changewid changeang changefore changeback]);
                Para_ManualBar.LengthDeg=barpara(1);
                Para_ManualBar.WidthDeg=barpara(2);
                Para_ManualBar.Angle=barpara(3);
                Para_ManualBar.Foreground=barpara(4);
                Para_ManualBar.Background=barpara(5);
            end
            while any(buttons1) % wait for release
                [a,b,buttons1] = GetMouse;
            end
            %buttons0=buttons1;
            barlengthpix=round(tand(barpara(1)/2)*Distance*2*Winwidth/Dispwidth);  % bar length in pix
            barwidthpix=round(tand(barpara(2)/2)*Distance*2*Winwidth/Dispwidth);    % bar length in pix
            barangle=barpara(3);           
            if barlengthpix<2
                barlengthpix=2;
            end
            if barwidthpix<2
                barwidthpix=2;
            end
            foregroundMinusbackground=barpara(4)-barpara(5);
            barRect = [0 0 barwidthpix barlengthpix]; % 
            barframe = Screen('MakeTexture', window, Para_ManualBar.Background + foregroundMinusbackground*ones(barlengthpix, barwidthpix));
        end
           
        % Get the location and click state of the mouse.
        previousX = mX;
        previousY = mY;
        [mX, mY, buttons] = GetMouse; 
        % Draw the sprite at the new location.
        
        Screen('DrawTexture', window, barframe, barRect, CenterRectOnPoint(barRect, mX, mY),barpara(3));
        Screen('DrawText',window,['x=' num2str(mX/Winwidth,'%5.2f')   ' y=' num2str(mY/Winheight,'%5.2f')], Winwidth/2, 0, Para_ManualBar.Foreground);
        Screen('Flip', window);
    end
    % Revive the mouse cursor.
    ShowCursor; 

catch
    
    % If there is an error in our try block, let's
    % return the user to the familiar MATLAB prompt.
    ShowCursor; 
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end
