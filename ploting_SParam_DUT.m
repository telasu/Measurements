%%%% Function that plots the csv files from the VNA (real/imag) format
function [freq]=ploting_SParam_DUT(Sdut,freq,swapped)
if swapped==0

    % 
    figure(4)
%     clf
    plot(freq,20*log10(abs(Sdut(:,1))))
    hold on
    plot(freq,20*log10(abs(Sdut(:,2))))
    title('DUT Uncalibrated')
    legend('S11','S21')
   
elseif swapped==1;
    
    
    % 
    figure(11)
%     clf
    hold on
%     plot(freq./1e9,20*log10(abs(Sdut(:,1))))
    plot(freq./1e9,20*log10(abs(Sdut(:,2))))
%     plot(freq./1e9,20*log10(abs(Sdut(:,3))))
%     plot(freq./1e9,20*log10(abs(Sdut(:,4))))
    box on
    xlabel('Frequency')
    ylabel('dB')
    title('DUT Uncalibrated')
    legend('S11','S21','S12','S22')

end