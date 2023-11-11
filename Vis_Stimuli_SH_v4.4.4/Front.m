function Front(window)

% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function runs following:
    % GUI front page
    
    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_Noise ...
        Para_RFGrat Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast... 
        Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_MvSinGratSF ...
        Para_MvSinGratTF Para_Spontaneous Para_RFCourse Para_ManualBar ...
        Para_MvSinGrat_Ori_Contrast Para_MvSinGrat_Ori_Contrast_Size...
        Para_LocalSparseNoise4 Para_Intrinsic; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 

try
    Screen('TextSize',window,round(Para_front.SizeofText));
    offset1=round(Para_front.SizeofText/10);%the offset of x
    offset2=round(Para_front.StepSize*1.0); %the offset of step
    offset3=-round(Para_front.SizeofText/4); %the offset of y
    Screen('FillRect',window, Para_front.background);
    trigger_squ = Screen('MakeTexture', window,zeros([Para_Trigger.Size Para_Trigger.Size]));
    Screen('DrawTexture', window, trigger_squ,[],Para_Trigger.Location);
   
    %% Spontaneous
    [newXa0,newY1]=Screen('DrawText',window, 'Spontaneous', offset1, round(Para_front.StepSize)*1, Para_front.maxpixel);
    [newXa1,newY1]=Screen('DrawText',window, ' Time(min)=', newXa0, newY1, Para_front.maxpixel);
    [newXa2,newY1]=Screen('DrawText',window, num2str(Para_Spontaneous.Time/60/1000,'%3.1f'), newXa1, newY1, Para_front.maxpixel);
    [newXa3,newY1]=Screen('DrawText',window, '    ', newXa2, newY1, Para_front.maxpixel);
    [newXa4,newY1]=Screen('DrawText',window, 'Noise', newXa3, newY1, Para_front.maxpixel);

    FrontRect.Spontanous=round([offset1 newY1+offset3 newXa0 newY1+offset3+offset2]);
    FrontRect.SpontanousTime=round([newXa1 newY1+offset3 newXa2 newY1+offset3+offset2]);
    FrontRect.Noise=round([newXa3 newY1+offset3 newXa4 newY1+offset3+offset2]);

    % Receptive Field Local sparse Noise 4.65 degrees
    [newXa5,newY1]=Screen('DrawText',window, '    ', newXa4, newY1, Para_front.maxpixel);
    [newXa6,newY1]=Screen('DrawText',window, 'LocalSparse4', newXa5, newY1, Para_front.maxpixel);
    [newXa7,newY1]=Screen('DrawText',window, ' Displaydelay(s)=', newXa6, newY1, Para_front.maxpixel);
    [newXa8,newY1]=Screen('DrawText',window, num2str(Para_LocalSparseNoise4.Displaydelay/1000,'%3.1f'), newXa7, newY1, Para_front.maxpixel);
    [newXa9,newY1]=Screen('DrawText',window, ' Tbaseline(s)=', newXa8, newY1, Para_front.maxpixel);
    [newXa10,newY1]=Screen('DrawText',window, num2str(Para_LocalSparseNoise4.BaselineTime/1000,'%3.2f'), newXa9, newY1, Para_front.maxpixel);
    [newXa11,newY1]=Screen('DrawText',window, ' TSti(s)=', newXa10, newY1, Para_front.maxpixel);
    [newXa12,newY1]=Screen('DrawText',window, num2str(Para_LocalSparseNoise4.StimTime/1000,'%3.2f'), newXa11, newY1, Para_front.maxpixel);
    [newXa13,newY1]=Screen('DrawText',window, ' ISI(s)=', newXa12, newY1, Para_front.maxpixel);
    [newXa14,newY1]=Screen('DrawText',window, num2str(Para_LocalSparseNoise4.ISI/1000,'%3.2f'), newXa13, newY1, Para_front.maxpixel);
    FrontRect.LocalSparseNoise4=round([newXa5 newY1+offset3 newXa6 newY1+offset3+offset2]);
    FrontRect.LocalSparseNoise4_Displaydelay=round([newXa7 newY1+offset3 newXa8 newY1+offset3+offset2]);
    FrontRect.LocalSparseNoise4_Tbaseline=round([newXa9 newY1+offset3 newXa10 newY1+offset3+offset2]);
    FrontRect.LocalSparseNoise4_TSti=round([newXa11 newY1+offset3 newXa12 newY1+offset3+offset2]);
    FrontRect.LocalSparseNoise4_ISI=round([newXa13 newY1+offset3 newXa14 newY1+offset3+offset2]);

   
    %% Manual Bar
    [newXb0,newY2]=Screen('DrawText',window,'Manual Bar ',offset1,round(Para_front.StepSize)*2,Para_front.maxpixel);   
    FrontRect.ManBar=round([offset1 newY2+offset3 newXb0 newY2+offset3+offset2]);

    %% Intrinsic full screen
    [newXb1,newY2]=Screen('DrawText',window, '  IntrinsicDir', newXb0, newY2, Para_front.maxpixel);
    [newXb2,newY2]=Screen('DrawText',window, ' Repetition=', newXb1, newY2, Para_front.maxpixel);
    [newXb3,newY2]=Screen('DrawText',window, num2str(Para_Intrinsic.repeats,'%02d'), newXb2, newY2, Para_front.maxpixel);
    FrontRect.IntrinsicDir=round([newXb0 newY2+offset3 newXb1 newY2+offset3+offset2]);
    FrontRect.IntrinsicDirRepeat=round([newXb2 newY2+offset3 newXb3 newY2+offset3+offset2]);

    %% Receptive Field On and Off
    [newXb4,newY2]=Screen('DrawText',window, '  ON_OFF_RF_SH', newXb3, newY2, Para_front.maxpixel);
    [newXb5,newY2]=Screen('DrawText',window, ' Repetition=', newXb4, newY2, Para_front.maxpixel);
    [newXb6,newY2]=Screen('DrawText',window, num2str(Para_RFCourse.repetition,'%02d'), newXb5, newY2, Para_front.maxpixel);
    [newXb7,newY2]=Screen('DrawText',window, ' Displaydelay(s)=', newXb6, newY2, Para_front.maxpixel);
    [newXb8,newY2]=Screen('DrawText',window, num2str(Para_RFCourse.Displaydelay/1000,'%3.1f'), newXb7, newY2, Para_front.maxpixel);
    [newXb9,newY2]=Screen('DrawText',window, ' Tbaseline(s)=', newXb8, newY2, Para_front.maxpixel);
    [newXb10,newY2]=Screen('DrawText',window, num2str(Para_RFCourse.BaselineTime/1000,'%3.1f'), newXb9, newY2, Para_front.maxpixel);
    [newXb11,newY2]=Screen('DrawText',window, ' TSti(s)=', newXb10, newY2, Para_front.maxpixel);
    [newXb12,newY2]=Screen('DrawText',window, num2str(Para_RFCourse.StimTime/1000,'%3.1f'), newXb11, newY2, Para_front.maxpixel);
    [newXb13,newY2]=Screen('DrawText',window, ' ISI(s)=', newXb12, newY2, Para_front.maxpixel);
    [newXb14,newY2]=Screen('DrawText',window, num2str(Para_RFCourse.ISI/1000,'%3.1f'), newXb13, newY2, Para_front.maxpixel);
    FrontRect.OnOff=round([newXb3 newY2+offset3 newXb4 newY2+offset3+offset2]);
    FrontRect.OnOffReptition=round([newXb5 newY2+offset3 newXb6 newY2+offset3+offset2]);
    FrontRect.OnOffDisplaydelay=round([newXb7 newY2+offset3 newXb8 newY2+offset3+offset2]);
    FrontRect.OnOffTbaseline=round([newXb9 newY2+offset3 newXb10 newY2+offset3+offset2]);
    FrontRect.OnOffTSti=round([newXb11 newY2+offset3 newXb12 newY2+offset3+offset2]);
    FrontRect.OnOffISI=round([newXb13 newY2+offset3 newXb14 newY2+offset3+offset2]);
    
    
    %% Receptive field
    [newXc0,newY3]=Screen('DrawText',window, 'RFGrat_SH', offset1,round(Para_front.StepSize)*3,Para_front.maxpixel);
    [newXc1,newY3]=Screen('DrawText',window, '  ', newXc0, newY3, Para_front.maxpixel);
    [newXc2,newY3]=Screen('DrawText',window, '2nRFGrat_SH', newXc1, newY3, Para_front.maxpixel);
    [newXc3,newY3]=Screen('DrawText',window, ' Size=', newXc2, newY3, Para_front.maxpixel);
    [newXc4,newY3]=Screen('DrawText',window, num2str(Para_RFGrat.patchSize, '%02d'), newXc3, newY3, Para_front.maxpixel);
    [newXc5,newY3]=Screen('DrawText',window, ' Repetition=', newXc4, newY3, Para_front.maxpixel);
    [newXc6,newY3]=Screen('DrawText',window, num2str(Para_RFGrat.repetition,'%02d'), newXc5, newY3, Para_front.maxpixel);
    [newXc7,newY3]=Screen('DrawText',window, ' Displaydelay(s)=', newXc6, newY3, Para_front.maxpixel);
    [newXc8,newY3]=Screen('DrawText',window, num2str(Para_RFGrat.Displaydelay/1000,'%3.1f'), newXc7, newY3, Para_front.maxpixel);
    [newXc9,newY3]=Screen('DrawText',window, ' Tbaseline(s)=', newXc8, newY3, Para_front.maxpixel);
    [newXc10,newY3]=Screen('DrawText',window, num2str(Para_RFGrat.BaselineTime/1000,'%3.1f'), newXc9, newY3, Para_front.maxpixel);
    [newXc11,newY3]=Screen('DrawText',window, ' Tmoving(s)=', newXc10, newY3, Para_front.maxpixel);
    [newXc12,newY3]=Screen('DrawText',window, num2str(Para_RFGrat.StimTime/1000,'%3.1f'), newXc11, newY3, Para_front.maxpixel);
    [newXc13,newY3]=Screen('DrawText',window, ' ISI(s)=', newXc12, newY3, Para_front.maxpixel);
    [newXc14,newY3]=Screen('DrawText',window, num2str(Para_RFGrat.ISI/1000,'%3.1f'), newXc13, newY3, Para_front.maxpixel);
    FrontRect.RFGrat=round([offset1 newY3+offset3 newXc0 newY3+offset3+offset2]);
    FrontRect.SecondRFGrat=round([newXc1 newY3+offset3 newXc2 newY3+offset3+offset2]);
    FrontRect.RFPatchSize=round([newXc3 newY3+offset3 newXc4 newY3+offset3+offset2]);
    FrontRect.RFReptition=round([newXc5 newY3+offset3 newXc6 newY3+offset3+offset2]);
    FrontRect.RFDisplaydelay=round([newXc7 newY3+offset3 newXc8 newY3+offset3+offset2]);
    FrontRect.RFTbaseline=round([newXc9 newY3+offset3 newXc10 newY3+offset3+offset2]);
    FrontRect.RFTmoving=round([newXc11 newY3+offset3 newXc12 newY3+offset3+offset2]);
    FrontRect.RFISI=round([newXc13 newY3+offset3 newXc14 newY3+offset3+offset2]);

    
    %% Secondary receptive field
    % secondReceptiveFieldMapping_2p(window)
    [newXd0,newY4]=Screen('DrawText',window, 'RF6x10_X[0,10]=', offset1,round(Para_front.StepSize)*4,Para_front.maxpixel);
    [newXd1,newY4]=Screen('DrawText',window, num2str(RF_X, '%3.1f'), newXd0, newY4,Para_front.maxpixel);
    [newXd2,newY4]=Screen('DrawText',window, ' RF6x10_Y[0,6]=', newXd1,newY4,Para_front.maxpixel);
    [newXd3,newY4]=Screen('DrawText',window, num2str(RF_Y, '%3.1f'), newXd2, newY4,Para_front.maxpixel);
    [newXd4,newY4]=Screen('DrawText',window, '   center = X_5, Y_3', newXd3, newY4,Para_front.maxpixel);
    FrontRect.RF_X=round([newXd0 newY4+offset3 newXd1 newY4+offset3+offset2]);
    FrontRect.RF_Y=round([newXd2 newY4+offset3 newXd3 newY4+offset3+offset2]);
    
    
    %% Moving Square Bar 
    [newXe0,newY5]=Screen('DrawText',window, 'MVSquBar_SH', offset1,round(Para_front.StepSize)*5,Para_front.maxpixel);
    [newXe1,newY5]=Screen('DrawText',window, ' Stimulation=', newXe0, newY5, Para_front.maxpixel);
    [newXe2,newY5]=Screen('DrawText',window, Para_MoveSquBar.StimulationFiles{Para_MoveSquBar.StimulationFile}, newXe1, newY5, Para_front.maxpixel);
    [newXe3,newY5]=Screen('DrawText',window, '', newXe2, newY5, Para_front.maxpixel);
    [newXe4,newY5]=Screen('DrawText',window, '', newXe3, newY5, Para_front.maxpixel);
    [newXe5,newY5]=Screen('DrawText',window,' Speed=',newXe4,newY5,Para_front.maxpixel);
    [newXe6,newY5]=Screen('DrawText',window,num2str(Para_MoveSquBar.Speed,'%02d'),newXe5,newY5,Para_front.maxpixel);
    [newXe7,newY5]=Screen('DrawText',window,' Width=',newXe6,newY5,Para_front.maxpixel);
    [newXe8,newY5]=Screen('DrawText',window,num2str(Para_MoveSquBar.WidthDeg,'%2.1f'),newXe7,newY5,Para_front.maxpixel);
    [newXe9,newY5]=Screen('DrawText',window,'',newXe8,newY5,Para_front.maxpixel);
    [newXe10,newY5]=Screen('DrawText',window,'',newXe9,newY5,Para_front.maxpixel);
    [newXe11,newY5]=Screen('DrawText',window,'',newXe10,newY5,Para_front.maxpixel);
    [newXe12,newY5]=Screen('DrawText',window,' Contrast=',newXe11,newY5,Para_front.maxpixel);
    [newXe13,newY5]=Screen('DrawText',window,num2str(Para_MoveSquBar.Contrast,'%1.2f'),newXe12,newY5,Para_front.maxpixel);
    [newXe14,newY5]=Screen('DrawText',window,' (for Grey background only)',newXe13,newY5,Para_front.maxpixel);
    [newXe15,newY5]=Screen('DrawText',window,'',newXe14,newY5,Para_front.maxpixel);
    [newXe16,newY5]=Screen('DrawText',window,' Bar=',newXe15,newY5,Para_front.maxpixel);
    if Para_MoveSquBar.ContrastFlag
        [newXe17,newY5]=Screen('DrawText',window,'Bright',newXe16,newY5,Para_front.maxpixel);
    else
        [newXe17,newY5]=Screen('DrawText',window,'Dark',newXe16,newY5,Para_front.maxpixel);
    end
    [newXe18,newY5]=Screen('DrawText',window,' Background=',newXe17,newY5,Para_front.maxpixel);
    if Para_MoveSquBar.Background
        [newXe19,newY5]=Screen('DrawText',window,'Grey',newXe18,newY5,Para_front.maxpixel);
    else
        [newXe19,newY5]=Screen('DrawText',window,'Black',newXe18,newY5,Para_front.maxpixel);
    end
    [newXe20,newY5]=Screen('DrawText',window,' Displaydelay(s)=',newXe19,newY5,Para_front.maxpixel);
    [newXe21,newY5]=Screen('DrawText',window,num2str(Para_MoveSquBar.Displaydelay/1000,'%3.1f'),newXe20,newY5,Para_front.maxpixel);
    [newXe22,newY5]=Screen('DrawText',window,' Tbaseline(s)=',newXe21,newY5,Para_front.maxpixel);
    [newXe23,newY5]=Screen('DrawText',window,num2str(Para_MoveSquBar.BaselineTrialTime/1000,'%3.1f'),newXe22,newY5,Para_front.maxpixel);
    [newXe24,newY5]=Screen('DrawText',window,' ISI(s)=',newXe23,newY5,Para_front.maxpixel);
    [newXe25,newY5]=Screen('DrawText',window,num2str(Para_MoveSquBar.ISI/1000,'%3.1f'),newXe24,newY5,Para_front.maxpixel);
        
    FrontRect.MoveSquBar=round([offset1 newY5+offset3 newXe0 newY5+offset3+offset2]);
    FrontRect.MoveSquBarStimulation=round([newXe1 newY5+offset3 newXe2 newY5+offset3+offset2]);
    FrontRect.MoveSquBarSeqIndex=round([newXe3 newY5+offset3 newXe4 newY5+offset3+offset2]);
    FrontRect.MoveSquBarSpeed=round([newXe5 newY5+offset3 newXe6 newY5+offset3+offset2]);
    FrontRect.MoveSquBarWidth=round([newXe7 newY5+offset3 newXe8 newY5+offset3+offset2]);
    FrontRect.MoveSquBarContrast=round([newXe12 newY5+offset3 newXe13 newY5+offset3+offset2]);
    FrontRect.MoveSquBarBarcolor=round([newXe16 newY5+offset3 newXe17 newY5+offset3+offset2]);
    FrontRect.MoveSquBarBackground=round([newXe18 newY5+offset3 newXe19 newY5+offset3+offset2]);   
    FrontRect.MoveSquBarDisplaydelay=round([newXe20 newY5+offset3 newXe21 newY5+offset3+offset2]);   
    FrontRect.MoveSquBarTbaseline=round([newXe22 newY5+offset3 newXe23 newY5+offset3+offset2]);   
    FrontRect.MoveSquBarISI=round([newXe24 newY5+offset3 newXe25 newY5+offset3+offset2]);   
    

    %% Moving Edge
    [newXg0,newY7]=Screen('DrawText',window, 'MV Edge', offset1,round(Para_front.StepSize)*7,Para_front.maxpixel);
    [newXg1,newY7]=Screen('DrawText',window, ':#=', newXg0, newY7, Para_front.maxpixel);
    [newXg2,newY7]=Screen('DrawText',window, num2str(Para_MoveEdge.Repetition,'%02d'), newXg1, newY7, Para_front.maxpixel);
    [newXg3,newY7]=Screen('DrawText',window,' Spd=',newXg2,newY7,Para_front.maxpixel);
    [newXg4,newY7]=Screen('DrawText',window,num2str(Para_MoveEdge.Speed,'%02d'),newXg3,newY7,Para_front.maxpixel);
    [newXg5,newY7]=Screen('DrawText',window,' Full=',newXg4,newY7,Para_front.maxpixel);
    if Para_MoveEdge.FullFlag
        [newXg6,newY7]=Screen('DrawText',window,'Y',newXg5,newY7,Para_front.maxpixel);
    else
        [newXg6,newY7]=Screen('DrawText',window,'N',newXg5,newY7,Para_front.maxpixel);
    end
    
    FrontRect.MoveEdge=round([offset1 newY7+offset3 newXg0 newY7+offset3+offset2]);
    FrontRect.MoveEdgeRep=round([newXg1 newY7+offset3 newXg2 newY7+offset3+offset2]);
    FrontRect.MoveEdgeSp=round([newXg3 newY7+offset3 newXg4 newY7+offset3+offset2]);
    FrontRect.MoveEdgeFullFlag=round([newXg5 newY7+offset3 newXg6 newY7+offset3+offset2]);

    %% Moving Square Gratings
    [newXh0,newY8]=Screen('DrawText',window, 'MV SquGrat', offset1,round(Para_front.StepSize)*8,Para_front.maxpixel);  
    [newXh1,newY8]=Screen('DrawText',window, ':SpatFQ=', newXh0,newY8,Para_front.maxpixel);
    [newXh2,newY8]=Screen('DrawText',window, num2str(Para_MoveSquGrat.SpatFreqDeg,'%4.3f') , newXh1, newY8, Para_front.maxpixel);
    [newXh3,newY8]=Screen('DrawText',window, ' Duty-cycle=', newXh2, newY8, Para_front.maxpixel);
    [newXh4,newY8]=Screen('DrawText',window, num2str(Para_MoveSquGrat.DutyCycle,'%02d'), newXh3, newY8, Para_front.maxpixel);
    [newXh5,newY8]=Screen('DrawText',window, '% Stimulation=', newXh4, newY8, Para_front.maxpixel);
    [newXh6,newY8]=Screen('DrawText',window, Para_MoveSquGrat.StimulationFiles{Para_MoveSquGrat.StimulationFile}, newXh5, newY8, Para_front.maxpixel);
    [newXh7,newY8]=Screen('DrawText',window, ' Full=', newXh6, newY8, Para_front.maxpixel);
    if Para_MoveSquGrat.FullFlag
        [newXh8,newY8]=Screen('DrawText',window,'Y',newXh7,newY8,Para_front.maxpixel);
    else
        [newXh8,newY8]=Screen('DrawText',window,'N',newXh7,newY8,Para_front.maxpixel);
    end
    [newXh9,newY8]=Screen('DrawText',window, ' TempFQ=', newXh8, newY8, Para_front.maxpixel);
  	[newXh10,newY8]=Screen('DrawText',window, num2str(Para_MoveSquGrat.TempFreq,'%3.1f'), newXh9, newY8, Para_front.maxpixel);    
    [newXh11,newY8]=Screen('DrawText',window, ' Contrast=', newXh10, newY8, Para_front.maxpixel);
  	[newXh12,newY8]=Screen('DrawText',window, num2str(Para_MoveSquGrat.Contrast,'%4.2f'), newXh11, newY8, Para_front.maxpixel);    
    [newXh13,newY8]=Screen('DrawText',window, ' Displaydelay(s)=', newXh12, newY8, Para_front.maxpixel);
  	[newXh14,newY8]=Screen('DrawText',window, num2str(Para_MoveSquGrat.Displaydelay/1000,'%3.1f'), newXh13, newY8, Para_front.maxpixel);    
    [newXh15,newY8]=Screen('DrawText',window, ' Tbaseline(s)=', newXh14, newY8, Para_front.maxpixel);
  	[newXh16,newY8]=Screen('DrawText',window, num2str(Para_MoveSquGrat.BaselineTrialTime/1000,'%3.1f'), newXh15, newY8, Para_front.maxpixel);    
    [newXh17,newY8]=Screen('DrawText',window, ' Tmoving(s)=', newXh16, newY8, Para_front.maxpixel);
  	[newXh18,newY8]=Screen('DrawText',window, num2str(Para_MoveSquGrat.Tmoving/1000,'%3.1f'), newXh17, newY8, Para_front.maxpixel);    
    [newXh19,newY8]=Screen('DrawText',window, ' ISI(s)=', newXh18, newY8, Para_front.maxpixel);
  	[newXh20,newY8]=Screen('DrawText',window, num2str(Para_MoveSquGrat.ISI/1000,'%3.1f'), newXh19, newY8, Para_front.maxpixel);    
    
    FrontRect.MoveSquGrat=round([offset1 newY8+offset3 newXh0 newY8+offset3+offset2]);
    FrontRect.MoveSquGratSpatFreq=round([newXh1 newY8+offset3 newXh2 newY8+offset3+offset2]);
    FrontRect.MoveSquGratDutyCycle=round([newXh3 newY8+offset3 newXh4 newY8+offset3+offset2]);
    FrontRect.MoveSquGratStimulation=round([newXh5 newY8+offset3 newXh6 newY8+offset3+offset2]);
    FrontRect.MoveSquGratFullFlag=round([newXh7 newY8+offset3 newXh8 newY8+offset3+offset2]);
    FrontRect.MoveSquGratTempFreq=round([newXh9 newY8+offset3 newXh10 newY8+offset3+offset2]);
    FrontRect.MoveSquGratContrast=round([newXh11 newY8+offset3 newXh12 newY8+offset3+offset2]);
    FrontRect.MoveSquGratDisplaydelay=round([newXh13 newY8+offset3 newXh14 newY8+offset3+offset2]);
    FrontRect.MoveSquGratBaselineTrialTime=round([newXh15 newY8+offset3 newXh16 newY8+offset3+offset2]);
    FrontRect.MoveSquGratTmoving=round([newXh17 newY8+offset3 newXh18 newY8+offset3+offset2]);
    FrontRect.MoveSquGratISI=round([newXh19 newY8+offset3 newXh20 newY8+offset3+offset2]);
    

    %% Moving SinGratings
    [newXj0,newY10]=Screen('DrawText',window,'MVSinGrat_OriDir_SH',offset1,round(Para_front.StepSize)*10,Para_front.maxpixel);
    [newXj1,newY10]=Screen('DrawText',window,' Stimulation=',newXj0,newY10,Para_front.maxpixel);
    [newXj2,newY10]=Screen('DrawText',window, Para_MvSinGrat.StimulationFiles{Para_MvSinGrat.StimulationFile},newXj1,newY10,Para_front.maxpixel);
    [newXj3,newY10]=Screen('DrawText',window,' SpatFreQ=',newXj2,newY10,Para_front.maxpixel);
    [newXj4,newY10]=Screen('DrawText',window, num2str(Para_MvSinGrat.SpatFreqDeg,'%4.3f'),newXj3,newY10,Para_front.maxpixel);
    [newXj5,newY10]=Screen('DrawText',window,' TempFreQ=',newXj4,newY10,Para_front.maxpixel);
    [newXj6,newY10]=Screen('DrawText',window, num2str(Para_MvSinGrat.TempFreq, '%3.1f'),newXj5,newY10,Para_front.maxpixel);
    [newXj7,newY10]=Screen('DrawText',window, ' Contrast=',newXj6,newY10,Para_front.maxpixel);
    [newXj8,newY10]=Screen('DrawText',window, num2str(Para_MvSinGrat.Contrast,'%4.2f'),newXj7,newY10,Para_front.maxpixel);
    [newXj9,newY10]=Screen('DrawText',window, ' Size=',newXj8,newY10,Para_front.maxpixel);
    [newXj10,newY10]=Screen('DrawText',window, num2str(Para_MvSinGrat.Size,'%02d'),newXj9,newY10,Para_front.maxpixel);
    [newXj11,newY10]=Screen('DrawText',window,'',newXj10,newY10,Para_front.maxpixel);
    if Para_MvSinGrat.FullFlag
        [newXj12,newY10]=Screen('DrawText',window,'Full',newXj11,newY10,Para_front.maxpixel);
    else
        [newXj12,newY10]=Screen('DrawText',window,'Mask',newXj11,newY10,Para_front.maxpixel);
    end
    [newXj13,newY10]=Screen('DrawText',window,' Displaydelay(s)=',newXj12,newY10,Para_front.maxpixel);
    [newXj14,newY10]=Screen('DrawText',window, num2str(Para_MvSinGrat.Displaydelay/1000,'%3.1f'),newXj13,newY10,Para_front.maxpixel);
    [newXj15,newY10]=Screen('DrawText',window, ' Tbaseline(s)=',newXj14,newY10,Para_front.maxpixel);
    [newXj16,newY10]=Screen('DrawText',window, num2str(Para_MvSinGrat.BaselineTrialTime/1000,'%3.1f'),newXj15,newY10,Para_front.maxpixel);
    [newXj17,newY10]=Screen('DrawText',window, ' Tmoving(s)=',newXj16,newY10,Para_front.maxpixel);
    [newXj18,newY10]=Screen('DrawText',window, num2str(Para_MvSinGrat.Tmoving/1000,'%3.1f'),newXj17,newY10,Para_front.maxpixel);
    [newXj19,newY10]=Screen('DrawText',window, ' ISI(s)=',newXj18,newY10,Para_front.maxpixel);
    [newXj20,newY10]=Screen('DrawText',window, num2str(Para_MvSinGrat.ISI/1000,'%3.1f'),newXj19,newY10,Para_front.maxpixel);
    [newXj21,newY10]=Screen('DrawText',window, ' ',newXj20,newY10,Para_front.maxpixel);
    [newXj22,newY10]=Screen('DrawText',window, ' 2ndMV_SinGrat_SH',newXj21,newY10,Para_front.maxpixel);

    
    FrontRect.MoveSinGrat=round([offset1 newY10+offset3 newXj0 newY10+offset3+offset2]);
    FrontRect.MvSinGratStimulation=round([newXj1 newY10+offset3 newXj2 newY10+offset3+offset2]);
    FrontRect.MvSinGratSF=round([newXj3 newY10+offset3 newXj4 newY10+offset3+offset2]);
    FrontRect.MvSinGratTF=round([newXj5 newY10+offset3 newXj6 newY10+offset3+offset2]);
    FrontRect.MvSinGratContrast=round([newXj7 newY10+offset3 newXj8 newY10+offset3+offset2]);
    FrontRect.MvSinGratSize=round([newXj9 newY10+offset3 newXj10 newY10+offset3+offset2]);
    FrontRect.MvSinGratFullFlag=round([newXj11 newY10+offset3 newXj12 newY10+offset3+offset2]);
    FrontRect.MvSinGratDisplaydelay=round([newXj13 newY10+offset3 newXj14 newY10+offset3+offset2]);
    FrontRect.MvSinGratTbaseline=round([newXj15 newY10+offset3 newXj16 newY10+offset3+offset2]);
    FrontRect.MvSinGratTmoving=round([newXj17 newY10+offset3 newXj18 newY10+offset3+offset2]);
    FrontRect.MvSinGratISI=round([newXj19 newY10+offset3 newXj20 newY10+offset3+offset2]);
    FrontRect.secondMoveSinGrat=round([newXj21 newY10+offset3 newXj22 newY10+offset3+offset2]);

    
    %% Moving Sinosoidal grating with size tuning 
    [newXk0,newY11]=Screen('DrawText',window, 'MVSinGrat_Size_SH', offset1, round(Para_front.StepSize)*11, Para_front.maxpixel);
    [newXk1,newY11]=Screen('DrawText',window, ' Stimulation=', newXk0, newY11, Para_front.maxpixel);
    [newXk2,newY11]=Screen('DrawText',window, Para_MvSinGratSize.StimulationFiles{Para_MvSinGratSize.StimulationFile}, newXk1, newY11, Para_front.maxpixel);
    [newXk3,newY11]=Screen('DrawText',window, ' Angle=', newXk2, newY11, Para_front.maxpixel);
    [newXk4,newY11]=Screen('DrawText',window, num2str(Para_MvSinGratSize.Angle,'%02d'), newXk3, newY11, Para_front.maxpixel);
    [newXk5,newY11]=Screen('DrawText',window,' SpatFreQ=',newXk4,newY11,Para_front.maxpixel);
    [newXk6,newY11]=Screen('DrawText',window,num2str(Para_MvSinGratSize.SpatFreqDeg,'%4.3f'),newXk5,newY11,Para_front.maxpixel);
    [newXk7,newY11]=Screen('DrawText',window,' TempFreQ=',newXk6,newY11,Para_front.maxpixel);
    [newXk8,newY11]=Screen('DrawText',window,num2str(Para_MvSinGratSize.TempFreq,'%3.1f'),newXk7,newY11,Para_front.maxpixel);
    [newXk9,newY11]=Screen('DrawText',window,' Contrast=',newXk8,newY11,Para_front.maxpixel);
    [newXk10,newY11]=Screen('DrawText',window,num2str(Para_MvSinGratSize.Contrast,'%3.2f'),newXk9,newY11,Para_front.maxpixel);
    [newXk11,newY11]=Screen('DrawText',window,' Displaydelay(s)=',newXk10,newY11,Para_front.maxpixel);
    [newXk12,newY11]=Screen('DrawText',window,num2str(Para_MvSinGratSize.Displaydelay/1000,'%3.1f'),newXk11,newY11,Para_front.maxpixel);
    [newXk13,newY11]=Screen('DrawText',window,' Tbaseline(s)=',newXk12,newY11,Para_front.maxpixel);
    [newXk14,newY11]=Screen('DrawText',window,num2str(Para_MvSinGratSize.BaselineTrialTime/1000,'%3.1f'),newXk13,newY11,Para_front.maxpixel);
    [newXk15,newY11]=Screen('DrawText',window,' Tmoving(s)=',newXk14,newY11,Para_front.maxpixel);
    [newXk16,newY11]=Screen('DrawText',window,num2str(Para_MvSinGratSize.Tmoving/1000,'%3.1f'),newXk15,newY11,Para_front.maxpixel);
    [newXk17,newY11]=Screen('DrawText',window,' ISI(s)=',newXk16,newY11,Para_front.maxpixel);
    [newXk18,newY11]=Screen('DrawText',window,num2str(Para_MvSinGratSize.ISI/1000,'%3.1f'),newXk17,newY11,Para_front.maxpixel);
    [newXk19,newY11]=Screen('DrawText',window, ' ',newXk18,newY11,Para_front.maxpixel);
    [newXk20,newY11]=Screen('DrawText',window, ' 2ndMVSinGrat_Size_SH',newXk19,newY11,Para_front.maxpixel);
    
    FrontRect.MoveSinGrat_Size=round([offset1 newY11+offset3 newXk0 newY11+offset3+offset2]);
    FrontRect.MoveSinGrat_SizeStimulation=round([newXk1 newY11+offset3 newXk2 newY11+offset3+offset2]);
    FrontRect.MoveSinGrat_SizeAngle=round([newXk3 newY11+offset3 newXk4 newY11+offset3+offset2]);
    FrontRect.MoveSinGrat_SizeSpatFreq=round([newXk5 newY11+offset3 newXk6 newY11+offset3+offset2]);
    FrontRect.MoveSinGrat_SizeTempFreq=round([newXk7 newY11+offset3 newXk8 newY11+offset3+offset2]);
    FrontRect.MoveSinGrat_SizeContrast=round([newXk9 newY11+offset3 newXk10 newY11+offset3+offset2]);
    FrontRect.MoveSinGrat_SizeDisplaydelay=round([newXk11 newY11+offset3 newXk12 newY11+offset3+offset2]);
    FrontRect.MoveSinGrat_SizeBaselineTrialTime=round([newXk13 newY11+offset3 newXk14 newY11+offset3+offset2]);
    FrontRect.MoveSinGrat_SizeTmoving=round([newXk15 newY11+offset3 newXk16 newY11+offset3+offset2]);
    FrontRect.MoveSinGrat_SizeISI=round([newXk17 newY11+offset3 newXk18 newY11+offset3+offset2]);
    FrontRect.secondMoveSinGrat_Size=round([newXk19 newY11+offset3 newXk20 newY11+offset3+offset2]);

    
    %% Moving Sinosoidal grating with Contrast tuning 
    [newXL0,newY12]=Screen('DrawText',window, 'MVSinGrat_Contrast_SH', offset1, round(Para_front.StepSize)*12, Para_front.maxpixel);
    [newXL1,newY12]=Screen('DrawText',window, ' Stimulation=', newXL0, newY12, Para_front.maxpixel);
    [newXL2,newY12]=Screen('DrawText',window, Para_MvSinGratContrast.StimulationFiles{Para_MvSinGratContrast.StimulationFile}, newXL1, newY12, Para_front.maxpixel);
    [newXL3,newY12]=Screen('DrawText',window, ' Angle=', newXL2, newY12, Para_front.maxpixel);
    [newXL4,newY12]=Screen('DrawText',window, num2str(Para_MvSinGratContrast.Angle,'%02d'), newXL3, newY12, Para_front.maxpixel);
    [newXL5,newY12]=Screen('DrawText',window,' SpatFreQ=',newXL4,newY12,Para_front.maxpixel);
    [newXL6,newY12]=Screen('DrawText',window,num2str(Para_MvSinGratContrast.SpatFreqDeg,'%4.3f'),newXL5,newY12,Para_front.maxpixel);
    [newXL7,newY12]=Screen('DrawText',window,' TempFreQ=',newXL6,newY12,Para_front.maxpixel);
    [newXL8,newY12]=Screen('DrawText',window,num2str(Para_MvSinGratContrast.TempFreq,'%3.1f'),newXL7,newY12,Para_front.maxpixel);
    [newXL9,newY12]=Screen('DrawText',window,' Size=',newXL8,newY12,Para_front.maxpixel);
    [newXL10,newY12]=Screen('DrawText',window,num2str(Para_MvSinGratContrast.Size,'%02d'),newXL9,newY12,Para_front.maxpixel);
    if Para_MvSinGratContrast.FullFlag
        [newXL11,newY12]=Screen('DrawText',window,'Full',newXL10,newY12,Para_front.maxpixel);
    else
        [newXL11,newY12]=Screen('DrawText',window,'Mask',newXL10,newY12,Para_front.maxpixel);
    end
    [newXL12,newY12]=Screen('DrawText',window,' Displaydelay(s)=',newXL11,newY12,Para_front.maxpixel);
    [newXL13,newY12]=Screen('DrawText',window,num2str(Para_MvSinGratContrast.Displaydelay/1000,'%3.1f'),newXL12,newY12,Para_front.maxpixel);
    [newXL14,newY12]=Screen('DrawText',window,' Tbaseline(s)=',newXL13,newY12,Para_front.maxpixel);
    [newXL15,newY12]=Screen('DrawText',window,num2str(Para_MvSinGratContrast.BaselineTrialTime/1000,'%3.1f'),newXL14,newY12,Para_front.maxpixel);
    [newXL16,newY12]=Screen('DrawText',window,' Tmoving(s)=',newXL15,newY12,Para_front.maxpixel);
    [newXL17,newY12]=Screen('DrawText',window,num2str(Para_MvSinGratContrast.Tmoving/1000,'%3.1f'),newXL16,newY12,Para_front.maxpixel);
    [newXL18,newY12]=Screen('DrawText',window,' ISI(s)=',newXL17,newY12,Para_front.maxpixel);
    [newXL19,newY12]=Screen('DrawText',window,num2str(Para_MvSinGratContrast.ISI/1000,'%3.1f'),newXL18,newY12,Para_front.maxpixel);
    [newXL20,newY12]=Screen('DrawText',window, ' ',newXL19,newY12,Para_front.maxpixel);
    [newXL21,newY12]=Screen('DrawText',window, ' 2ndMVSinGrat_Contrast_SH (66s to start)',newXL20,newY12,Para_front.maxpixel);
    
    FrontRect.MoveSinGrat_Ctr=round([offset1 newY12+offset3 newXL0 newY12+offset3+offset2]);
    FrontRect.MoveSinGrat_CtrStimulation=round([newXL1 newY12+offset3 newXL2 newY12+offset3+offset2]);
    FrontRect.MoveSinGrat_CtrAngle=round([newXL3 newY12+offset3 newXL4 newY12+offset3+offset2]);
    FrontRect.MoveSinGrat_CtrSpatFreq=round([newXL5 newY12+offset3 newXL6 newY12+offset3+offset2]);
    FrontRect.MoveSinGrat_CtrTempFreq=round([newXL7 newY12+offset3 newXL8 newY12+offset3+offset2]);
    FrontRect.MoveSinGrat_CtrSize=round([newXL9 newY12+offset3 newXL10 newY12+offset3+offset2]);
    FrontRect.MoveSinGrat_CtrFullFlag=round([newXL10 newY12+offset3 newXL11 newY12+offset3+offset2]);
    FrontRect.MoveSinGrat_CtrDisplaydelay=round([newXL12 newY12+offset3 newXL13 newY12+offset3+offset2]);
    FrontRect.MoveSinGrat_CtrBaselineTrialTime=round([newXL14 newY12+offset3 newXL15 newY12+offset3+offset2]);
    FrontRect.MoveSinGrat_CtrTmoving=round([newXL16 newY12+offset3 newXL17 newY12+offset3+offset2]);
    FrontRect.MoveSinGrat_CtrISI=round([newXL18 newY12+offset3 newXL19 newY12+offset3+offset2]);
    FrontRect.secondMoveSinGrat_Ctr=round([newXL20 newY12+offset3 newXL21 newY12+offset3+offset2]);

    %% Moving Sinosoidal grating with Spatial Frequency tuning 
    [newXM0,newY13]=Screen('DrawText',window, 'MVSinGrat_SF_SH(37s for Full to start)', offset1, round(Para_front.StepSize)*13, Para_front.maxpixel);
    [newXM1,newY13]=Screen('DrawText',window, ' Stimulation=', newXM0, newY13, Para_front.maxpixel);
    [newXM2,newY13]=Screen('DrawText',window, Para_MvSinGratSF.StimulationFiles{Para_MvSinGratSF.StimulationFile}, newXM1, newY13, Para_front.maxpixel);
    [newXM3,newY13]=Screen('DrawText',window, ' Angle=', newXM2, newY13, Para_front.maxpixel);
    [newXM4,newY13]=Screen('DrawText',window, num2str(Para_MvSinGratSF.Angle,'%02d'), newXM3, newY13, Para_front.maxpixel);
    [newXM5,newY13]=Screen('DrawText',window,' Contrast=',newXM4,newY13,Para_front.maxpixel);
    [newXM6,newY13]=Screen('DrawText',window,num2str(Para_MvSinGratSF.Contrast,'%3.2f'),newXM5,newY13,Para_front.maxpixel);
    [newXM7,newY13]=Screen('DrawText',window,' TempFreQ=',newXM6,newY13,Para_front.maxpixel);
    [newXM8,newY13]=Screen('DrawText',window,num2str(Para_MvSinGratSF.TempFreq,'%3.1f'),newXM7,newY13,Para_front.maxpixel);
    [newXM9,newY13]=Screen('DrawText',window,' Size=',newXM8,newY13,Para_front.maxpixel);
    [newXM10,newY13]=Screen('DrawText',window,num2str(Para_MvSinGratSF.Size,'%02d'),newXM9,newY13,Para_front.maxpixel);
    if Para_MvSinGratSF.FullFlag
        [newXM11,newY13]=Screen('DrawText',window,'Full',newXM10,newY13,Para_front.maxpixel);
    else
        [newXM11,newY13]=Screen('DrawText',window,'Mask',newXM10,newY13,Para_front.maxpixel);
    end
    [newXM12,newY13]=Screen('DrawText',window,' Displaydelay(s)=',newXM11,newY13,Para_front.maxpixel);
    [newXM13,newY13]=Screen('DrawText',window,num2str(Para_MvSinGratSF.Displaydelay/1000,'%3.1f'),newXM12,newY13,Para_front.maxpixel);
    [newXM14,newY13]=Screen('DrawText',window,' Tbaseline(s)=',newXM13,newY13,Para_front.maxpixel);
    [newXM15,newY13]=Screen('DrawText',window,num2str(Para_MvSinGratSF.BaselineTrialTime/1000,'%3.1f'),newXM14,newY13,Para_front.maxpixel);
    [newXM16,newY13]=Screen('DrawText',window,' Tmoving(s)=',newXM15,newY13,Para_front.maxpixel);
    [newXM17,newY13]=Screen('DrawText',window,num2str(Para_MvSinGratSF.Tmoving/1000,'%3.1f'),newXM16,newY13,Para_front.maxpixel);
    [newXM18,newY13]=Screen('DrawText',window,' ISI(s)=',newXM17,newY13,Para_front.maxpixel);
    [newXM19,newY13]=Screen('DrawText',window,num2str(Para_MvSinGratSF.ISI/1000,'%3.1f'),newXM18,newY13,Para_front.maxpixel);
    [newXM20,newY13]=Screen('DrawText',window, ' ',newXM19,newY13,Para_front.maxpixel);
    [newXM21,newY13]=Screen('DrawText',window, ' 2ndMVSinGrat_SF_SH(48s to start)',newXM20,newY13,Para_front.maxpixel);
    
    FrontRect.MoveSinGrat_SF=round([offset1 newY13+offset3 newXM0 newY13+offset3+offset2]);
    FrontRect.MoveSinGrat_SFStimulation=round([newXM1 newY13+offset3 newXM2 newY13+offset3+offset2]);
    FrontRect.MoveSinGrat_SFAngle=round([newXM3 newY13+offset3 newXM4 newY13+offset3+offset2]);
    FrontRect.MoveSinGrat_SFContrast=round([newXM5 newY13+offset3 newXM6 newY13+offset3+offset2]);
    FrontRect.MoveSinGrat_SFTempFreq=round([newXM7 newY13+offset3 newXM8 newY13+offset3+offset2]);
    FrontRect.MoveSinGrat_SFSize=round([newXM9 newY13+offset3 newXM10 newY13+offset3+offset2]);
    FrontRect.MoveSinGrat_SFFullFlag=round([newXM10 newY13+offset3 newXM11 newY13+offset3+offset2]);
    FrontRect.MoveSinGrat_SFDisplaydelay=round([newXM12 newY13+offset3 newXM13 newY13+offset3+offset2]);
    FrontRect.MoveSinGrat_SFBaselineTrialTime=round([newXM14 newY13+offset3 newXM15 newY13+offset3+offset2]);
    FrontRect.MoveSinGrat_SFTmoving=round([newXM16 newY13+offset3 newXM17 newY13+offset3+offset2]);
    FrontRect.MoveSinGrat_SFISI=round([newXM18 newY13+offset3 newXM19 newY13+offset3+offset2]);
    FrontRect.secondMoveSinGrat_SF=round([newXM20 newY13+offset3 newXM21 newY13+offset3+offset2]);
    
    %% Moving Sinosoidal grating with Temporal Frequency tuning 
    [newXN0,newY14]=Screen('DrawText',window, 'MVSinGrat_TF_SH', offset1, round(Para_front.StepSize)*14, Para_front.maxpixel);
    [newXN1,newY14]=Screen('DrawText',window, ' Stimulation=', newXN0, newY14, Para_front.maxpixel);
    [newXN2,newY14]=Screen('DrawText',window, Para_MvSinGratTF.StimulationFiles{Para_MvSinGratTF.StimulationFile}, newXN1, newY14, Para_front.maxpixel);
    [newXN3,newY14]=Screen('DrawText',window, ' Angle=', newXN2, newY14, Para_front.maxpixel);
    [newXN4,newY14]=Screen('DrawText',window, num2str(Para_MvSinGratTF.Angle,'%02d'), newXN3, newY14, Para_front.maxpixel);
    [newXN5,newY14]=Screen('DrawText',window,' Contrast=',newXN4,newY14,Para_front.maxpixel);
    [newXN6,newY14]=Screen('DrawText',window,num2str(Para_MvSinGratTF.Contrast,'%3.2f'),newXN5,newY14,Para_front.maxpixel);
    [newXN7,newY14]=Screen('DrawText',window,' SpatFreQ=',newXN6,newY14,Para_front.maxpixel);
    [newXN8,newY14]=Screen('DrawText',window,num2str(Para_MvSinGratTF.SpatFreq,'%3.2f'),newXN7,newY14,Para_front.maxpixel);
    [newXN9,newY14]=Screen('DrawText',window,' Size=',newXN8,newY14,Para_front.maxpixel);
    [newXN10,newY14]=Screen('DrawText',window,num2str(Para_MvSinGratTF.Size,'%02d'),newXN9,newY14,Para_front.maxpixel);
    if Para_MvSinGratTF.FullFlag
        [newXN11,newY14]=Screen('DrawText',window,'Full',newXN10,newY14,Para_front.maxpixel);
    else
        [newXN11,newY14]=Screen('DrawText',window,'Mask',newXN10,newY14,Para_front.maxpixel);
    end
    [newXN12,newY14]=Screen('DrawText',window,' Displaydelay(s)=',newXN11,newY14,Para_front.maxpixel);
    [newXN13,newY14]=Screen('DrawText',window,num2str(Para_MvSinGratTF.Displaydelay/1000,'%3.1f'),newXN12,newY14,Para_front.maxpixel);
    [newXN14,newY14]=Screen('DrawText',window,' Tbaseline(s)=',newXN13,newY14,Para_front.maxpixel);
    [newXN15,newY14]=Screen('DrawText',window,num2str(Para_MvSinGratTF.BaselineTrialTime/1000,'%3.1f'),newXN14,newY14,Para_front.maxpixel);
    [newXN16,newY14]=Screen('DrawText',window,' Tmoving(s)=',newXN15,newY14,Para_front.maxpixel);
    [newXN17,newY14]=Screen('DrawText',window,num2str(Para_MvSinGratTF.Tmoving/1000,'%3.1f'),newXN16,newY14,Para_front.maxpixel);
    [newXN18,newY14]=Screen('DrawText',window,' ISI(s)=',newXN17,newY14,Para_front.maxpixel);
    [newXN19,newY14]=Screen('DrawText',window,num2str(Para_MvSinGratTF.ISI/1000,'%3.1f'),newXN18,newY14,Para_front.maxpixel);
    [newXN20,newY14]=Screen('DrawText',window, ' ',newXN19,newY14,Para_front.maxpixel);
    [newXN21,newY14]=Screen('DrawText',window, ' 2ndMVSinGrat_TF_SH(32s to start)',newXN20,newY14,Para_front.maxpixel);
    
    FrontRect.MoveSinGrat_TF=round([offset1 newY14+offset3 newXN0 newY14+offset3+offset2]);
    FrontRect.MoveSinGrat_TFStimulation=round([newXN1 newY14+offset3 newXN2 newY14+offset3+offset2]);
    FrontRect.MoveSinGrat_TFAngle=round([newXN3 newY14+offset3 newXN4 newY14+offset3+offset2]);
    FrontRect.MoveSinGrat_TFContrast=round([newXN5 newY14+offset3 newXN6 newY14+offset3+offset2]);
    FrontRect.MoveSinGrat_TFSpatFreq=round([newXN7 newY14+offset3 newXN8 newY14+offset3+offset2]);
    FrontRect.MoveSinGrat_TFSize=round([newXN9 newY14+offset3 newXN10 newY14+offset3+offset2]);
    FrontRect.MoveSinGrat_TFFullFlag=round([newXN10 newY14+offset3 newXN11 newY14+offset3+offset2]);
    FrontRect.MoveSinGrat_TFDisplaydelay=round([newXN12 newY14+offset3 newXN13 newY14+offset3+offset2]);
    FrontRect.MoveSinGrat_TFBaselineTrialTime=round([newXN14 newY14+offset3 newXN15 newY14+offset3+offset2]);
    FrontRect.MoveSinGrat_TFTmoving=round([newXN16 newY14+offset3 newXN17 newY14+offset3+offset2]);
    FrontRect.MoveSinGrat_TFISI=round([newXN18 newY14+offset3 newXN19 newY14+offset3+offset2]);
    FrontRect.secondMoveSinGrat_TF=round([newXN20 newY14+offset3 newXN21 newY14+offset3+offset2]);
    
    %% Moving SinGratings of Orientation+Contrast
    [newXO0,newY16]=Screen('DrawText',window,'MVSinGrat_Ori+Contrast_SH',offset1,round(Para_front.StepSize)*16,Para_front.maxpixel);
    [newXO1,newY16]=Screen('DrawText',window,' Stimulation=',newXO0,newY16,Para_front.maxpixel);
    [newXO2,newY16]=Screen('DrawText',window, Para_MvSinGrat_Ori_Contrast.StimulationFiles{Para_MvSinGrat_Ori_Contrast.StimulationFile},newXO1,newY16,Para_front.maxpixel);
    [newXO3,newY16]=Screen('DrawText',window,' SpatFreQ=',newXO2,newY16,Para_front.maxpixel);
    [newXO4,newY16]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast.SpatFreqDeg,'%4.3f'),newXO3,newY16,Para_front.maxpixel);
    [newXO5,newY16]=Screen('DrawText',window,' TempFreQ=',newXO4,newY16,Para_front.maxpixel);
    [newXO6,newY16]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast.TempFreq, '%3.1f'),newXO5,newY16,Para_front.maxpixel);
    [newXO7,newY16]=Screen('DrawText',window, '',newXO6,newY16,Para_front.maxpixel);
    [newXO8,newY16]=Screen('DrawText',window, '',newXO7,newY16,Para_front.maxpixel);
    [newXO9,newY16]=Screen('DrawText',window, ' Size=',newXO8,newY16,Para_front.maxpixel);
    [newXO10,newY16]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast.Size,'%02d'),newXO9,newY16,Para_front.maxpixel);
    [newXO11,newY16]=Screen('DrawText',window,'',newXO10,newY16,Para_front.maxpixel);
    if Para_MvSinGrat_Ori_Contrast.FullFlag
        [newXO12,newY16]=Screen('DrawText',window,'Full',newXO11,newY16,Para_front.maxpixel);
    else
        [newXO12,newY16]=Screen('DrawText',window,'Mask',newXO11,newY16,Para_front.maxpixel);
    end
    [newXO13,newY16]=Screen('DrawText',window,' Displaydelay(s)=',newXO12,newY16,Para_front.maxpixel);
    [newXO14,newY16]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast.Displaydelay/1000,'%3.1f'),newXO13,newY16,Para_front.maxpixel);
    [newXO15,newY16]=Screen('DrawText',window, ' Tbaseline(s)=',newXO14,newY16,Para_front.maxpixel);
    [newXO16,newY16]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast.BaselineTrialTime/1000,'%3.1f'),newXO15,newY16,Para_front.maxpixel);
    [newXO17,newY16]=Screen('DrawText',window, ' Tmoving(s)=',newXO16,newY16,Para_front.maxpixel);
    [newXO18,newY16]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast.Tmoving/1000,'%3.1f'),newXO17,newY16,Para_front.maxpixel);
    [newXO19,newY16]=Screen('DrawText',window, ' ISI(s)=',newXO18,newY16,Para_front.maxpixel);
    [newXO20,newY16]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast.ISI/1000,'%3.1f'),newXO19,newY16,Para_front.maxpixel);
    [newXO21,newY16]=Screen('DrawText',window, ' ',newXO20,newY16,Para_front.maxpixel);
    [newXO22,newY16]=Screen('DrawText',window, ' 2ndMV_SinGrat_SH',newXO21,newY16,Para_front.maxpixel);

    FrontRect.MoveSinGrat_Ori_Contrast=round([offset1 newY16+offset3 newXO0 newY16+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_ContrastStimulation=round([newXO1 newY16+offset3 newXO2 newY16+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_ContrastSF=round([newXO3 newY16+offset3 newXO4 newY16+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_ContrastTF=round([newXO5 newY16+offset3 newXO6 newY16+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_ContrastSize=round([newXO9 newY16+offset3 newXO10 newY16+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_ContrastFullFlag=round([newXO11 newY16+offset3 newXO12 newY16+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_ContrastDisplaydelay=round([newXO13 newY16+offset3 newXO14 newY16+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_ContrastTbaseline=round([newXO15 newY16+offset3 newXO16 newY16+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_ContrastTmoving=round([newXO17 newY16+offset3 newXO18 newY16+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_ContrastISI=round([newXO19 newY16+offset3 newXO20 newY16+offset3+offset2]);
    FrontRect.secondMoveSinGrat_Ori_Contrast=round([newXO21 newY16+offset3 newXO22 newY16+offset3+offset2]);

    %% Moving SinGratings of Orientation+Contrast+Size
    [newXP0,newY19]=Screen('DrawText',window,'MVSinGrat_Ori+Contrast+Size_SH',offset1,round(Para_front.StepSize)*19,Para_front.maxpixel);
    [newXP1,newY19]=Screen('DrawText',window,' Stimulation=',newXP0,newY19,Para_front.maxpixel);
    [newXP2,newY19]=Screen('DrawText',window, Para_MvSinGrat_Ori_Contrast_Size.StimulationFiles{Para_MvSinGrat_Ori_Contrast_Size.StimulationFile},newXP1,newY19,Para_front.maxpixel);
    [newXP3,newY19]=Screen('DrawText',window,' SpatFreQ=',newXP2,newY19,Para_front.maxpixel);
    [newXP4,newY19]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast_Size.SpatFreqDeg,'%4.3f'),newXP3,newY19,Para_front.maxpixel);
    [newXP5,newY19]=Screen('DrawText',window,' TempFreQ=',newXP4,newY19,Para_front.maxpixel);
    [newXP6,newY19]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast_Size.TempFreq, '%3.1f'),newXP5,newY19,Para_front.maxpixel);
    [newXP7,newY19]=Screen('DrawText',window, '',newXP6,newY19,Para_front.maxpixel);
    [newXP8,newY19]=Screen('DrawText',window, '',newXP7,newY19,Para_front.maxpixel);
    [newXP9,newY19]=Screen('DrawText',window, '',newXP8,newY19,Para_front.maxpixel);
    [newXP10,newY19]=Screen('DrawText',window, '',newXP9,newY19,Para_front.maxpixel);
    [newXP11,newY19]=Screen('DrawText',window,'',newXP10,newY19,Para_front.maxpixel);
    [newXP12,newY19]=Screen('DrawText',window,'',newXP11,newY19,Para_front.maxpixel);
    [newXP13,newY19]=Screen('DrawText',window,' Displaydelay(s)=',newXP12,newY19,Para_front.maxpixel);
    [newXP14,newY19]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast_Size.Displaydelay/1000,'%3.1f'),newXP13,newY19,Para_front.maxpixel);
    [newXP15,newY19]=Screen('DrawText',window, ' Tbaseline(s)=',newXP14,newY19,Para_front.maxpixel);
    [newXP16,newY19]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast_Size.BaselineTrialTime/1000,'%3.1f'),newXP15,newY19,Para_front.maxpixel);
    [newXP17,newY19]=Screen('DrawText',window, ' Tmoving(s)=',newXP16,newY19,Para_front.maxpixel);
    [newXP18,newY19]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast_Size.Tmoving/1000,'%3.1f'),newXP17,newY19,Para_front.maxpixel);
    [newXP19,newY19]=Screen('DrawText',window, ' ISI(s)=',newXP18,newY19,Para_front.maxpixel);
    [newXP20,newY19]=Screen('DrawText',window, num2str(Para_MvSinGrat_Ori_Contrast_Size.ISI/1000,'%3.1f'),newXP19,newY19,Para_front.maxpixel);
%     [newXP21,newY19]=Screen('DrawText',window, ' ',newXP20,newY19,Para_front.maxpixel);
%     [newXP22,newY19]=Screen('DrawText',window, ' 2ndMV_SinGrat_SH',newXP21,newY19,Para_front.maxpixel);

    FrontRect.MoveSinGrat_Ori_Contrast_Size=round([offset1 newY19+offset3 newXP0 newY19+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_Contrast_SizeStimulation=round([newXP1 newY19+offset3 newXP2 newY19+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_Contrast_SizeSF=round([newXP3 newY19+offset3 newXP4 newY19+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_Contrast_SizeTF=round([newXP5 newY19+offset3 newXP6 newY19+offset3+offset2]);
%     FrontRect.MvSinGrat_Ori_Contrast_SizeSize=round([newXP9 newY19+offset3 newXP10 newY19+offset3+offset2]);
%     FrontRect.MvSinGrat_Ori_Contrast_SizeFullFlag=round([newXP11 newY19+offset3 newXP12 newY19+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_Contrast_SizeDisplaydelay=round([newXP13 newY19+offset3 newXP14 newY19+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_Contrast_SizeTbaseline=round([newXP15 newY19+offset3 newXP16 newY19+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_Contrast_SizeTmoving=round([newXP17 newY19+offset3 newXP18 newY19+offset3+offset2]);
    FrontRect.MvSinGrat_Ori_Contrast_SizeISI=round([newXP19 newY19+offset3 newXP20 newY19+offset3+offset2]);
%     FrontRect.secondMoveSinGrat_Ori_Contrast_Size=round([newXP21 newY19+offset3 newXP22 newY19+offset3+offset2]);


    %% Flip screen
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.Spontanous);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.SpontanousTime);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.Noise);

    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.LocalSparseNoise4);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.LocalSparseNoise4_Displaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.LocalSparseNoise4_Tbaseline);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.LocalSparseNoise4_TSti);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.LocalSparseNoise4_ISI);

    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.OnOff);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.OnOffReptition);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.OnOffDisplaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.OnOffTbaseline);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.OnOffTSti);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.OnOffISI);
    
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.RFGrat);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.SecondRFGrat);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.RFPatchSize);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.RFReptition);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.RFDisplaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.RFTbaseline);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.RFTmoving);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.RFISI);
    
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.RF_X);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.RF_Y);
    
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGratSF);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGratTF);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGratStimulation);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGratFullFlag);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGratTbaseline);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGratTmoving);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGratISI);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGratContrast);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGratDisplaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGratSize);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.secondMoveSinGrat);

    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.ManBar);
    
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.IntrinsicDir);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.IntrinsicDirRepeat);

    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGrat);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGratSpatFreq);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGratDutyCycle);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGratStimulation);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGratFullFlag);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGratTempFreq);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGratContrast);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGratDisplaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGratBaselineTrialTime);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGratTmoving);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquGratISI);
    
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveEdge);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveEdgeRep);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveEdgeFullFlag);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveEdgeSp);
    
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBar);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBarStimulation);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBarSeqIndex);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBarSpeed);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBarWidth);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBarContrast);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBarBarcolor);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBarBackground);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBarDisplaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBarTbaseline);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSquBarISI);

    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_Size);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SizeStimulation);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SizeAngle);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SizeSpatFreq);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SizeTempFreq);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SizeContrast);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SizeDisplaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SizeBaselineTrialTime);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SizeTmoving);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SizeISI);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.secondMoveSinGrat_Size);
    
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_Ctr);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_CtrStimulation);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_CtrAngle);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_CtrSpatFreq);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_CtrTempFreq);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_CtrSize);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_CtrDisplaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_CtrBaselineTrialTime);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_CtrTmoving);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_CtrISI);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_CtrFullFlag);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.secondMoveSinGrat_Ctr);

    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SF);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SFStimulation);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SFAngle);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SFContrast);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SFTempFreq);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SFSize);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SFDisplaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SFBaselineTrialTime);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SFTmoving);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SFISI);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_SFFullFlag);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.secondMoveSinGrat_SF);
    
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TF);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TFStimulation);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TFAngle);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TFContrast);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TFSpatFreq);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TFSize);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TFDisplaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TFBaselineTrialTime);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TFTmoving);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TFISI);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_TFFullFlag);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.secondMoveSinGrat_TF);
    
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_Ori_Contrast);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_ContrastSF);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_ContrastTF);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_ContrastStimulation);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_ContrastFullFlag);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_ContrastTbaseline);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_ContrastTmoving);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_ContrastISI);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_ContrastDisplaydelay);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_ContrastSize);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.secondMoveSinGrat_Ori_Contrast);

    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MoveSinGrat_Ori_Contrast_Size);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_Contrast_SizeSF);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_Contrast_SizeTF);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_Contrast_SizeStimulation);
%     Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_ContrastFullFlag_Size);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_Contrast_SizeTbaseline);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_Contrast_SizeTmoving);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_Contrast_SizeISI);
    Screen('FrameRect',window, Para_front.maxpixel, FrontRect.MvSinGrat_Ori_Contrast_SizeDisplaydelay);
%     Screen('FrameRect',window, Para_front.maxpixel, FrontRect.secondMoveSinGrat_Ori_Contrast_Size);

    Screen('Flip', window);
    
catch
    Screen('CloseAll');
    Priority(0);
    psychrethrow(psychlasterror);
end