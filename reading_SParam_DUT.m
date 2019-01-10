%%%% Function that reads the csv files from the VNA (real/imag) format
function [Sdut]=reading_SParam_DUT(path_ini,dut_name,swapped)
if swapped==0
%     [path_ini,dut_name,'.csv']
    Sdut1=csvread([path_ini,dut_name,'.csv'],3);

    % 
    %%%% Sdut read
    Sdut(:,1)=Sdut1(:,4)+1i*Sdut1(:,5);
    Sdut(:,2)=Sdut1(:,2)+1i*Sdut1(:,3);
    Sdut(:,3)=Sdut(:,2);
    Sdut(:,4)=Sdut(:,1);
    % 
%     figure(4)
%     clf
%     plot(freq,20*log10(abs(Sdut(:,1))))
%     hold on
%     plot(freq,20*log10(abs(Sdut(:,2))))
%     title('DUT Uncalibrated')
%     legend('S11','S21')
   
elseif swapped==1;
    
    %%%% forward
   
    Sdut1=csvread([path_ini,'\',dut_name,'.csv'],3);
    
    %%%% swapped
    [path_ini,'swapped\',dut_name,'.csv']
    Sdut1_s=csvread([path_ini,'swapped\',dut_name,'.csv'],3);

   
    %%%% Sdut read
    Sdut(:,1)=Sdut1(:,4)+1i*Sdut1(:,5);
    Sdut(:,2)=Sdut1(:,2)+1i*Sdut1(:,3);
    Sdut(:,3)=Sdut1_s(:,2)+1i*Sdut1_s(:,3);
    Sdut(:,4)=Sdut1_s(:,4)+1i*Sdut1_s(:,5);
    % 
%     figure(4)
%     clf
%     hold on
%     plot(freq,20*log10(abs(Sdut(:,1))))
%     plot(freq,20*log10(abs(Sdut(:,2))))
%     plot(freq,20*log10(abs(Sdut(:,3))))
%     plot(freq,20*log10(abs(Sdut(:,4))))
%     title('DUT Uncalibrated')
%     legend('S11','S21','S12','S22')

end