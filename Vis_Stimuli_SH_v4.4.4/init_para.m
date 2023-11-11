function init_para

% Shuhan Huang @ Fishell lab Updated on 01/19/2022
% shuhan_huang@g.harvard.edu
% This function runs following:
    % Initial parameters
    % Distance change to 160mm instead of 150mm on 02/03/2022
    %% Global parameters
    global Distance screenNumber PATHSTR Winwidth Winheight FR Dispwidth Dispheight; 
    global Para_Monitor Para_front Para_subpanel Para_Trigger Para_RFGrat Para_Noise...
        Para_MvSinGrat Para_MvSinGratSize Para_MvSinGratContrast Para_ManualBar ...
           Para_MoveSquGrat Para_MoveEdge Para_MoveSquBar Para_MvSinGratSF Para_MvSinGratTF...
           Para_Spontaneous Para_RFCourse Para_LocalSparseNoise4 Para_MvSinGrat_Ori_Contrast...
           Para_MvSinGrat_Ori_Contrast_Size Para_Intrinsic; 
    global RF_X RF_Y;   % the center of RF
    global FrontRect; 

    %% General file folder path
    fun=mfilename;
    PATHSTR= fileparts(which(fun));
    
    %% parameters for the display
    screenNumber = 0;
    FR=Screen('NominalFrameRate',screenNumber);   %nominal frame rate in Hz
    [Winwidth, Winheight]=Screen('WindowSize', screenNumber); %in pixel
    [Dispwidth, Dispheight]=Screen('DisplaySize', screenNumber); % in mm
    % Parameters for 
    Para_Monitor.AmpFactor = 7.4030e-04; % maximun luminance
    Para_Monitor.BaseFactor = 0.3121;
    Para_Monitor.GammaFactor = 1.96738;
    Para_Monitor.Meanlum = 20.4;
    Para_Monitor.MeanPixel = 180;
    Para_Monitor.MaximalContrast = 1;

    %% parameters for frontpanel
    Para_front.minpixel=0;
    Para_front.background=Para_Monitor.MeanPixel;
    Para_front.maxpixel=255;
    Para_front.SizeofText=round(0.015*Winheight); % fontsize
    Para_front.StepSize=round(Para_front.SizeofText*1.5); % line space 

    %% parameters for subpanel
    Para_subpanel.minpixel=Para_front.minpixel;
    Para_subpanel.background=Para_front.background;
    Para_subpanel.maxpixel=Para_front.maxpixel;
    Para_subpanel.SizeofText=round(0.015*Winheight); % fontsize  %%%%%%%%%%%%%changed
    Para_subpanel.StepSize=round(Para_subpanel.SizeofText*1.2); % line space


    %% experimental para
    Distance=160; % the distance of animal to the display in mm

    %% parameters for trigger
    trigsqu_size=15;  %unit in mm
    Para_Trigger.Size = round(trigsqu_size/Dispwidth*Winwidth); % the side length of triggering square in pixel
    Para_Trigger.Bright = Para_front.maxpixel; %define the contrast of triggering square
    Para_Trigger.Location = [0 Winheight-Para_Trigger.Size Para_Trigger.Size Winheight];
    Para_Trigger.StimTime = 80; % in ms ,the duration of the bright square
    Para_Trigger.BeforeTime = 1000; % time before first trigger
    Para_Trigger.Period=240; % 240in ms  , the duration between the beginning of two consecutive squares
    Para_Trigger.ISITimeStep = 5e3;
    Para_Trigger.Background=Para_front.background; % the background intensity level of trigger window.

    %% parameters for intrinsic full screen
    Para_Intrinsic.initiateISI = 10 * 1000;
    Para_Intrinsic.TrialBaseTime = 2 * 1000;
    Para_Intrinsic.TrialMovingTime = 1 * 1000; 
    Para_Intrinsic.TrialRecoverTime = 14 * 1000;
    Para_Intrinsic.ISI = 6 * 1000;
    Para_Intrinsic.SpatFreqDeg = 0.04;
    Para_Intrinsic.TempFreq = 2;
    Para_Intrinsic.repeats = 30;
    
    %% parameters for receptiveField mapping_SH
    Para_RFGrat.StimulationFile = '\Seq_stimuli\RFreps_10reps.txt';
    Para_RFGrat.repetition= 5;
    Para_RFGrat.MaxRep = 10; % '\seq7x9_10reps.txt' has 10 sequences of 7*9=63 stimuli
    Para_RFGrat.gridgap= 15; %degrees between the patches 
    Para_RFGrat.patchSize= 20; % degrees
    Para_RFGrat.Contrast=Para_Monitor.MaximalContrast;  % contrast = 0.25; previously [170 80 0]
    Para_RFGrat.Displaydelay= 10000; %time before display of stimulation in ms
    %Para_RFGrat.interrep=0; %1000[I change to 0]; time between repetitions in ms
    Para_RFGrat.ISI= 4000;         %440 before 12/14/09; %240 before 10/05/09;previously 280ms; interstimulus interval in ms, the time between the begining of two consecutive stimuli
    Para_RFGrat.BaselineTime= 1000; % baseline at the beginning of each trial
    Para_RFGrat.StimTime= 1000;    %200 before 12/14/09;   %120 before 10/05/09;160 before 6/12/09;previously 80ms; display time for each stimulus in ms, seems not enough to drive spike response; 
    Para_RFGrat.Angle=90;
    Para_RFGrat.SpatFreqDeg= 0.04;
    Para_RFGrat.TempFreq= 2;
    % Prepare grids for finding center of the patch
    % get size of 15 degree distance patches
    Para_RFGrat.grid_size_pixel = round(tand(Para_RFGrat.gridgap/2)*Distance*2*Winwidth/Dispwidth); % grid size in pixels;
    % calculate how many grid we have here
    Para_RFGrat.grid_height = fix(Winheight/Para_RFGrat.grid_size_pixel); %7/8
    Para_RFGrat.grid_width = fix(Winwidth/Para_RFGrat.grid_size_pixel); %12/13
    Para_RFGrat.grid_num_total = (Para_RFGrat.grid_height+1)*(Para_RFGrat.grid_width+1);
    Para_RFGrat.grid_height_start = round((Winheight - (Para_RFGrat.grid_size_pixel * Para_RFGrat.grid_height))/2);
    Para_RFGrat.grid_width_start = round((Winwidth - (Para_RFGrat.grid_size_pixel * Para_RFGrat.grid_width))/2);
    
    %% initial position of the center of RF in 6x8 mapping
    RF_X=5; %[0,10] center position 5
    RF_Y=3; %[0,6] center position 3
    
    %parameters for Course 8*10
    Para_RFCourse.repetition=10;
    Para_RFCourse.MaxRep = 20;
    Para_RFCourse.row=6; %
    Para_RFCourse.column=10;% the row and column should consistant with the size of screen to get the square>>
    Para_RFCourse.SquareSize=round([Winwidth/Para_RFCourse.column Winheight/Para_RFCourse.row]); %size of the square in pixel [x y]
    Para_RFCourse.BaselineTime=500;
    Para_RFCourse.StimTime=500;    
    Para_RFCourse.ISI=1500;         
    Para_RFCourse.Displaydelay=10000; %time before display of stimulation in ms

    %parameters for Local Sparse Noise 4.65 degrees
    Para_LocalSparseNoise4.SquareDeg= 4.65; % in degree
    Para_LocalSparseNoise4.row=20; 
    Para_LocalSparseNoise4.column=35;% the row and column should consistant with the size of screen to get the square>>
    Para_LocalSparseNoise4.BaselineTime=0;
    Para_LocalSparseNoise4.StimTime=250;    
    Para_LocalSparseNoise4.ISI=250;         
    Para_LocalSparseNoise4.Displaydelay=10000; %time before display of stimulation in ms
    
    %parameters for 11x11
%     Para_11x11.repetition=3;
%     Para_11x11.MaxRep = 8;
%     Para_11x11.SeqIndex = 0;
%     Para_11x11.row=11;
%     Para_11x11.column=11;
%     Para_11x11.SquSizeDeg=5; %size of the square in degree
%     Para_11x11.DeltaDeg=0.5; % step change of square size
%     Para_11x11.StimTime=160;    %120before1/24/2011%160 3/3/2010 ;200 before 12/14/09;120 before 10/05/09;160 before 6/12/09;previously 80ms; display time for each stimulus in ms
%     Para_11x11.ISI=360;         %280before1/24/201%320 before 3/7/2010? 360 3/3/2010; 440 before 12/14/09;240 before 10/05/09;440 before 6/12/09;previously 280ms; interstimulus interval in ms, the time between the begining of two consecutive stimuli
%     Para_11x11.StimTimeStep=40;  %unit ms
%     Para_11x11.ISITimeStep=40; 
%     Para_11x11.Contrast=0.4;  % contrast = 0.25;  % previously [170 80 0]
%     Para_11x11.interrep=500; %time between repetitions in ms
%     Para_11x11.Displaydelay=2000; %time before display of stimulation in ms
    %initial position of the center of RF in 6x8 mapping
%     Xpos=4.0;
%     Ypos=3.0;
%     Dx11=0;
%     Dy11=0;
    
    %% Noise
    Para_Noise.repetition=5;
    Para_Noise.SquSizeDeg=2; % 2 in degree
    Para_Noise.StopTime = 1000; %stop time in ms@9/23/2011;changed from 500 to 1000@2/27/2012
    Para_Noise.StimTime= 1000; % in ms
    Para_Noise.ISI=[8e3 8e3]; %interstimulus interval in ms, the time between the begining of two consecutive stimuli
    Para_Noise.maxpixel=255; % 200 before 10/24/2011
    Para_Noise.background = 183;
    Para_Noise.Displaydelay = 100000;
    
    %% Movinggrating for measuring OSI
    Para_MvSinGrat.StimulationFiles = {'\repetition_0_180_5reps.txt',
        '\Orientation30_10reps.txt',
        '\Orientation30_10reps_random1.txt',
        '\Orientation30_10reps_random2.txt',
        '\Orientation30_10reps_random3.txt',
        '\Orientation30_10reps_random4.txt',
        '\Orientation30_10reps_random5.txt',
        '\Orientation30_10reps_random6.txt',
        '\Orientation30_10reps_random7.txt',
        '\Orientation30_10reps_random8.txt',
        '\Orientation30_10reps_random9.txt',
        '\Orientation30_10reps_random10.txt'};;
    Para_MvSinGrat.StimulationFile = 5;
    Para_MvSinGrat.Displaydelay = 10000;  %time before display of stimulation in ms
    Para_MvSinGrat.FullFlag=0; % the flag of whether using full screen stimulation. 1=full screen, 0=subscreen
    Para_MvSinGrat.SpatFreqDeg=0.04;   %cycle/degree
    Para_MvSinGrat.SpatFreqRG=[0.005 0.64]; % range of spatial frequency
    Para_MvSinGrat.TempFreq=2;     %Hz
    Para_MvSinGrat.Contrast = Para_Monitor.MaximalContrast;
    Para_MvSinGrat.BaselineTrialTime = 1000;
    Para_MvSinGrat.Tmoving = 2000;
    Para_MvSinGrat.ISI = 6000;
    Para_MvSinGrat.Size = 15;
    Para_MvSinGrat.Static = 0; % 1-use static grating during ISI; 0-use grey screen

    %% Manualbar 
    Para_ManualBar.Background=Para_front.background;
    Para_ManualBar.Foreground=200;
    Para_ManualBar.DeltaBright=5;% step change of brightness
    Para_ManualBar.LengthDeg=40;% bar length in degree
    Para_ManualBar.DeltaLength=5;% step change of bar length
    Para_ManualBar.WidthDeg=4;  % bar width in degree
    Para_ManualBar.DeltaWidth=1; % step change of bar width
    Para_ManualBar.Angle=0;  % bar Angle in degree
    Para_ManualBar.DeltaAngle=10; % step change of bar angle

    %% parameters for moving square grating 
    Para_MoveSquGrat.StimulationFiles = {'\repetition_0_180_5reps.txt',
        '\Orientation30_10reps.txt',
        '\Orientation30_10reps_random1.txt',
        '\Orientation30_10reps_random2.txt',
        '\Orientation30_10reps_random3.txt',
        '\Orientation30_10reps_random4.txt',
        '\Orientation30_10reps_random5.txt',
        '\Orientation30_10reps_random6.txt',
        '\Orientation30_10reps_random7.txt',
        '\Orientation30_10reps_random8.txt',
        '\Orientation30_10reps_random9.txt',
        '\Orientation30_10reps_random10.txt'};
    Para_MoveSquGrat.StimulationFile = 5;
    Para_MoveSquGrat.FullFlag=1; % the flag of whether using full screen stimulation. 1=full screen, 0=subscreen
    Para_MoveSquGrat.SpatFreqDeg=0.04; % 0.04 cycle/degree
    Para_MoveSquGrat.DutyCycle=20;   %20 percent of reciprocal of spatial frequency
    Para_MoveSquGrat.TempFreq=2;     %2 Hz
    Para_MoveSquGrat.MaskSize=20;
    Para_MoveSquGrat.Contrast=Para_Monitor.MaximalContrast;
    Para_MoveSquGrat.Displaydelay = 10000;
    Para_MoveSquGrat.BaselineTrialTime = 2000;
    Para_MoveSquGrat.Tmoving=2000;% time during stimulus in ms
    Para_MoveSquGrat.ISI=10000; % time after stimulus in ms

    %% parameters for moving edge
    Para_MoveEdge.StimulationFile = '\Orientation30_10reps.txt';
    Para_MoveEdge.FullFlag=0; % the flag of whether using full screen stimulation. 1=full screen, 0=subscreen
    Para_MoveEdge.WidthPercent=50;   %percent of reciprocal of spatial frequency
    Para_MoveEdge.Contrast=Para_Monitor.MaximalContrast;% contrast is 0.25 in Leena
    Para_MoveEdge.Tbefore=1000;% time before stimulus in ms
    Para_MoveEdge.Tafter=500; % time after stimulus in ms
    Para_MoveEdge.Repetition = 1;
    Para_MoveEdge.Speed = 10;% degree/sec %%: it's not reasonable, because the pixel per degree changes with the degree 
    Para_MoveEdge.MaxRep=10;
    Para_MoveEdge.SeqIndex=0;

    %% parameters for moving bar
    Para_MoveSquBar.StimulationFiles = {'\intrinsic_270_20reps.txt',
        '\intrinsic_90_20reps.txt',
        '\intrinsic_180_20reps.txt',
        '\intrinsic_0_20reps.txt',
        '\intrinsic_0_10reps.txt',
        '\intrinsic_180_10reps.txt',
        '\intrinsic_90_10reps.txt',
        '\intrinsic_270_10reps.txt',
        '\repetition_0_180_5reps.txt'
        '\repetition_150_30_5reps.txt'};
    Para_MoveSquBar.StimulationFile = 4;
    Para_MoveSquBar.Speed=10;  % 10 degree/s for intrinsic [Keller et al. 2020] ; 50[LA] degree/s 
    Para_MoveSquBar.SpeedStep=5; % degree/s
    Para_MoveSquBar.WidthDeg=5; % 5 degree for intrinsic [Keller et al. 2020];  4[LA] degree
    Para_MoveSquBar.WidthDegStep=0.5; % degree
    %Para_MoveSquBar.LengthDeg=60; % degree
    %Para_MoveSquBar.LengthDegStep=5; % degree
    Para_MoveSquBar.ContrastFlag=1; % 1=bright, 0=dark
    Para_MoveSquBar.Contrast=Para_Monitor.MaximalContrast;   % [from Leena: contrast = 0.25]; % previously [170 80 0]
    Para_MoveSquBar.Background = 0;
    Para_MoveSquBar.Displaydelay = 10000; % ms
    Para_MoveSquBar.BaselineTrialTime = 5000; % ms
    Para_MoveSquBar.ISI= 31000; % StimulationFile = 3,4,5,6# is 0/180 degrees; 21s + 5s before/after; start with StimulationFile = 4
    
    %% parameters for moving sinosoidal grating (size tuning)
    Para_MvSinGratSize.StimulationFiles = {'\Size_10reps.txt',
        '\Size_10reps_random1.txt',
        '\Size_10reps_random2.txt',
        '\Size_10reps_random3.txt',
        '\Size_10reps_random4.txt',
        '\Size_10reps_random5.txt',
        '\Size_10reps_random6.txt',
        '\Size_10reps_random7.txt',
        '\Size_10reps_random8.txt',
        '\Size_10reps_random9.txt',
        '\Size_10reps_random10.txt'};
    Para_MvSinGratSize.StimulationFile = 5;
    Para_MvSinGratSize.Angle = 90;
    Para_MvSinGratSize.Displaydelay = 10000;  
    Para_MvSinGratSize.SpatFreqDeg=0.04;   %cycle/degree
    Para_MvSinGratSize.TempFreq=2;     %Hz
    Para_MvSinGratSize.Contrast=Para_Monitor.MaximalContrast;
    Para_MvSinGratSize.BaselineTrialTime = 1000;
    Para_MvSinGratSize.Tmoving = 2000;
    Para_MvSinGratSize.ISI = 6000;
    
    %% parameters for moving sinosoidal grating (contrast tuning)
    Para_MvSinGratContrast.StimulationFiles = {'\Contrast_10reps.txt',
        '\Contrast_10reps_random1.txt',
        '\Contrast_10reps_random2.txt',
        '\Contrast_10reps_random3.txt',
        '\Contrast_10reps_random4.txt',
        '\Contrast_10reps_random5.txt',
        '\Contrast_10reps_random6.txt',
        '\Contrast_10reps_random7.txt',
        '\Contrast_10reps_random8.txt',
        '\Contrast_10reps_random9.txt',
        '\Contrast_10reps_random10.txt'};
    Para_MvSinGratContrast.StimulationFile = 5;
    Para_MvSinGratContrast.Angle = 90;
    Para_MvSinGratContrast.Displaydelay = 10000;  %time before display of stimulation in ms
    Para_MvSinGratContrast.SpatFreqDeg=0.04;   %cycle/degree
    Para_MvSinGratContrast.TempFreq=2;     %Hz
    Para_MvSinGratContrast.BaselineTrialTime = 1000;
    Para_MvSinGratContrast.Tmoving = 2000;
    Para_MvSinGratContrast.ISI = 6000;
    Para_MvSinGratContrast.Size = 15;  % 10, 15, 20
    Para_MvSinGratContrast.FullFlag = 0;

    %% parameters for moving sinosoidal grating (SF tuning) 0.02, 0.04, 0.08, 0.16, 0.32
    Para_MvSinGratSF.StimulationFiles = {'\SF_10reps.txt',
        '\SF_10reps_random1.txt',
        '\SF_10reps_random2.txt',
        '\SF_10reps_random3.txt',
        '\SF_10reps_random4.txt',
        '\SF_10reps_random5.txt',
        '\SF_10reps_random6.txt',
        '\SF_10reps_random7.txt',
        '\SF_10reps_random8.txt',
        '\SF_10reps_random9.txt',
        '\SF_10reps_random10.txt'};
    Para_MvSinGratSF.StimulationFile = 5;
    Para_MvSinGratSF.Angle = 90;
    Para_MvSinGratSF.Displaydelay = 10000;  %time before display of stimulation in ms
    Para_MvSinGratSF.Contrast=Para_Monitor.MaximalContrast;  
    Para_MvSinGratSF.TempFreq=2;     %Hz
    Para_MvSinGratSF.BaselineTrialTime = 1000;
    Para_MvSinGratSF.Tmoving = 2000;
    Para_MvSinGratSF.ISI = 6000;
    Para_MvSinGratSF.Size = 15;  % 10, 15, 20
    Para_MvSinGratSF.FullFlag = 0;
    
    %% parameters for moving sinosoidal grating (TF tuning) 1, 2, 4, 8, 15Hz
    Para_MvSinGratTF.StimulationFiles = {'\TF_10reps.txt',
        '\TF_10reps_random1.txt',
        '\TF_10reps_random2.txt',
        '\TF_10reps_random3.txt',
        '\TF_10reps_random4.txt',
        '\TF_10reps_random5.txt',
        '\TF_10reps_random6.txt',
        '\TF_10reps_random7.txt',
        '\TF_10reps_random8.txt',
        '\TF_10reps_random9.txt',
        '\TF_10reps_random10.txt'};
    Para_MvSinGratTF.StimulationFile = 5;
    Para_MvSinGratTF.Angle = 90;
    Para_MvSinGratTF.Displaydelay = 10000;  %time before display of stimulation in ms
    Para_MvSinGratTF.Contrast=Para_Monitor.MaximalContrast;  
    Para_MvSinGratTF.SpatFreq=0.04;    
    Para_MvSinGratTF.BaselineTrialTime = 1000;
    Para_MvSinGratTF.Tmoving = 2000;
    Para_MvSinGratTF.ISI = 6000;
    Para_MvSinGratTF.Size = 15;  % 10, 15, 20
    Para_MvSinGratTF.FullFlag = 0;

    %% Movinggrating for measuring OSI and contrast
    Para_MvSinGrat_Ori_Contrast.StimulationFiles = {'\Ori_Contrast_15reps.txt',
        '\Ori_Contrast_15reps_random1.txt',
        '\Ori_Contrast_15reps_random2.txt',
        '\Ori_Contrast_15reps_random3.txt',
        '\Ori_Contrast_15reps_random4.txt',
        '\Ori_Contrast_15reps_random5.txt',
        '\Ori_Contrast_15reps_random6.txt',
        '\Ori_Contrast_15reps_random7.txt',
        '\Ori_Contrast_15reps_random8.txt',
        '\Ori_Contrast_15reps_random9.txt',
        '\Ori_Contrast_15reps_random10.txt'};
    Para_MvSinGrat_Ori_Contrast.StimulationFile = 4;
    Para_MvSinGrat_Ori_Contrast.Displaydelay = 10000;  %time before display of stimulation in ms
    Para_MvSinGrat_Ori_Contrast.FullFlag=0; % the flag of whether using full screen stimulation. 1=full screen, 0=subscreen
    Para_MvSinGrat_Ori_Contrast.SpatFreqDeg=0.04;   %cycle/degree
    Para_MvSinGrat_Ori_Contrast.SpatFreqRG=[0.005 0.64]; % range of spatial frequency
    Para_MvSinGrat_Ori_Contrast.TempFreq=2;     %Hz
    Para_MvSinGrat_Ori_Contrast.Contrast = Para_Monitor.MaximalContrast;
    Para_MvSinGrat_Ori_Contrast.BaselineTrialTime = 800; %change to be more accurate
    Para_MvSinGrat_Ori_Contrast.Tmoving = 2000;
    Para_MvSinGrat_Ori_Contrast.ISI = 3000;
    Para_MvSinGrat_Ori_Contrast.Size = 15;
    Para_MvSinGrat_Ori_Contrast.Static = 0; % 1-use static grating during ISI; 0-use grey screen

    %% Movinggrating for measuring OSI and contrast and Size
    Para_MvSinGrat_Ori_Contrast_Size.StimulationFiles = {
        '\Size_Ori_Contrast_15reps.txt',
        '\Size_Ori_Contrast_15reps_random10.txt',
        '\Size_Ori_Contrast_15reps_random9.txt',
        '\Size_Ori_Contrast_15reps_random8.txt',
        '\Size_Ori_Contrast_15reps_random7.txt',
        '\Size_Ori_Contrast_15reps_random6.txt',
        '\Size_Ori_Contrast_15reps_random5.txt',
        '\Size_Ori_Contrast_15reps_random4.txt',
        '\Size_Ori_Contrast_15reps_random3.txt',
        '\Size_Ori_Contrast_15reps_random2.txt',
        '\Size_Ori_Contrast_15reps_random1.txt',
        '\test.txt',
        '\Size_Dir_Contrast_15reps_random1.txt',
        '\Size_Dir_Contrast_15reps_random2.txt',
        '\Size_Dir_Contrast_15reps_random3.txt',
        '\Size_Dir_Contrast_15reps_random4.txt',
        '\Size_Dir_Contrast_15reps_random5.txt',
        '\Size_Dir_Contrast_15reps_random6.txt',
        '\Size_Dir_Contrast_15reps_random7.txt',
        '\Size_Dir_Contrast_15reps_random8.txt',
        '\Size_Dir_Contrast_15reps_random9.txt',
        '\Size_Dir_Contrast_15reps_random10.txt',
        '\Size_Dir_Contrast_15reps.txt',};
    Para_MvSinGrat_Ori_Contrast_Size.StimulationFile = 11;
    Para_MvSinGrat_Ori_Contrast_Size.Displaydelay = 10000;  %time before display of stimulation in ms
%     Para_MvSinGrat_Ori_Contrast_Size.FullFlag=0; % the flag of whether using full screen stimulation. 1=full screen, 0=subscreen
    Para_MvSinGrat_Ori_Contrast_Size.SpatFreqDeg=0.04;   %cycle/degree
    Para_MvSinGrat_Ori_Contrast_Size.SpatFreqRG=[0.005 0.64]; % range of spatial frequency
    Para_MvSinGrat_Ori_Contrast_Size.TempFreq=2;     %Hz
%     Para_MvSinGrat_Ori_Contrast_Size.Contrast = Para_Monitor.MaximalContrast;
    Para_MvSinGrat_Ori_Contrast_Size.BaselineTrialTime = 800; %change to be more accurate
    Para_MvSinGrat_Ori_Contrast_Size.Tmoving = 2000;
    Para_MvSinGrat_Ori_Contrast_Size.ISI = 3000;
%     Para_MvSinGrat_Ori_Contrast_Size.Size = 15;
%     Para_MvSinGrat_Ori_Contrast_Size.Static = 0; % 1-use static grating during ISI; 0-use grey screen


    %% parameters for spontaneous activity
    Para_Spontaneous.Time = 300000; % 300,000 ms = 5 min