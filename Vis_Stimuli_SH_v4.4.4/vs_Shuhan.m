
function vs_Shuhan

% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function runs following:
    % Core GUI for visual stimulation
    
    % Use Keyboard-Esc to exit program.
    % Use mouse to control program, use mouse(2) to stop program

    % Few parameters need to be changed in init_para.m
    % gamma correction to be done to input parameters for specific moniter
    % Distance of the object to screen center need to be given
    % Screen number need to be specify
    % Stimulation files now in the same folder as code: PATHSTR
    
    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_RFGrat ...
        Para_Noise Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
        Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar  Para_MvSinGratSF Para_MvSinGratTF ...
        Para_Spontaneous Para_RFCourse Para_LocalSparseNoise4 Para_MvSinGrat_Ori_Contrast ...
        Para_MvSinGrat_Ori_Contrast_Size Para_Intrinsic; 
    global RF_X RF_Y; % the center of RF
    global FrontRect; 
try
    
    %% ---------- Window Setup ----------
    % Opens a window.
    AssertOpenGL;
    % Screen is able to do a lot of configuration and performance checks on
    % open, and will print out a fair amount of detailed information when
    % it does.  These commands supress that checking behavior and just let
    % the demo go straight into action.  See ScreenTest for an example of
    % how to do detailed checking.
    Screen('Preference', 'VisualDebugLevel', 3);
    Screen('Preference', 'SuppressAllWarnings', 1);
    % Screen('Preference', 'SkipSyncTests', 1)
	
    %% ---------- initiate parameters ----------
    init_para;
    
    %% ---------- Window Setup Continue----------
    % Opens a graphics window on the main monitor (screen 0).  If you have
    % multiple monitors connected to your computer, then you can specify
    % a different monitor by supplying a different number in the second
    % argument to OpenWindow, e.g. Screen('OpenWindow', 2).
    % [windowPtr,rect]=Screen(‘OpenWindow’,windowPtrOrScreenNumber [,color] 
    % [,rect][,pixelSize][,numberOfBuffers][,stereomode][,multisample]
    % [,imagingmode][,specialFlags][,clientRect][,fbOverrideRect][,vrrParams=[]]);
    window=Screen('OpenWindow',screenNumber,Para_front.background,[],[],2);

    %% ---------- GUI Setup ----------    
    % Input init_load.m parameters
    init_load(window);
    
    % Show front panel
    Front(window); 
    
    % Use mouse and keyboard to stop/exit program
    % Setup mouse control 
    ShowCursor(screenNumber);
    buttons=zeros(1,3); % generate 3 buttons setting with mouse (L, M ,R)
    % Setup keyboard control
    KbName('UnifyKeyNames');
    escapeKey = KbName('ESCAPE');
    % Return keyboard status, time of the status check and keyboard scan code.
    [keyIsDown, seconds, keyCode] = KbCheck; 
    
	while ~keyCode(escapeKey)
        [keyIsDown, seconds, keyCode] = KbCheck;
        [mX, mY, buttons] = GetMouse;
        %% mouse left click
        if buttons(1) 
            % -------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.RFGrat)
                ReceptiveFieldMapping_2p1dir(window); 
                %ReceptiveFieldMapping_2p(window); 
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.SecondRFGrat)
                secondReceptiveFieldMapping_2p(window);
                Front(window);
            end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.RF_X)
                RF_X=RF_X+0.5;
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.RF_Y)
                RF_Y=RF_Y+0.5;
                Front(window);
            end      
            
            if IsInRect(mX,mY,FrontRect.RFReptition)
                Para_RFGrat.repetition=min(Para_RFGrat.repetition+1,Para_RFGrat.MaxRep);
                Front(window);
            end     
            if IsInRect(mX,mY,FrontRect.RFPatchSize)
                Para_RFGrat.patchSize=min(90,Para_RFGrat.patchSize+5);
                Front(window);
            end     
            if IsInRect(mX,mY,FrontRect.RFDisplaydelay)
                Para_RFGrat.Displaydelay=Para_RFGrat.Displaydelay+1000;
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.RFTbaseline)
                Para_RFGrat.BaselineTime=Para_RFGrat.BaselineTrialTime+500;
                Para_RFGrat.ISI=max(Para_RFGrat.ISI,Para_RFGrat.BaselineTime+Para_RFGrat.StimTime);
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.RFTmoving)
                Para_RFGrat.StimTime=Para_RFGrat.StimTime+500;
                Para_RFGrat.ISI=max(Para_RFGrat.ISI,Para_RFGrat.BaselineTime+Para_RFGrat.StimTime);
                Front(window);
            end    
            
            if IsInRect(mX,mY,FrontRect.RFISI)
                Para_RFGrat.ISI=max(Para_RFGrat.ISI+500,Para_RFGrat.BaselineTime+Para_RFGrat.StimTime);
                Front(window);
            end 
            
            % -------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.IntrinsicDir)
                IntrinsicDir(window);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.IntrinsicDirRepeat)
                Para_Intrinsic.repeats=Para_Intrinsic.repeats + 1;
                Front(window);
            end  
            
            % -------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.ManBar)
                ManualBar(window);
                Front(window);
            end
            % -------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.OnOff)
                RFCourse(window); 
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.OnOffReptition)
                Para_RFCourse.repetition=min(Para_RFCourse.repetition+1,Para_RFCourse.MaxRep);
                Front(window);
            end     
            if IsInRect(mX,mY,FrontRect.OnOffDisplaydelay)
                Para_RFCourse.Displaydelay=Para_RFCourse.Displaydelay+1000;
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.OnOffTbaseline)
                Para_RFCourse.BaselineTime=Para_RFCourse.BaselineTime+100;
                Para_RFCourse.ISI=max(Para_RFCourse.ISI,Para_RFCourse.BaselineTime+Para_RFCourse.StimTime);
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.OnOffTSti)
                Para_RFCourse.StimTime=Para_RFCourse.StimTime+100;
                Para_RFCourse.ISI=max(Para_RFCourse.ISI,Para_RFCourse.BaselineTime+Para_RFCourse.StimTime);
                Front(window);
            end    
            
            if IsInRect(mX,mY,FrontRect.OnOffISI)
                Para_RFCourse.ISI=max(Para_RFCourse.ISI+100,Para_RFCourse.BaselineTime+Para_RFCourse.StimTime);
                Front(window);
            end 

            % LocalSparseNoise4-------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.LocalSparseNoise4)
                LocalSparseNoise4(window); 
                Front(window);
            end
   
            if IsInRect(mX,mY,FrontRect.LocalSparseNoise4_Displaydelay)
                Para_LocalSparseNoise4.Displaydelay=Para_LocalSparseNoise4.Displaydelay+1000;
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.LocalSparseNoise4_Tbaseline)
                Para_LocalSparseNoise4.BaselineTime=Para_LocalSparseNoise4.BaselineTime+50;
                Para_LocalSparseNoise4.ISI=max(Para_LocalSparseNoise4.ISI,Para_LocalSparseNoise4.BaselineTime+Para_LocalSparseNoise4.StimTime);
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.LocalSparseNoise4_TSti)
                Para_LocalSparseNoise4.StimTime=Para_LocalSparseNoise4.StimTime+50;
                Para_LocalSparseNoise4.ISI=max(Para_LocalSparseNoise4.ISI,Para_LocalSparseNoise4.BaselineTime+Para_LocalSparseNoise4.StimTime);
                Front(window);
            end    
            
            if IsInRect(mX,mY,FrontRect.LocalSparseNoise4_ISI)
                Para_LocalSparseNoise4.ISI=max(Para_LocalSparseNoise4.ISI+50,Para_LocalSparseNoise4.BaselineTime+Para_LocalSparseNoise4.StimTime);
                Front(window);
            end 

            % -------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat)
                MoveSinGrat(window);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.secondMoveSinGrat)
                secondMoveSinGrat(window);
                Front(window);
            end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.MvSinGratSF)
                if Para_MvSinGrat.SpatFreqDeg*2<=Para_MvSinGrat.SpatFreqRG(2)
                    Para_MvSinGrat.SpatFreqDeg=Para_MvSinGrat.SpatFreqDeg*2;
                    Front(window);
                end
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratTF)
                Para_MvSinGrat.TempFreq=Para_MvSinGrat.TempFreq+0.1;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratStimulation)
                Para_MvSinGrat.StimulationFile = min(Para_MvSinGrat.StimulationFile+1,length(Para_MvSinGrat.StimulationFiles));
                Front(window);           
            end 
            if IsInRect(mX,mY,FrontRect.MvSinGratFullFlag)
                Para_MvSinGrat.FullFlag = ~Para_MvSinGrat.FullFlag;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratContrast)
                Para_MvSinGrat.Contrast=min(Para_Monitor.MaximalContrast,Para_MvSinGrat.Contrast+0.05);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratDisplaydelay)
                Para_MvSinGrat.Displaydelay=Para_MvSinGrat.Displaydelay+500;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratTbaseline)
                Para_MvSinGrat.BaselineTrialTime=Para_MvSinGrat.BaselineTrialTime+500;
                Para_MvSinGrat.ISI = max(Para_MvSinGrat.Tmoving + Para_MvSinGrat.BaselineTrialTime, Para_MvSinGrat.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MvSinGratTmoving)
                Para_MvSinGrat.Tmoving=Para_MvSinGrat.Tmoving+500;
                Para_MvSinGrat.ISI = max(Para_MvSinGrat.Tmoving + Para_MvSinGrat.BaselineTrialTime, Para_MvSinGrat.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratISI)
                Para_MvSinGrat.ISI=max(Para_MvSinGrat.Tmoving + Para_MvSinGrat.BaselineTrialTime,Para_MvSinGrat.ISI+500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratSize)
                Para_MvSinGrat.Size=min(Para_MvSinGrat.Size+5,90);
                Front(window);
            end
            
            % -------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSquGrat)
                MoveSquGrat(window);
                Front(window);
            end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSquGratFullFlag)
                Para_MoveSquGrat.FullFlag = ~Para_MoveSquGrat.FullFlag;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratSpatFreq)
                Para_MoveSquGrat.SpatFreqDeg=Para_MoveSquGrat.SpatFreqDeg*2;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratDutyCycle)
                Para_MoveSquGrat.DutyCycle=min(100,Para_MoveSquGrat.DutyCycle+5);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratStimulation)
                Para_MoveSquGrat.StimulationFile = min(Para_MoveSquGrat.StimulationFile+1,length(Para_MoveSquGrat.StimulationFiles));
                Front(window);           
            end 
            if IsInRect(mX,mY,FrontRect.MoveSquGratTempFreq)
                Para_MoveSquGrat.TempFreq=Para_MoveSquGrat.TempFreq+0.1;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratContrast)
                Para_MoveSquGrat.Contrast=min(Para_Monitor.MaximalContrast,Para_MoveSquGrat.Contrast+0.05);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratDisplaydelay)
                Para_MoveSquGrat.Displaydelay=Para_MoveSquGrat.Displaydelay+500;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratBaselineTrialTime)
                Para_MoveSquGrat.BaselineTrialTime=Para_MoveSquGrat.BaselineTrialTime+500;
                Para_MoveSquGrat.ISI = max(Para_MoveSquGrat.Tmoving + Para_MoveSquGrat.BaselineTrialTime, Para_MoveSquGrat.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSquGratTmoving)
                Para_MoveSquGrat.Tmoving=Para_MoveSquGrat.Tmoving+500;
                Para_MoveSquGrat.ISI = max(Para_MoveSquGrat.Tmoving + Para_MoveSquGrat.BaselineTrialTime, Para_MoveSquGrat.ISI);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratISI)
                Para_MoveSquGrat.ISI=max(Para_MoveSquGrat.Tmoving + Para_MoveSquGrat.BaselineTrialTime,Para_MoveSquGrat.ISI+500);
                Front(window);
            end
            
            % -------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveEdge)
                MoveEdge(window);
                Front(window);
            end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveEdgeRep)
                if Para_MoveEdge.Repetition<Para_MoveEdge.MaxRep
                    Para_MoveEdge.Repetition=Para_MoveEdge.Repetition+1;
                end
                while Para_MoveEdge.Repetition*(Para_MoveEdge.SeqIndex+1)>Para_MoveEdge.MaxRep
                    Para_MoveEdge.SeqIndex=Para_MoveEdge.SeqIndex-1;
                end
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveEdgeSp)
                Para_MoveEdge.Speed = Para_MoveEdge.Speed+5;
                Front(window);
            end  
            if IsInRect(mX,mY,FrontRect.MoveEdgeFullFlag)
                Para_MoveEdge.FullFlag = ~Para_MoveEdge.FullFlag;
                Front(window);
            end
            
            % -------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSquBar)
                MoveSquBar_Full(window);
                Front(window);
            end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSquBarStimulation)
                Para_MoveSquBar.StimulationFile = min(length(Para_MoveSquBar.StimulationFiles),Para_MoveSquBar.StimulationFile+1);
                if (2<Para_MoveSquBar.StimulationFile  && Para_MoveSquBar.StimulationFile <7)
                    Para_MoveSquBar.ISI = 31000; % 3,4,5,6# is 0/180 degrees; 21s + 5s before/after
                else
                    Para_MoveSquBar.ISI = 22000; % 1,2,7,8# is 90/270 degrees; 12s + 5s before/after
                end
                Front(window);
            end        
            if IsInRect(mX,mY,FrontRect.MoveSquBarSpeed)
                Para_MoveSquBar.Speed=Para_MoveSquBar.Speed+Para_MoveSquBar.SpeedStep;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquBarWidth)
                Para_MoveSquBar.WidthDeg=Para_MoveSquBar.WidthDeg+Para_MoveSquBar.WidthDegStep;
                Front(window);
            end     
            if IsInRect(mX,mY,FrontRect.MoveSquBarContrast)
                if Para_MoveSquBar.Contrast+0.05<=Para_Monitor.MaximalContrast
                    Para_MoveSquBar.Contrast = Para_MoveSquBar.Contrast+0.05;
                end
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquBarBarcolor)
                Para_MoveSquBar.ContrastFlag = ~Para_MoveSquBar.ContrastFlag;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquBarBackground)
                Para_MoveSquBar.Background = ~Para_MoveSquBar.Background;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquBarDisplaydelay)
                Para_MoveSquBar.Displaydelay=Para_MoveSquBar.Displaydelay+500;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquBarTbaseline)
                Para_MoveSquBar.BaselineTrialTime=Para_MoveSquBar.BaselineTrialTime+500;
                Para_MoveSquBar.ISI = max(2000+Para_MoveSquBar.BaselineTrialTime, Para_MoveSquBar.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSquBarISI)
                Para_MoveSquBar.ISI = max(2000+Para_MoveSquBar.BaselineTrialTime,Para_MoveSquBar.ISI+1000);
                Front(window);
            end
            
            % MovingSinGrating_Size tuning -------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_Size)
                MoveSinGratSizetuning(window);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.secondMoveSinGrat_Size)
                secondMoveSinGratSizetuning(window);
                Front(window);
            end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeStimulation)
                Para_MvSinGratSize.StimulationFile = min(Para_MvSinGratSize.StimulationFile+1,length(Para_MvSinGratSize.StimulationFiles));
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeAngle)
                Para_MvSinGratSize.Angle = min(Para_MvSinGratSize.Angle + 30, 330);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeSpatFreq)
               Para_MvSinGratSize.SpatFreqDeg=Para_MvSinGratSize.SpatFreqDeg*2;
               Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeTempFreq)
                Para_MvSinGratSize.TempFreq=Para_MvSinGratSize.TempFreq+0.1;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeContrast)
                Para_MvSinGratSize.Contrast=min(Para_Monitor.MaximalContrast,Para_MvSinGratSize.Contrast+0.05);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeDisplaydelay)
                Para_MvSinGratSize.Displaydelay=Para_MvSinGratSize.Displaydelay+500;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeBaselineTrialTime)
                Para_MvSinGratSize.BaselineTrialTime=Para_MvSinGratSize.BaselineTrialTime+500;
                Para_MvSinGratSize.ISI = max(Para_MvSinGratSize.Tmoving + Para_MvSinGratSize.BaselineTrialTime, Para_MvSinGratSize.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeTmoving)
                Para_MvSinGratSize.Tmoving=Para_MvSinGratSize.Tmoving+500;
                Para_MvSinGratSize.ISI = max(Para_MvSinGratSize.Tmoving + Para_MvSinGratSize.BaselineTrialTime, Para_MvSinGratSize.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeISI)
                Para_MvSinGratSize.ISI=max(Para_MvSinGratSize.Tmoving + Para_MvSinGratSize.BaselineTrialTime,Para_MvSinGratSize.ISI+500);
                Front(window);
            end
            
            % MovingSinGrating_Contrast tuning -------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_Ctr)
                MoveSinGratCtrtuning(window);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.secondMoveSinGrat_Ctr)
                secondMoveSinGratCtrtuning(window);
                Front(window);
            end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrStimulation)
                Para_MvSinGratContrast.StimulationFile = min(Para_MvSinGratContrast.StimulationFile+1,length(Para_MvSinGratContrast.StimulationFiles));
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrAngle)
                Para_MvSinGratContrast.Angle = min(Para_MvSinGratContrast.Angle + 30, 330);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrSpatFreq)
               Para_MvSinGratContrast.SpatFreqDeg=Para_MvSinGratContrast.SpatFreqDeg*2;
               Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrTempFreq)
                Para_MvSinGratContrast.TempFreq=Para_MvSinGratContrast.TempFreq+0.1;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrSize)
                Para_MvSinGratContrast.Size=min(100,Para_MvSinGratContrast.Size+5);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrDisplaydelay)
                Para_MvSinGratContrast.Displaydelay=Para_MvSinGratContrast.Displaydelay+500;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrBaselineTrialTime)
                Para_MvSinGratContrast.BaselineTrialTime=Para_MvSinGratContrast.BaselineTrialTime+500;
                Para_MvSinGratContrast.ISI = max(Para_MvSinGratContrast.Tmoving + Para_MvSinGratContrast.BaselineTrialTime, Para_MvSinGratContrast.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrTmoving)
                Para_MvSinGratContrast.Tmoving=Para_MvSinGratContrast.Tmoving+500;
                Para_MvSinGratContrast.ISI = max(Para_MvSinGratContrast.Tmoving + Para_MvSinGratContrast.BaselineTrialTime, Para_MvSinGratContrast.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrISI)
                Para_MvSinGratContrast.ISI=max(Para_MvSinGratContrast.Tmoving + Para_MvSinGratContrast.BaselineTrialTime,Para_MvSinGratContrast.ISI+500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrFullFlag)
                Para_MvSinGratContrast.FullFlag = ~Para_MvSinGratContrast.FullFlag;
                Front(window);
            end
            
            % MovingSinGrating_Spatial Frequency tuning -------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SF)
                MoveSinGratSFtuning(window);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.secondMoveSinGrat_SF)
                secondMoveSinGratSFtuning(window);
                Front(window);
            end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFStimulation)
                Para_MvSinGratSF.StimulationFile = min(Para_MvSinGratSF.StimulationFile+1,length(Para_MvSinGratSF.StimulationFiles));
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFAngle)
                Para_MvSinGratSF.Angle = min(Para_MvSinGratSF.Angle + 30, 330);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFContrast)
               Para_MvSinGratSF.Contrast=min(1,Para_MvSinGratSF.Contrast+0.05);
               Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFTempFreq)
                Para_MvSinGratSF.TempFreq=Para_MvSinGratSF.TempFreq+0.1;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFSize)
                Para_MvSinGratSF.Size=min(100,Para_MvSinGratSF.Size+5);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFDisplaydelay)
                Para_MvSinGratSF.Displaydelay=Para_MvSinGratSF.Displaydelay+500;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFBaselineTrialTime)
                Para_MvSinGratSF.BaselineTrialTime=Para_MvSinGratSF.BaselineTrialTime+500;
                Para_MvSinGratSF.ISI = max(Para_MvSinGratSF.Tmoving + Para_MvSinGratSF.BaselineTrialTime, Para_MvSinGratSF.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFTmoving)
                Para_MvSinGratSF.Tmoving=Para_MvSinGratSF.Tmoving+500;
                Para_MvSinGratSF.ISI = max(Para_MvSinGratSF.Tmoving + Para_MvSinGratSF.BaselineTrialTime, Para_MvSinGratSF.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFISI)
                Para_MvSinGratSF.ISI=max(Para_MvSinGratSF.Tmoving + Para_MvSinGratSF.BaselineTrialTime,Para_MvSinGratSF.ISI+500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFFullFlag)
                Para_MvSinGratSF.FullFlag = ~Para_MvSinGratSF.FullFlag;
                Front(window);
            end
            
            % MovingSinGrating_Temporal Frequency tuning -------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TF)
                MoveSinGratTFtuning(window);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.secondMoveSinGrat_TF)
                secondMoveSinGratTFtuning(window);
                Front(window);
            end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFStimulation)
                Para_MvSinGratTF.StimulationFile = min(Para_MvSinGratTF.StimulationFile+1,length(Para_MvSinGratTF.StimulationFiles));
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFAngle)
                Para_MvSinGratTF.Angle = min(Para_MvSinGratTF.Angle + 30, 330);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFContrast)
               Para_MvSinGratTF.Contrast=min(1,Para_MvSinGratTF.Contrast+0.05);
               Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFSpatFreq)
                Para_MvSinGratTF.SpatFreq=Para_MvSinGratTF.SpatFreq*2;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFSize)
                Para_MvSinGratTF.Size=min(100,Para_MvSinGratTF.Size+5);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFDisplaydelay)
                Para_MvSinGratTF.Displaydelay=Para_MvSinGratTF.Displaydelay+500;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFBaselineTrialTime)
                Para_MvSinGratTF.BaselineTrialTime=Para_MvSinGratTF.BaselineTrialTime+500;
                Para_MvSinGratTF.ISI = max(Para_MvSinGratTF.Tmoving + Para_MvSinGratTF.BaselineTrialTime, Para_MvSinGratTF.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFTmoving)
                Para_MvSinGratTF.Tmoving=Para_MvSinGratTF.Tmoving+500;
                Para_MvSinGratTF.ISI = max(Para_MvSinGratTF.Tmoving + Para_MvSinGratTF.BaselineTrialTime, Para_MvSinGratTF.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFISI)
                Para_MvSinGratTF.ISI=max(Para_MvSinGratTF.Tmoving + Para_MvSinGratTF.BaselineTrialTime,Para_MvSinGratTF.ISI+500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFFullFlag)
                Para_MvSinGratTF.FullFlag = ~Para_MvSinGratTF.FullFlag;
                Front(window);
            end
            
            % MovingSinGrating_Orientation+Contrast tuning-------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_Ori_Contrast)
                MoveSinGrat_Ori_Contrast(window);
                Front(window);
            end
%             if IsInRect(mX,mY,FrontRect.secondMoveSinGrat_Ori_Contrast)
%                 secondMoveSinGrat_Ori_Contrast(window);
%                 Front(window);
%             end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastSF)
                if Para_MvSinGrat_Ori_Contrast.SpatFreqDeg*2<=Para_MvSinGrat_Ori_Contrast.SpatFreqRG(2)
                    Para_MvSinGrat_Ori_Contrast.SpatFreqDeg=Para_MvSinGrat_Ori_Contrast.SpatFreqDeg*2;
                    Front(window);
                end
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastTF)
                Para_MvSinGrat_Ori_Contrast.TempFreq=Para_MvSinGrat_Ori_Contrast.TempFreq+0.1;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastStimulation)
                Para_MvSinGrat_Ori_Contrast.StimulationFile = min(Para_MvSinGrat_Ori_Contrast.StimulationFile+1,length(Para_MvSinGrat_Ori_Contrast.StimulationFiles));
                Front(window);           
            end 
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastFullFlag)
                Para_MvSinGrat_Ori_Contrast.FullFlag = ~Para_MvSinGrat_Ori_Contrast.FullFlag;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastDisplaydelay)
                Para_MvSinGrat_Ori_Contrast.Displaydelay=Para_MvSinGrat_Ori_Contrast.Displaydelay+500;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastTbaseline)
                Para_MvSinGrat_Ori_Contrast.BaselineTrialTime=Para_MvSinGrat_Ori_Contrast.BaselineTrialTime+500;
                Para_MvSinGrat_Ori_Contrast.ISI = max(Para_MvSinGrat_Ori_Contrast.Tmoving + Para_MvSinGrat_Ori_Contrast.BaselineTrialTime, Para_MvSinGrat_Ori_Contrast.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastTmoving)
                Para_MvSinGrat_Ori_Contrast.Tmoving=Para_MvSinGrat_Ori_Contrast.Tmoving+500;
                Para_MvSinGrat_Ori_Contrast.ISI = max(Para_MvSinGrat_Ori_Contrast.Tmoving + Para_MvSinGrat_Ori_Contrast.BaselineTrialTime, Para_MvSinGrat_Ori_Contrast.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastISI)
                Para_MvSinGrat_Ori_Contrast.ISI=max(Para_MvSinGrat_Ori_Contrast.Tmoving + Para_MvSinGrat_Ori_Contrast.BaselineTrialTime,Para_MvSinGrat_Ori_Contrast.ISI+500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastSize)
                Para_MvSinGrat_Ori_Contrast.Size=min(Para_MvSinGrat_Ori_Contrast.Size+5,90);
                Front(window);
            end
            
            % MovingSinGrating_Orientation+Contrast+Size tuning-------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_Ori_Contrast_Size)
                MoveSinGrat_Ori_Contrast_Size(window);
                Front(window);
            end
%             if IsInRect(mX,mY,FrontRect.secondMoveSinGrat_Ori_Contrast)
%                 secondMoveSinGrat_Ori_Contrast(window);
%                 Front(window);
%             end
            % -------------------------------------
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeSF)
                if Para_MvSinGrat_Ori_Contrast_Size.SpatFreqDeg*2<=Para_MvSinGrat_Ori_Contrast_Size.SpatFreqRG(2)
                    Para_MvSinGrat_Ori_Contrast_Size.SpatFreqDeg=Para_MvSinGrat_Ori_Contrast_Size.SpatFreqDeg*2;
                    Front(window);
                end
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeTF)
                Para_MvSinGrat_Ori_Contrast_Size.TempFreq=Para_MvSinGrat_Ori_Contrast_Size.TempFreq+0.1;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeStimulation)
                Para_MvSinGrat_Ori_Contrast_Size.StimulationFile = min(Para_MvSinGrat_Ori_Contrast_Size.StimulationFile+1,length(Para_MvSinGrat_Ori_Contrast_Size.StimulationFiles));
                Front(window);           
            end 
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeDisplaydelay)
                Para_MvSinGrat_Ori_Contrast_Size.Displaydelay=Para_MvSinGrat_Ori_Contrast_Size.Displaydelay+500;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeTbaseline)
                Para_MvSinGrat_Ori_Contrast_Size.BaselineTrialTime=Para_MvSinGrat_Ori_Contrast_Size.BaselineTrialTime+500;
                Para_MvSinGrat_Ori_Contrast_Size.ISI = max(Para_MvSinGrat_Ori_Contrast_Size.Tmoving + Para_MvSinGrat_Ori_Contrast_Size.BaselineTrialTime, Para_MvSinGrat_Ori_Contrast_Size.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeTmoving)
                Para_MvSinGrat_Ori_Contrast_Size.Tmoving=Para_MvSinGrat_Ori_Contrast_Size.Tmoving+500;
                Para_MvSinGrat_Ori_Contrast_Size.ISI = max(Para_MvSinGrat_Ori_Contrast_Size.Tmoving + Para_MvSinGrat_Ori_Contrast_Size.BaselineTrialTime, Para_MvSinGrat_Ori_Contrast_Size.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeISI)
                Para_MvSinGrat_Ori_Contrast_Size.ISI=max(Para_MvSinGrat_Ori_Contrast_Size.Tmoving + Para_MvSinGrat_Ori_Contrast_Size.BaselineTrialTime,Para_MvSinGrat_Ori_Contrast_Size.ISI+500);
                Front(window);
            end


            % Spontanous -------------------------------
            if IsInRect(mX,mY,FrontRect.Spontanous)
                SpontanousBackground(window);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.SpontanousTime)
                Para_Spontaneous.Time = Para_Spontaneous.Time + 1 * 60 * 1000;
                Front(window);
            end


            % Noise -------------------------------
            if IsInRect(mX,mY,FrontRect.Noise)
                Noiseopt(window);
                Front(window);
            end
        end
        
        %% Mouse Right Click
        if buttons(3) 
         % -------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.IntrinsicDirRepeat)
                Para_Intrinsic.repeats=max(1, Para_Intrinsic.repeats - 1);
                Front(window);
            end
         % RF-----------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.RF_X)
                RF_X=RF_X-0.5;
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.RF_Y)
                RF_Y=RF_Y-0.5;
                Front(window);
            end      
            
            if IsInRect(mX,mY,FrontRect.RFReptition)
                Para_RFGrat.repetition=max(1,Para_RFGrat.repetition-1);
                Front(window);
            end     
            if IsInRect(mX,mY,FrontRect.RFPatchSize)
                Para_RFGrat.patchSize=max(0,Para_RFGrat.patchSize-5);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.RFDisplaydelay)
                Para_RFGrat.Displaydelay=max(0,Para_RFGrat.Displaydelay-1000);
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.RFTbaseline)
                Para_RFGrat.BaselineTime=max(0,Para_RFGrat.BaselineTime-500);
                Para_RFGrat.ISI=max(Para_RFGrat.ISI,Para_RFGrat.BaselineTime+Para_RFGrat.StimTime);
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.RFTmoving)
                Para_RFGrat.StimTime=max(0,Para_RFGrat.StimTime-500);
                Para_RFGrat.ISI=max(Para_RFGrat.ISI,Para_RFGrat.BaselineTime+Para_RFGrat.StimTime);
                Front(window);
            end    
            
            if IsInRect(mX,mY,FrontRect.RFISI)
                Para_RFGrat.ISI=max(Para_RFGrat.ISI-500,Para_RFGrat.BaselineTime+Para_RFGrat.StimTime);
                Front(window);
            end 

            % LocalSparseNoise4-------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.LocalSparseNoise4)
                LocalSparseNoise4(window); 
                Front(window);
            end
   
            if IsInRect(mX,mY,FrontRect.LocalSparseNoise4_Displaydelay)
                Para_LocalSparseNoise4.Displaydelay=max(0,Para_LocalSparseNoise4.Displaydelay-1000);
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.LocalSparseNoise4_Tbaseline)
                Para_LocalSparseNoise4.BaselineTime=max(0,Para_LocalSparseNoise4.BaselineTime-50);
                Para_LocalSparseNoise4.ISI=max(Para_LocalSparseNoise4.ISI,Para_LocalSparseNoise4.BaselineTime+Para_LocalSparseNoise4.StimTime);
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.LocalSparseNoise4_TSti)
                Para_LocalSparseNoise4.StimTime=max(0,Para_LocalSparseNoise4.StimTime-50);
                Para_LocalSparseNoise4.ISI=max(Para_LocalSparseNoise4.ISI,Para_LocalSparseNoise4.BaselineTime+Para_LocalSparseNoise4.StimTime);
                Front(window);
            end    
            
            if IsInRect(mX,mY,FrontRect.LocalSparseNoise4_ISI)
                Para_LocalSparseNoise4.ISI=max(Para_LocalSparseNoise4.ISI-50,Para_LocalSparseNoise4.BaselineTime+Para_LocalSparseNoise4.StimTime);
                Front(window);
            end 

            % OnOffReceptiveField-------------------------------------------------------------
            if IsInRect(mX,mY,FrontRect.OnOffReptition)
                Para_RFCourse.repetition=max(1,Para_RFCourse.repetition-1);
                Front(window);
            end     
            if IsInRect(mX,mY,FrontRect.OnOffDisplaydelay)
                Para_RFCourse.Displaydelay=max(0,Para_RFCourse.Displaydelay-1000);
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.OnOffTbaseline)
                Para_RFCourse.BaselineTime=max(0,Para_RFCourse.BaselineTime-100);
                Para_RFCourse.ISI=max(Para_RFCourse.ISI,Para_RFCourse.BaselineTime+Para_RFCourse.StimTime);
                Front(window);
            end
            
            if IsInRect(mX,mY,FrontRect.OnOffTSti)
                Para_RFCourse.StimTime=max(0,Para_RFCourse.StimTime-100);
                Para_RFCourse.ISI=max(Para_RFCourse.ISI,Para_RFCourse.BaselineTime+Para_RFCourse.StimTime);
                Front(window);
            end    
            
            if IsInRect(mX,mY,FrontRect.OnOffISI)
                Para_RFCourse.ISI=max(Para_RFCourse.ISI-100,Para_RFCourse.BaselineTime+Para_RFCourse.StimTime);
                Front(window);
            end 
            
            
            % MV SinGrat -------------------------------------
            if IsInRect(mX,mY,FrontRect.MvSinGratSF)
                Para_MvSinGrat.SpatFreqDeg=Para_MvSinGrat.SpatFreqDeg/2;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MvSinGratStimulation)
                Para_MvSinGrat.StimulationFile = max(1,Para_MvSinGrat.StimulationFile-1);
                Front(window);           
            end 
            if IsInRect(mX,mY,FrontRect.MvSinGratTF)
                Para_MvSinGrat.TempFreq=max(0.1,Para_MvSinGrat.TempFreq-0.1);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratContrast)
                Para_MvSinGrat.Contrast=max(0,Para_MvSinGrat.Contrast-0.05);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratDisplaydelay)
                Para_MvSinGrat.Displaydelay=max(0,Para_MvSinGrat.Displaydelay-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratTbaseline)
                Para_MvSinGrat.BaselineTrialTime=max(0,Para_MvSinGrat.BaselineTrialTime-500);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MvSinGratTmoving)
                Para_MvSinGrat.Tmoving=max(0,Para_MvSinGrat.Tmoving-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratISI)
                Para_MvSinGrat.ISI=max(Para_MvSinGrat.Tmoving + Para_MvSinGrat.BaselineTrialTime,Para_MvSinGrat.ISI-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGratSize)
                Para_MvSinGrat.Size=max(Para_MvSinGrat.Size-5,0);
                Front(window);
            end
            
            
            % MV SquGrat -------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSquGratSpatFreq)
                Para_MoveSquGrat.SpatFreqDeg=Para_MoveSquGrat.SpatFreqDeg/2;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratDutyCycle)
                Para_MoveSquGrat.DutyCycle=max(Para_MoveSquGrat.DutyCycle-5,0);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratStimulation)
                Para_MoveSquBar.StimulationFile = max(1,Para_MoveSquBar.StimulationFile-1);
                Front(window);           
            end 
            if IsInRect(mX,mY,FrontRect.MoveSquGratTempFreq)
                Para_MoveSquGrat.TempFreq=max(0.1,Para_MoveSquGrat.TempFreq-0.1);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratContrast)
                Para_MoveSquGrat.Contrast=max(0,Para_MoveSquGrat.Contrast-0.05);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratDisplaydelay)
                Para_MoveSquGrat.Displaydelay=max(0,Para_MoveSquGrat.Displaydelay-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratBaselineTrialTime)
                Para_MoveSquGrat.BaselineTrialTime=max(0,Para_MoveSquGrat.BaselineTrialTime-500);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSquGratTmoving)
                Para_MoveSquGrat.Tmoving=max(0,Para_MoveSquGrat.Tmoving-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquGratISI)
                Para_MoveSquGrat.ISI=max(Para_MoveSquGrat.Tmoving + Para_MoveSquGrat.BaselineTrialTime,Para_MoveSquGrat.ISI-500);
                Front(window);
            end
            
            % MV Edge -------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveEdgeRep)
                if Para_MoveEdge.Repetition>1
                    Para_MoveEdge.Repetition=Para_MoveEdge.Repetition-1;
                    Front(window);
                end                
            end
            if IsInRect(mX,mY,FrontRect.MoveEdgeSp)
                Para_MoveEdge.Speed = Para_MoveEdge.Speed-5;
                Front(window);
            end
            % miss FULL:Y
            
            % MV Bar -------------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSquBarSpeed)
                if Para_MoveSquBar.Speed>Para_MoveSquBar.SpeedStep
                    Para_MoveSquBar.Speed=Para_MoveSquBar.Speed-Para_MoveSquBar.SpeedStep;
                    Front(window);
                end
            end
            if IsInRect(mX,mY,FrontRect.MoveSquBarWidth)
                if Para_MoveSquBar.WidthDeg>Para_MoveSquBar.WidthDegStep
                    Para_MoveSquBar.WidthDeg=Para_MoveSquBar.WidthDeg-Para_MoveSquBar.WidthDegStep;
                    Front(window);
                end
            end     
            if IsInRect(mX,mY,FrontRect.MoveSquBarContrast)
                Para_MoveSquBar.Contrast = abs(Para_MoveSquBar.Contrast-0.05);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquBarBarcolor)
                Para_MoveSquBar.ContrastFlag = ~Para_MoveSquBar.ContrastFlag;
                Front(window);
            end            
            if IsInRect(mX,mY,FrontRect.MoveSquBarStimulation)
                Para_MoveSquBar.StimulationFile = max(1,Para_MoveSquBar.StimulationFile-1);
                if (2<Para_MoveSquBar.StimulationFile  && Para_MoveSquBar.StimulationFile <7)
                    Para_MoveSquBar.ISI = 31000; % 3,4,5,6# is 0/180 degrees; 21s + 5s before/after
                else
                    Para_MoveSquBar.ISI = 22000; % 1,2,7,8# is 90/270 degrees; 12s + 5s before/after
                end
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquBarDisplaydelay)
                Para_MoveSquBar.Displaydelay=Para_MoveSquBar.Displaydelay-500;
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSquBarTbaseline)
                Para_MoveSquBar.BaselineTrialTime=Para_MoveSquBar.BaselineTrialTime-500;
                Para_MoveSquBar.ISI = max(2000+Para_MoveSquBar.BaselineTrialTime, Para_MoveSquBar.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSquBarISI)
                Para_MoveSquBar.ISI = max(2000+Para_MoveSquBar.BaselineTrialTime,Para_MoveSquBar.ISI-1000);
                Front(window);
            end
            
            % MovingSinGrating_Size tuning -------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeStimulation)
                Para_MvSinGratSize.StimulationFile = max(Para_MvSinGratSize.StimulationFile-1,1);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeAngle)
                Para_MvSinGratSize.Angle = max(Para_MvSinGratSize.Angle - 30, 0);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeSpatFreq)
               Para_MvSinGratSize.SpatFreqDeg=Para_MvSinGratSize.SpatFreqDeg/2;
               Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeTempFreq)
                Para_MvSinGratSize.TempFreq=Para_MvSinGratSize.TempFreq-0.1;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeContrast)
                Para_MvSinGratSize.Contrast=max(0,Para_MvSinGratSize.Contrast-0.05);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeDisplaydelay)
                Para_MvSinGratSize.Displaydelay=max(0, Para_MvSinGratSize.Displaydelay-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeBaselineTrialTime)
                Para_MvSinGratSize.BaselineTrialTime=max(0, Para_MvSinGratSize.BaselineTrialTime-500);
                Para_MvSinGratSize.ISI = max(Para_MvSinGratSize.Tmoving + Para_MvSinGratSize.BaselineTrialTime, Para_MvSinGratSize.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeTmoving)
                Para_MvSinGratSize.Tmoving=max(0, Para_MvSinGratSize.Tmoving-500);
                Para_MvSinGratSize.ISI = max(Para_MvSinGratSize.Tmoving + Para_MvSinGratSize.BaselineTrialTime, Para_MvSinGratSize.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SizeISI)
                Para_MvSinGratSize.ISI=max(Para_MvSinGratSize.Tmoving + Para_MvSinGratSize.BaselineTrialTime,Para_MvSinGratSize.ISI-500);
                Front(window);
            end
            
            % MovingSinGrating_Contrast tuning -------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrStimulation)
                Para_MvSinGratContrast.StimulationFile = max(Para_MvSinGratContrast.StimulationFile-1,1);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrAngle)
                Para_MvSinGratContrast.Angle = max(Para_MvSinGratContrast.Angle - 30, 0);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrSpatFreq)
               Para_MvSinGratContrast.SpatFreqDeg=Para_MvSinGratContrast.SpatFreqDeg/2;
               Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrTempFreq)
                Para_MvSinGratContrast.TempFreq=Para_MvSinGratContrast.TempFreq-0.1;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrSize)
                Para_MvSinGratContrast.Size=max(0,Para_MvSinGratContrast.Size-5);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrDisplaydelay)
                Para_MvSinGratContrast.Displaydelay=max(0, Para_MvSinGratContrast.Displaydelay-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrBaselineTrialTime)
                Para_MvSinGratContrast.BaselineTrialTime=max(0, Para_MvSinGratContrast.BaselineTrialTime-500);
                Para_MvSinGratContrast.ISI = max(Para_MvSinGratContrast.Tmoving + Para_MvSinGratContrast.BaselineTrialTime, Para_MvSinGratContrast.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrTmoving)
                Para_MvSinGratContrast.Tmoving=max(0, Para_MvSinGratContrast.Tmoving-500);
                Para_MvSinGratContrast.ISI = max(Para_MvSinGratContrast.Tmoving + Para_MvSinGratContrast.BaselineTrialTime, Para_MvSinGratContrast.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_CtrISI)
                Para_MvSinGratContrast.ISI=max(Para_MvSinGratContrast.Tmoving + Para_MvSinGratContrast.BaselineTrialTime, Para_MvSinGratContrast.ISI-500);
                Front(window);
            end
            
            % MovingSinGrating_Spatial Freqency tuning -------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFStimulation)
                Para_MvSinGratSF.StimulationFile = max(Para_MvSinGratSF.StimulationFile-1,1);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFAngle)
                Para_MvSinGratSF.Angle = max(Para_MvSinGratSF.Angle - 30, 0);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFContrast)
               Para_MvSinGratSF.Contrast=max(0,Para_MvSinGratSF.Contrast-0.05);
               Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFTempFreq)
                Para_MvSinGratSF.TempFreq=Para_MvSinGratSF.TempFreq-0.1;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFSize)
                Para_MvSinGratSF.Size=max(0,Para_MvSinGratSF.Size-5);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFDisplaydelay)
                Para_MvSinGratSF.Displaydelay=max(0, Para_MvSinGratSF.Displaydelay-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFBaselineTrialTime)
                Para_MvSinGratSF.BaselineTrialTime=max(0, Para_MvSinGratSF.BaselineTrialTime-500);
                Para_MvSinGratSF.ISI = max(Para_MvSinGratSF.Tmoving + Para_MvSinGratSF.BaselineTrialTime, Para_MvSinGratSF.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFTmoving)
                Para_MvSinGratSF.Tmoving=max(0, Para_MvSinGratSF.Tmoving-500);
                Para_MvSinGratSF.ISI = max(Para_MvSinGratSF.Tmoving + Para_MvSinGratSF.BaselineTrialTime, Para_MvSinGratSF.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_SFISI)
                Para_MvSinGratSF.ISI=max(Para_MvSinGratSF.Tmoving + Para_MvSinGratSF.BaselineTrialTime, Para_MvSinGratSF.ISI-500);
                Front(window);
            end
            
            % MovingSinGrating_Temporal Freqency tuning -------------------------------
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFStimulation)
                Para_MvSinGratTF.StimulationFile = max(Para_MvSinGratTF.StimulationFile-1,1);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFAngle)
                Para_MvSinGratTF.Angle = max(Para_MvSinGratTF.Angle - 30, 0);
                Front(window);           
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFContrast)
               Para_MvSinGratTF.Contrast=max(0,Para_MvSinGratTF.Contrast-0.05);
               Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFSpatFreq)
                Para_MvSinGratTF.SpatFreq=Para_MvSinGratTF.SpatFreq/2;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFSize)
                Para_MvSinGratTF.Size=max(0,Para_MvSinGratTF.Size-5);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFDisplaydelay)
                Para_MvSinGratTF.Displaydelay=max(0, Para_MvSinGratTF.Displaydelay-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFBaselineTrialTime)
                Para_MvSinGratTF.BaselineTrialTime=max(0, Para_MvSinGratTF.BaselineTrialTime-500);
                Para_MvSinGratTF.ISI = max(Para_MvSinGratTF.Tmoving + Para_MvSinGratTF.BaselineTrialTime, Para_MvSinGratTF.ISI);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFTmoving)
                Para_MvSinGratTF.Tmoving=max(0, Para_MvSinGratTF.Tmoving-500);
                Para_MvSinGratTF.ISI = max(Para_MvSinGratTF.Tmoving + Para_MvSinGratTF.BaselineTrialTime, Para_MvSinGratTF.ISI); % make sure ISI > Tbaseline + Tmoving
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MoveSinGrat_TFISI)
                Para_MvSinGratTF.ISI=max(Para_MvSinGratTF.Tmoving + Para_MvSinGratTF.BaselineTrialTime, Para_MvSinGratTF.ISI-500);
                Front(window);
            end
            
            % MV SinGrat_Orientation+Contrast-------------------------------------
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastSF)
                Para_MvSinGrat_Ori_Contrast.SpatFreqDeg=Para_MvSinGrat_Ori_Contrast.SpatFreqDeg/2;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastStimulation)
                Para_MvSinGrat_Ori_Contrast.StimulationFile = max(1,Para_MvSinGrat_Ori_Contrast.StimulationFile-1);
                Front(window);           
            end 
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastTF)
                Para_MvSinGrat_Ori_Contrast.TempFreq=max(0.1,Para_MvSinGrat_Ori_Contrast.TempFreq-0.1);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastDisplaydelay)
                Para_MvSinGrat_Ori_Contrast.Displaydelay=max(0,Para_MvSinGrat_Ori_Contrast.Displaydelay-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastTbaseline)
                Para_MvSinGrat_Ori_Contrast.BaselineTrialTime=max(0,Para_MvSinGrat_Ori_Contrast.BaselineTrialTime-500);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastTmoving)
                Para_MvSinGrat_Ori_Contrast.Tmoving=max(0,Para_MvSinGrat_Ori_Contrast.Tmoving-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastISI)
                Para_MvSinGrat_Ori_Contrast.ISI=max(Para_MvSinGrat_Ori_Contrast.Tmoving + Para_MvSinGrat_Ori_Contrast.BaselineTrialTime,Para_MvSinGrat_Ori_Contrast.ISI-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_ContrastSize)
                Para_MvSinGrat_Ori_Contrast.Size=max(Para_MvSinGrat_Ori_Contrast.Size-5,0);
                Front(window);
            end

           % MV SinGrat_Orientation+Contrast+Size-------------------------------------
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeSF)
                Para_MvSinGrat_Ori_Contrast_Size.SpatFreqDeg=Para_MvSinGrat_Ori_Contrast_Size.SpatFreqDeg/2;
                Front(window);
            end

            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeStimulation)
                Para_MvSinGrat_Ori_Contrast_Size.StimulationFile = max(1,Para_MvSinGrat_Ori_Contrast_Size.StimulationFile-1);
                Front(window);           
            end 
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeTF)
                Para_MvSinGrat_Ori_Contrast_Size.TempFreq=max(0.1,Para_MvSinGrat_Ori_Contrast_Size.TempFreq-0.1);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeDisplaydelay)
                Para_MvSinGrat_Ori_Contrast_Size.Displaydelay=max(0,Para_MvSinGrat_Ori_Contrast_Size.Displaydelay-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeTbaseline)
                Para_MvSinGrat_Ori_Contrast_Size.BaselineTrialTime=max(0,Para_MvSinGrat_Ori_Contrast_Size.BaselineTrialTime-500);
                Front(window);
            end   
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeTmoving)
                Para_MvSinGrat_Ori_Contrast_Size.Tmoving=max(0,Para_MvSinGrat_Ori_Contrast_Size.Tmoving-500);
                Front(window);
            end
            if IsInRect(mX,mY,FrontRect.MvSinGrat_Ori_Contrast_SizeISI)
                Para_MvSinGrat_Ori_Contrast_Size.ISI=max(Para_MvSinGrat_Ori_Contrast_Size.Tmoving + Para_MvSinGrat_Ori_Contrast_Size.BaselineTrialTime,Para_MvSinGrat_Ori_Contrast_Size.ISI-500);
                Front(window);
            end

            
            % Spontaneous activity-----------------------------------------
            if IsInRect(mX,mY,FrontRect.SpontanousTime)
                Para_Spontaneous.Time = max(0, Para_Spontaneous.Time - 1 * 60 * 1000);
                Front(window);
            end
        end

        while any(buttons) % wait for release
            [x,y,buttons] = GetMouse(screenNumber);
        end
    end
    
    while any(buttons) % wait for release
        [x,y,buttons] = GetMouse(screenNumber);
    end
    
    Screen('CloseAll');

catch
    Screen('CloseAll');
    Priority(0);
    psychrethrow(psychlasterror); 
end