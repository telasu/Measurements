% This function controls the VNA with the USE of VISA commands
clc
close all
clear all

% Find the instrument
try
    rtb = VISA_Instrument('TCPIP::10.206.196.57::INSTR'); % Adjust the VISA Resource string to fit your instrument
    rtb.SetTimeoutMilliseconds(10000000000000); % Timeout for VISA Read Operations
    % rtb.AddLFtoWriteEnd = false;
catch ME
    error ('Error initializing the instrument:\n%s', ME.message);
end

% ASk to identify the instrumenr242
idnResponse = rtb.QueryString('*IDN?'); %ask VNA to send back identifier
fprintf('\nInstrument Identification string: %s\n', idnResponse); % print identifier

rtb.Write('*RST;*CLS'); % Presets the instrument
% rtb.Write('INIT:CONT ON') % Start continous scanning
Fc_0 = rtb.QueryString('FREQ:CENT?'); %what is the initial center freq?
Fspan_0 = rtb.QueryString('FREQ:SPAN?'); %What is the initial span of the measurement?
Sweep_points_0 = rtb.QueryString('SWE:POIN?');%What is the initial sweep points number
Res_band_0 = rtb.QueryString('BAND:RES?');%What is the initial resolution Bandwidth?

rtb.Write('FREQ:CENT 400 GHz') % set freq center
rtb.Write('FREQ:SPAN 30 GHz ') %set freq span
Fc = rtb.QueryString('FREQ:CENT?'); %what is the center freq?
Fspan = rtb.QueryString('FREQ:SPAN?'); %What is the span of the measurement?

rtb.Write('SWE:POIN 141'); % set number of sweep points
Sweep_points = rtb.QueryString('SWE:POIN?'); %What is the sweep points number
rtb.Write('BAND:RES 1.3 kHz')
Res_band = rtb.QueryString('BAND:RES?');%What is the resolution Bandwidth?

rtb.Write('CALC:PAR:DEF CH1,S11') % Choose between the S21 and the S11
rtb.Write('INIT:CONT OFF') % stop continuous scan

rtb.Write('MMEM:LOAD:CORR 1,"WR2.2_325500GHz_10001_POINTS_100Hz_BW_20190212.cal"') % Using this line we apply the available calibration set to the measurements
% error=rtb.QueryString('SYST:ERR?') %report for errors

%%% Start loop for measurements
N=300; %measure N instances
for count_meas=1:N
    tic 
    rtb.Write('INIT:IMM'); %initiate new scan
    rtb.Write('*WAI'); % Using *wai we wait for the scan to be completed before we proceed
    error=rtb.QueryString('SYST:ERR?'); %report for errors
    meas(count_meas,:) = rtb.QueryASCII_ListOfDoubles(':CALC:DATA? SDATA', str2num(Sweep_points)*2); %get the meas data, (real1,imag1,real2,imag2,..., realN,imagN)
    time(count_meas)=toc; %measure interval time
end

fprintf(['Total Time(sec): ', num2str(sum(time)), '\n'])
fprintf(['Average Time(sec): ', num2str(sum(time)/length(time)), '\n'])

%% Data Post Processing

% Data fixing (Frequency VS Time)
count=1;
for i=1:2:(str2num(Sweep_points)*2-1)
    sparam(:,count)=meas(:,i)+1i*meas(:,i+1);
    count=count+1;
end

fc=str2num(Fc);
fspan=str2num(Fspan);
fmin=fc-fspan/2;
fmin=fmin/1e9;
fmax=fc+fspan/2;
fmax=fmax/1e9;
fstep=fspan/(str2num(Sweep_points)-1);
fstep=fstep/1e9;
freq=fmin:fstep:fmax;

%fix time sequence
time_seq(1)=time(1);
for i=2:length(time)
    time_seq(i)=time_seq(i-1)+time(i);
end

[X,Y]=meshgrid(freq,time_seq);
figure(1)
clf
surf(X,Y,20*log10(abs(sparam)))
view(2)
shading interp
xlim([fmin fmax])
ylim([time_seq(1) time_seq(N)])
zlim([min(min(20*log10(abs(sparam))))-5 0])
xlabel('Frequency (GHz)')
ylabel('Time (sec)')
zlabel('dB')
colorbar 
box on
title('S11 (frequency) vs Time')

% Convert to distance vs time
time_dom=ifft(sparam,length(0:fstep:fmax),2);

max_time=1/2/fstep/1e9;
max_dist=(3e8)*max_time; %maximum distance
dist_interval=(3e8)/2/fspan;%distance resolution
distances=0:max_dist/(size(time_dom,2)-1):max_dist;

[X,Y]=meshgrid(distances,time_seq);
figure(2)
clf
surf(X,Y,20*log10(abs((time_dom))))
view(2)
shading interp
xlabel('Distance (m)')
ylabel('Time (sec)')
zlabel('dB')
xlim([0 max_dist])
ylim([time_seq(1) time_seq(N)])
colorbar 
box on
title('S11 (range) vs Time')

% Convert to distance vs time (With motion Filter)
time_ref_snapshot=time_dom(1,:);
for i=1:length(time_seq)
    time_ref(i,:)=time_ref_snapshot;
end
time_dom_filter=abs(time_dom-time_ref);

[X,Y]=meshgrid(distances,time_seq);
figure(3)
clf
surf(X,Y,20*log10(abs((time_dom_filter))))
view(2)
shading interp
xlabel('Distance (m)')
ylabel('Time (sec)')
zlabel('dB')
xlim([0 max_dist])
ylim([time_seq(1) time_seq(N)])
colorbar 
box on
title('S11 (range) vs Time (With motion filter)')

% Convert to distance vs frequency (After Motion Filter)
doppler_data=fft(time_dom_filter(2:N,:),N-1,1);

tstep=abs(time_seq(2)-time_seq(3));
tspan=abs(time_seq(2)-time_seq(N));
F_dop_max=1/tstep;
F_dop_step=(F_dop_max/(size(doppler_data,1)-1));
F_dop_seq=0:F_dop_step:F_dop_max;


[X,Y]=meshgrid(distances,F_dop_seq);

figure(4)
clf
surf(X,Y,20*log10(abs((doppler_data))))
view(2)
shading interp
xlabel('Distance (m)')
ylabel('Frequency (Hz)')
zlabel('dB')
xlim([0 max_dist])
ylim([0 F_dop_max])

colorbar 
box on
title('S11 (range) vs Frequency (After motion Filter)')