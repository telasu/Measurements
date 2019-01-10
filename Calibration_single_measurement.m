%% Calibration General One measurement at a time
clc
clear Sthru Ssc Sline Sdut freq Sx S Sthru_av Ssc_av Sline_av Sdut_av path_ini_stands path_ini_dut
  
%%% Algorithm General Variables

%%%%% paths for the meas data in csv format real, imag=> freq, S21real, S21imag,
%%%%% S11 real and S11 imag
path_ini_stands='C:\Users\ptheofan\OneDrive - Arizona State University\Measurements\Contact_probe\TRL\Graphene\20180730_Graphene_process_3_ACS_funny_metal\20180802\Si\';
path_ini_dut='C:\Users\ptheofan\OneDrive - Arizona State University\Measurements\Contact_probe\TRL\Graphene\20180730_Graphene_process_3_ACS_funny_metal\20180802\Si\';

swapped_stands=0; %% do you have swapped meas for the stands? 1 to use them
swapped_dut=0; %% do you have swaped meas for the dut? 1 to use them

averaging_stands=1; %% do you want to average the meas of the stands? 1==yes
number_of_dev_s=3; %% how many devices you have for each standars (e.g. 3 thrus)
number_of_remeas_dev_s=1; %% how many times you have relanded and remeasured the same standard

averaging_dut=1; %% do you want to average the meas of the DUTs? 1==yes
number_of_dev_d=6; %% how many devices you have for the DUT?
number_of_remeas_dev_d=1; %% how many times you have relanded and remeasured the DUT?

%%% here at the naming section, the last 2 numbers "..._1_1" represent the
%%% "..._device number_relanding" hence for the 2nd thru with the 3rd
%%% relanidn we have _2_3
thru_name='32_50_thru_line_c_col_3c_dev_1_1'; %% the name of the thru without the .csv
reflect_name='32_50_reflect_line_c_col_3c_dev_1_1'; %% same for all
line_name='32_50_line_line_c_col_3c_dev_1_1';
dut_name='32_50_dut_line_c_col_14_dev_1_1';

%%%%% Stand reading
if averaging_stands==0 
[Sthru,Ssc,Sline,freq]=reading_SParam_STANDS(path_ini_stands,thru_name,reflect_name,line_name,swapped_stands);

elseif averaging_stands==1
%%%%% averaging
count=1;
for k=1:number_of_dev_s
    for j=1:number_of_remeas_dev_s
        path_ave_stand=[path_ini_stands];
        %%%%%% fixing names to scan the values
        thru_name=[thru_name(1:(length(thru_name)-3)),num2str(k),'_',num2str(j)];
        reflect_name=[reflect_name(1:(length(reflect_name)-3)),num2str(k),'_',num2str(j)];
        line_name=[line_name(1:(length(line_name)-3)),num2str(k),'_',num2str(j)];
       
%         thru_name=['thru',num2str(count)];
%         reflect_name=['reflect',num2str(count)];
%         line_name=['line',num2str(count)];
        
        [Sthru_av(:,:,count),Ssc_av(:,:,count),Sline_av(:,:,count),freq]=reading_SParam_STANDS(path_ave_stand,thru_name,reflect_name,line_name,swapped_stands);
        count=count+1;
    end
end


Sthru=sum(Sthru_av,3)/(count-1);
Ssc=sum(Ssc_av,3)/(count-1);
% Ssc=(Ssc_av(:,:,1)+Ssc_av(:,:,3))/(2);
Sline=sum(Sline_av,3)/(count-1);
end

[~]=ploting_SParam_STANDS(Sthru,Ssc,Sline,freq,swapped_stands);


%%%%% DUT reading
if averaging_dut==0
[Sdut]=reading_SParam_DUT(path_ini_dut,dut_name,swapped_dut);

elseif averaging_dut==1
    %%%%% averaging
    count=1;
    for k=1:number_of_dev_d
%     for k=number_of_dev_d:number_of_dev_d %%% this line allows averaging between the different landings only
        for j=1:number_of_remeas_dev_d
            path_ave_d=[path_ini_dut];
            %%%%%% fixing names to scan the values
            dut_name=[dut_name(1:(length(dut_name)-3)),num2str(k),'_',num2str(j)];

    %         dut_name=['dut',num2str(count)];

           [Sdut_av(:,:,count)]=reading_SParam_DUT(path_ave_d,dut_name,swapped_dut);
            count=count+1;
        end
    end

    Sdut=sum(Sdut_av,3)/(count-1);

end
[~]=ploting_SParam_DUT(Sdut,freq,swapped_dut);


%%%% Calibration
%%% 8 term model 
[Sx,GL]=TRL(Sthru,Ssc,Sline,Sdut,freq);

for i=1:length(freq)
%     Sthru(i,:)=[sp.Parameters(9,9,i) sp.Parameters(10,9,i) sp.Parameters(9,10,i) sp.Parameters(10,10,i) ];
%     Sopen(i,:)=[sp.Parameters(5,5,i) sp.Parameters(6,5,i) sp.Parameters(5,6,i) sp.Parameters(6,6,i)];
%     Sline(i,:)=[sp.Parameters(7,7,i) sp.Parameters(8,7,i) sp.Parameters(7,8,i) sp.Parameters(8,8,i)];
%     Sdut(i,:)=[sp.Parameters(3,3,i) sp.Parameters(4,3,i) sp.Parameters(3,4,i) sp.Parameters(4,4,i)];
%     [Sx,GL]=TRL(Sthru(i,:),Sopen(i,:),Sline(i,:),Sdut(i,:),freq(i));
     S(:,:,i)=[Sx(i,1) Sx(i,3); Sx(i,2) Sx(i,4)];
     S11(1,i)=Sx(i,1);
     S12(1,i)=Sx(i,3);
     S21(1,i)=Sx(i,2);
     S22(1,i)=Sx(i,4);

end

figure(10)
clf
hold on
smithchart
smithchart(S11)
hold on
smithchart(S12)
hold on
smithchart(S21)
hold on
smithchart(S22)
legend('S11','S12','S21','S22')
title('Calibrated Sparam')
set(gca,'fontsize',18)

figure(11)
% clf
hold on
plot(freq/1e9,20*log10(abs(S11)))
plot(freq/1e9,smooth(20*log10(abs(S21)),5))
xlabel('Frequency')
ylabel('dB')
title('Calibrated Sparam MAG')
legend('S11','S21')
box on
set(gca,'fontsize',18)
axis tight

figure(12)
% clf
hold on
plot(freq/1e9,angle(S11)*180/pi)
plot(freq/1e9,angle(S21)*180/pi)
xlabel('Frequency')
ylabel('deg')
title('Calibrated Sparam PHASE')
legend('S11','S21')
box on
set(gca,'fontsize',18)
axis tight


%% Open Impedance Calculator
Zo=32; %characteristic impedance of the line

[Y,Z]= S2YandZ(S,Zo);

for i=1:length(freq)
    Ropen(i)=1/(-Y(1,2,i));
end
figure(21)
% clf
hold on
plot(freq/1e9,real(Ropen))
xlabel('Frequency')
ylabel('Ohm')
title('TRL calculated REAL OPen')
box on
set(gca,'FontSize',18)
axis tight

figure(22)
% clf
hold on
plot(freq/1e9,imag(Ropen))
xlabel('Frequency')
ylabel('Ohm')
title('TRL calculated IMAG Open')
box on
set(gca,'FontSize',18)
axis tight

%% Graphene Impedance Calculator
Zo=32; %characteristic impedance of the line
squares=8; % number of graphene squares 
[Y,Z]= S2YandZ(S,Zo);

for i=1:length(freq)
    Rgr_tot(i)=1/(-Y(1,2,i));
end

%%% Correction of impedance
Rgr=squares*(Rgr_tot.*Ropen)./(Ropen-Rgr_tot);
%%%%
figure(31)
% clf
hold on
plot(freq/1e9,smooth(real(Rgr),3))
xlabel('Frequency')
ylabel('Ohm Square')
title('TRL calculated REAL Graphene')
box on
set(gca,'FontSize',18)
axis tight
ylim([-5000 5000])

figure(32)
% clf
hold on
plot(freq/1e9,imag(Rgr))
xlabel('Frequency')
ylabel('Ohm Square')
title('TRL calculated IMAG Graphene')
box on
set(gca,'FontSize',18)
axis tight
ylim([-5000 5000])
