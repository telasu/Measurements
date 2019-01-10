%%%% Function that Plots the STAND csv files from the VNA (real/imag) format
function [freq]=ploting_SParam_STANDS(Sthru,Ssc,Sline,freq,swapped)

if swapped==0

    figure(1)
    clf
    plot(freq,20*log10(abs(Sthru(:,1))))
    hold on
    plot(freq,20*log10(abs(Sthru(:,2))))
    title('Thru Uncalibrated')
    legend('S11','S21')


    % 
    figure(2)
    clf
    plot(freq,20*log10(abs(Ssc(:,1))))
    hold on
    plot(freq,20*log10(abs(Ssc(:,2))))
    title('Reflect Uncalibrated')
    legend('S11','S21')

    figure(3)
    clf
    plot(freq,20*log10(abs(Sline(:,1))))
    hold on
    plot(freq,20*log10(abs(Sline(:,2))))
    title('Line Uncalibrated')
    legend('S11','S21')

   
elseif swapped==1;
    

    figure(1)
    clf
    hold on
    plot(freq,20*log10(abs(Sthru(:,1))))
    plot(freq,20*log10(abs(Sthru(:,2))))
    plot(freq,20*log10(abs(Sthru(:,3))))
    plot(freq,20*log10(abs(Sthru(:,4))))
    title('Thru Uncalibrated')
    legend('S11','S21','S12','S22')


    % 
    figure(2)
    clf
    hold on
    plot(freq,20*log10(abs(Ssc(:,1))))
    plot(freq,20*log10(abs(Ssc(:,2))))
    plot(freq,20*log10(abs(Ssc(:,3))))
    plot(freq,20*log10(abs(Ssc(:,4))))
    title('Reflect Uncalibrated')
    legend('S11','S21','S12','S22')
    % 

    % 
    figure(3)
    clf
    hold on
    plot(freq,20*log10(abs(Sline(:,1))))
    plot(freq,20*log10(abs(Sline(:,2))))
    plot(freq,20*log10(abs(Sline(:,3))))
    plot(freq,20*log10(abs(Sline(:,4))))
    title('Line Uncalibrated')
    legend('S11','S21','S12','S22')

end