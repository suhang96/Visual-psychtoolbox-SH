% Shuhan Huang @ Fishell lab Updated on 10/05/2021
% shuhan_huang@g.harvard.edu
% This function runs following:
% generate pixel values for measuring luminance manually on monitors

tic;

value = 0;
screenNumber=0;
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 0);  %% to avoid warning sign, set 0
HideCursor;

Screen('OpenWindow',screenNumber,value);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo.
KbStrokeWait;


% Clear the screen.
sca;
