
% Create a serial port object and open communication with serial port.
% Check your PC’s device manager to see which COM-port your device
% is connected to and change ‘COM6’ appropriately.
s = serial('COM3');
set(s);
fopen(s);
% The command "PHOTO" puts the instrument into remote mode.
% Commands must be sent one character at a time.
fprintf(s,'P','async');
fprintf(s,'H','async');
fprintf(s,'O','async');
fprintf(s,'T','async');
fprintf(s,'O','async');

% Send "DATA CODE" Command with Data Code "117"
fprintf(s,'D117','async');
pause(1);
fscanf(s) % Read back instrument response from the command
% Take a Measurement.
fprintf(s,'M')
pause(5);
% Send Command "Q" to Exit Remote Mode.
fprintf(s,'Q');
% Close the COM-port.
fclose(s);
delete(s);
clear s;