%% Data requirement : theta and phi should be situated in [-180 180]
%% The data matrix is (phi)181 X (theta)91, the step is 2 degree
%% run 'clear all' in command window before import new data

clc;

Gain_raw = table2array(testphimod); % import the data and change the name in the parenthesis
Gain = Gain_raw(:,3);
Gain2D=reshape(Gain,[181,91]); % reshape Gain to 2D matrix

% tranfer farfield to uv plot
theta = -pi/2:0.03488:pi/2;
phi = -pi:0.03488:pi;

uv_point_num = 400;
uv_space = 2/(uv_point_num-1);
u = -1:uv_space:1;
v = -1:uv_space:1;

[u, v] = meshgrid(u,v);

phiuv = atan(v./u);
thetauv = asin(sqrt(u.^2+v.^2));
thetauv(:,1:uv_point_num/2) = -thetauv(:,1:uv_point_num/2);

[theta, phi] = meshgrid(theta, phi);

Gain_uv= zeros(uv_point_num,uv_point_num);

for i=1:uv_point_num
    for j=1:uv_point_num
        if u(i,j)^2+v(i,j)^2 <= 1 
        thetauv_num =  round((thetauv(i,j)+1.5708)/0.03488)+1;
        phiuv_num = round((phiuv(i,j)+3.1416)/0.03488)+1;
%         if phiuv_num > 400
%             phiuv_num = 400;
%         end
        if thetauv_num > uv_point_num
            thetauv_num = uv_point_num;
        end
        Gain_uv(i,j) = Gain2D(phiuv_num,thetauv_num);
        else 
            Gain_uv(i,j) = -20;
        end
        
    end
end

% far- field plot

figure(1)
theta = -90:2:90;
phi = -180:2:180;
surf(theta,phi,Gain2D);
shading interp 
xlabel('Theta (degree)')
ylabel('Phi (degree)')
% title('Far-field radiation pattern with probe correction - E field')
view(2)
% caxis([-80 -60])
% 
figure(2)

u = -1:uv_space:1;
v = -1:uv_space:1;
surf(u,v,Gain_uv);
shading interp 
xlabel('u')
ylabel('v')
% title('uv plot with probe correction - E field')
view(2)
% caxis([-30 -0])
set(gca, 'Fontname', 'Times New Roman', 'Fontsize', 28)
colorbar
daspect([1 1 1])
hold on