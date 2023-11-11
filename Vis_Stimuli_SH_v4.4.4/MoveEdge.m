function MoveEdge(window)

% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% code from Leena, need to be modified if need to use

    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_Noise Para_RFGrat Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_Spontaneous Para_RFCourse; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 
try
    %% Contrast setup
    contrastpix = gammacorrection(Para_MoveEdge.Contrast);
    
    %% Input stimulations from file
    sequence=load([PATHSTR '\Seq_stimuli' Para_MoveEdge.StimulationFile]); % stimulation sequence 
    
    %% Draw the trigger for the beginning of the recording
    % build triggering square
    trigger_squ(1) =  Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size])+Para_Trigger.Bright); % trigger-bright
    trigger_squ(2) = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));

    
%   SpeedPix = tand(Para_MoveEdge.Speed/2000)*Distance*2*Winheight/Dispheight; %pixel changes per ms
    SpeedPix = (0.01745*Para_MoveEdge.Speed/2000-4.913e-010)*Distance*2*Winheight/Dispheight; %pixel changes per ms
%   SpatFreqPix = 1/(tand(1/Para_MoveEdge.SpatFreqDeg/2)*Distance*2*Winwidth/Dispwidth);  %cycle per pixel  
    inc1 = contrastpix(1)-contrastpix(3);
    inc2 = contrastpix(2)-contrastpix(3);
    
    

    Screen('FillRect', window, contrastpix(2));
    
    % draw the stimulation position
    diameter = 0;
%   rmin=min(Winwidth, Winheight)/4;
    if Para_MoveEdge.FullFlag % = 1: full screen stimulation
        [x,y]=meshgrid(1:Winwidth,1:Winheight);
        rectwin=[0 0 Winwidth Winheight];
        diameter=min(Winwidth, Winheight)/2;
    else % = 0: sub-screen stimulation
%     CenterX=round(RF_X*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_width_start);
%     CenterY=round(RF_Y*Para_RFGrat.grid_size_pixel+Para_RFGrat.grid_height_start);
        CenterX=round((RF_X)*Para_RFCourse.SquareSize(1));
        CenterY=round((RF_Y)*Para_RFCourse.SquareSize(2));
        patch_size_pixel = round(tand(Para_MoveSquGrat.MaskSize/2)*Distance*2*Winwidth/Dispwidth); % grid size in pixels;
        diameter = round(patch_size_pixel);
        [x,y]=meshgrid(1:diameter,1:diameter);
        mask=((x-diameter/2).^2+(y-diameter/2).^2)<=((diameter/2)^2);
        rectwin= CenterRectOnPoint([0 0 diameter diameter], CenterX, CenterY); % newRect = CenterRectOnPoint(rect,x,y): 
    end
    
    SpatFreqPix = 1/diameter/2; %circle/pixel
    Para_MoveEdge.TempFreq = SpeedPix*SpatFreqPix*1000;%Hz
%     Para_MoveEdge.Tduring=ceil(500/Para_MoveEdge.TempFreq)*2;% time during stimulus in ms
    BarWidthPix = Para_MoveEdge.WidthPercent/(100*SpatFreqPix);  %bar width in pixel
    frames=ceil(FR/Para_MoveEdge.TempFreq);% temporal period, in frames, of the drifting grating
    Screen('Screens');	% Make sure all Rushed functions are in memory.
    f=SpatFreqPix*2*pi; % 
    angle=sequence(:,1)-180;
    %%%%%%%%%%%%%%%%%%%%%%% 
	a=cosd(angle)*f;
	b=sind(angle)*f;
    phase=(0:frames)/frames*2*pi;  % grating
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% it's not the problem of tduring or frames, it's caused by phase;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show the movie
    n=round(frames/2+1); %  frames
    n_trig=round(Para_Trigger.StimTime/1000*frames*Para_MoveEdge.TempFreq);% frames which show the trigger square
    if n_trig>n;
        n_trig=n;
    end
    %portA = PsychSerial('Open',SerialPort,'poo',BaudRate);
    movieFrameIndices=mod(0:(n-1),frames) + 1;
    HideCursor;
	priorityLevel=MaxPriority(window);
	Priority(priorityLevel);
    for j=1:length(angle)
         % compute each frame of the movie
        tic;
        k=1;
        m = mod(a(j).*x+b(j).*y+phase(k)-(sqrt(2)*sind(angle(j)+45)-1)*pi/2,2*pi)<=f*BarWidthPix;
        %m = mod(a(j).*x+b(j).*y+phase(k),2*pi)<=f*BarWidthPix;
        incm = m*inc1;
        ta = find(incm==0);
        incm(ta) = incm(ta)-inc2;
        if ~Para_MoveEdge.FullFlag
            incm = incm.*mask;
        end
        tex = zeros(1,frames);
        tex(k)=Screen('MakeTexture', window, contrastpix(2)+incm); 
        Screen('DrawTexture', window, tex(k), [], rectwin);
        Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);
        Screen('Flip', window);
        
        for k=2:min(frames,n)
            m = mod(a(j).*x+b(j).*y+phase(k)-(sqrt(2)*sind(angle(j)+45)-1)*pi/2,2*pi)<=f*BarWidthPix;
%             m = mod(a(j).*x+b(j).*y+phase(k),2*pi)<=f*BarWidthPix;
            incm = m*inc1;
            tb = (find(incm==0)); 
            incm(tb) = incm(tb)-inc2;
            if ~Para_MoveEdge.FullFlag
                incm = incm.*mask;
            end
            tex(k)=Screen('MakeTexture', window, contrastpix(2)+incm); 
            [mX, mY, buttons] = GetMouse;
            if buttons(2)
                Priority(0); 
                ShowCursor;
                %PsychSerial('Close',portA); 
                return;
            end
        end
        toc
        while toc<Para_MoveEdge.Tbefore/1000
            [mX, mY, buttons] = GetMouse;
            if buttons(2)
                Priority(0); 
                ShowCursor;
                %PsychSerial('Close',portA); 
                return;
            end
        end
        %show movie
        for i=1:n_trig
            Screen('DrawTexture', window, tex(movieFrameIndices(i)), [], rectwin);
            Screen('DrawTexture', window, trigger_squ(1),[],Para_Trigger.Location);
            Screen('Flip', window);
        end
        for i=(n_trig+1):n
            Screen('DrawTexture', window, tex(movieFrameIndices(i)), [], rectwin);
            Screen('DrawTexture', window, trigger_squ(2),[],Para_Trigger.Location);
            Screen('Flip', window);
            %if i==1
            %    PsychSerial('Write',portA,'l');
            %else
            [mX, mY, buttons] = GetMouse;
            if buttons(2)
                Priority(0); 
                ShowCursor;
                %PsychSerial('Close',portA);
                return;
            end    
            %end
        end
        WaitSecs(Para_MoveEdge.Tafter/1000);
    end
    Priority(0); 
    ShowCursor;
    %PsychSerial('Close',portA); 

catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    Screen('CloseAll');
    Priority(0);
    psychrethrow(psychlasterror);
end 
