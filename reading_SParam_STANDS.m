%%%% Function that reads the STAND csv files from the VNA (real/imag) format
function [Sthru,Ssc,Sline,freq]=reading_SParam_STANDS(path_ini,thru_name,reflect_name,line_name,swapped)
if swapped==0
% [path_ini,thru_name,'.csv']
    Sthru1=csvread([path_ini,thru_name,'.csv'],3); 
    freq=Sthru1(:,1);
    Ssc1=csvread([path_ini,reflect_name,'.csv'],3); 
    Sline1=csvread([path_ini,line_name,'.csv'],3);

    %%% Strhu read
    Sthru(:,1)=Sthru1(:,4)+1i*Sthru1(:,5);
    Sthru(:,2)=Sthru1(:,2)+1i*Sthru1(:,3);
    Sthru(:,3)=Sthru(:,2);
    Sthru(:,4)=Sthru(:,1);

%     figure(1)
%     clf
%     plot(freq,20*log10(abs(Sthru(:,1))))
%     hold on
%     plot(freq,20*log10(abs(Sthru(:,2))))
%     title('Thru Uncalibrated')
%     legend('S11','S21')

    %%% Sshort read
    Ssc(:,1)=Ssc1(:,4)+1i*Ssc1(:,5);
    Ssc(:,2)=Ssc1(:,2)+1i*Ssc1(:,3);
    Ssc(:,3)=Ssc(:,2);
    Ssc(:,4)=Ssc(:,1);
    % 
%     figure(2)
%     clf
%     plot(freq,20*log10(abs(Ssc(:,1))))
%     hold on
%     plot(freq,20*log10(abs(Ssc(:,2))))
%     title('Reflect Uncalibrated')
%     legend('S11','S21')
    % 
    %%% Sline read
    Sline(:,1)=Sline1(:,4)+1i*Sline1(:,5);
    Sline(:,2)=Sline1(:,2)+1i*Sline1(:,3);
    Sline(:,3)=Sline(:,2);
    Sline(:,4)=Sline(:,1);
    % 
%     figure(3)
%     clf
%     plot(freq,20*log10(abs(Sline(:,1))))
%     hold on
%     plot(freq,20*log10(abs(Sline(:,2))))
%     title('Line Uncalibrated')
%     legend('S11','S21')

   
elseif swapped==1;
    
    %%%% forward
    Sthru1=csvread([path_ini,'\',thru_name,'.csv'],3); 
    freq=Sthru1(:,1);
    Ssc1=csvread([path_ini,'\',reflect_name,'.csv'],3); 
    Sline1=csvread([path_ini,'\',line_name,'.csv'],3);
    
    %%%% swapped
    Sthru1_s=csvread([path_ini,'swapped\',thru_name,'.csv'],3); 
    Ssc1_s=csvread([path_ini,'swapped\',reflect_name,'.csv'],3); 
    Sline1_s=csvread([path_ini,'swapped\',line_name,'.csv'],3);

    %%% Strhu read
    Sthru(:,1)=Sthru1(:,4)+1i*Sthru1(:,5);
    Sthru(:,2)=Sthru1(:,2)+1i*Sthru1(:,3);
    Sthru(:,3)=Sthru1_s(:,2)+1i*Sthru1_s(:,3);
    Sthru(:,4)=Sthru1_s(:,4)+1i*Sthru1_s(:,5);
% 
%     figure(1)
%     clf
%     hold on
%     plot(freq,20*log10(abs(Sthru(:,1))))
%     plot(freq,20*log10(abs(Sthru(:,2))))
%     plot(freq,20*log10(abs(Sthru(:,3))))
%     plot(freq,20*log10(abs(Sthru(:,4))))
%     title('Thru Uncalibrated')
%     legend('S11','S21','S12','S22')

    %%% Sshort read
    Ssc(:,1)=Ssc1(:,4)+1i*Ssc1(:,5);
    Ssc(:,2)=Ssc1(:,2)+1i*Ssc1(:,3);
    Ssc(:,3)=Ssc1_s(:,2)+1i*Ssc1_s(:,3);
    Ssc(:,4)=Ssc1_s(:,4)+1i*Ssc1_s(:,5);
    % 
%     figure(2)
%     clf
%     hold on
%     plot(freq,20*log10(abs(Ssc(:,1))))
%     plot(freq,20*log10(abs(Ssc(:,2))))
%     plot(freq,20*log10(abs(Ssc(:,3))))
%     plot(freq,20*log10(abs(Ssc(:,4))))
%     title('Reflect Uncalibrated')
%     legend('S11','S21','S12','S22')
    % 
    %%% Sline read
    Sline(:,1)=Sline1(:,4)+1i*Sline1(:,5);
    Sline(:,2)=Sline1(:,2)+1i*Sline1(:,3);
    Sline(:,3)=Sline1_s(:,2)+1i*Sline1_s(:,3);
    Sline(:,4)=Sline1_s(:,4)+1i*Sline1_s(:,5);
    % 
%     figure(3)
%     clf
%     hold on
%     plot(freq,20*log10(abs(Sline(:,1))))
%     plot(freq,20*log10(abs(Sline(:,2))))
%     plot(freq,20*log10(abs(Sline(:,3))))
%     plot(freq,20*log10(abs(Sline(:,4))))
%     title('Line Uncalibrated')
%     legend('S11','S21','S12','S22')

end