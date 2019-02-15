%%%% Determine Radar Characteristics based on specs
clc
clear all
c=3e8; %speed of light
unamb_dist=0.7; % unambiguouis range in meters
fprintf(['The unambiguous  range is : ', num2str(unamb_dist),' meters\n'])
resolution=0.005; %range resolution in meters
fprintf(['The resolution is : ', num2str(resolution),' meters\n'])
span=c/2/resolution;
fprintf(['The Span of the measurement is: ', num2str(span/1e9),' GHz \n'])
N=unamb_dist*2*span/c+1; %frequency points
fprintf(['The number of frequency points is: ', num2str(N),' \n'])
res_band=1.3e3; %resolution bandwidth
fprintf(['The resolution bandwidth is: ', num2str(res_band),' Hz \n'])
time_per_freq_point=1/res_band; %time per frequency point
fprintf(['The time per frequency point is: ', num2str(time_per_freq_point),' sec \n'])
total_time=time_per_freq_point*N; % total measurement time for 1 frequency scan
fprintf(['The total frequency scan time is (at least): ', num2str(total_time),' sec \n'])
number_of_time_measuments=30/total_time; % number of measurements for 30 secs in total run time
fprintf(['Number of frequency scans for 30 sec of total time: ', num2str(number_of_time_measuments),'  \n'])

feedhorn_hpbw=10/2; %hpbw of the antenna for wr3.4=13, fro wr2.2=10
distance=0.2:0.01:4;
fov_pitch=2*tand(feedhorn_hpbw)*distance/1e-2;
figure(101)
clf
plot(distance,fov_pitch)
axis tight
xlabel('Distance (meters)')
ylabel('FOV diameter in cm')

