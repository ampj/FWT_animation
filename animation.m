
% Takes signals of the triplespar FWT response and plots an animation of 
% how the FWT would move in 2D

clc; clear all; close all

% Figure settings
set(0,'DefaultAxesFontSize',15)
set(0,'DefaultTextFontSize',15)
set(0,'DefaultLineLineWidth',3.0)
set(0,'DefaultAxesXGrid','on','DefaultAxesYGrid','on')
plt=figure(1);
set(plt,'units','normalized','outerposition',[0 0 1 1]);
set(plt, 'PaperUnits', 'inches', 'PaperPosition', [0 0 19.02 9.74]);

%% Geometric parameters

draft = 0.7;            % Floater draft
h_t   = 0.3;            % Height of tower base above SWL
l_t   = 1.715;          % Length of tower
h_n   = 0.15;           % Height of nacelle
l_n   = 0.3;            % Length of nacelle
l_s   = 0.05;           % Length of shaft
l_b   = 1.486;          % Length of blade
r_cyl = 0.43;           % Distance from center of floater to spar cylinder
d_cyl = 0.25;           % Diameter of spar cylinder
cone  = 5;              % Coning angle of rotor

%% Definition of FWT motion

% Flag to load test data
itest = 1;

T_min = 0;
T_dur = 240;
T_max = T_min + T_dur;
dt = 0.1;
t_sim = T_min:dt:T_max;

if itest
    
    load('test.mat')
    t_test = TimeSeries.dT*(0:1:length(TimeSeries.CHs(1).Data)-1);
    surge_test = TimeSeries.CHs(18).Data;
    heave_test = TimeSeries.CHs(20).Data;
    pitch_test = deg2rad(TimeSeries.CHs(22).Data);
    
    surge=pchip(t_test,surge_test,t_sim);
    heave=pchip(t_test,heave_test,t_sim);
    pitch=pchip(t_test,pitch_test,t_sim);
    
else
    
    T_mot = 1.7;
    surge = 0.4*cos(2*pi/T_mot*t_sim);
    heave = 0.15*cos(2*pi/T_mot*t_sim + pi/3);
    pitch = deg2rad(8)*cos(2*pi/T_mot*t_sim + pi); 
    
end

%% Definition of lines

cyl1top     = [-r_cyl-d_cyl/2 h_t; -r_cyl+d_cyl/2 h_t];
cyl1bot     = [-r_cyl-d_cyl/2 -draft; -r_cyl+d_cyl/2 -draft];
cyl1left    = [-r_cyl-d_cyl/2 h_t; -r_cyl-d_cyl/2 -draft];
cyl1right   = [-r_cyl+d_cyl/2 h_t; -r_cyl+d_cyl/2 -draft];

cyl2top     = [r_cyl-d_cyl/2 h_t; r_cyl+d_cyl/2 h_t];
cyl2bot     = [r_cyl-d_cyl/2 -draft; r_cyl+d_cyl/2 -draft];
cyl2left    = [r_cyl-d_cyl/2 h_t; r_cyl-d_cyl/2 -draft];
cyl2right   = [r_cyl+d_cyl/2 h_t; r_cyl+d_cyl/2 -draft];

con1        = [0 h_t;-r_cyl h_t];
con2        = [0 h_t;r_cyl h_t];

tower       = [0 h_t; 0 h_t+l_t];

nactop      = [-l_n/2 h_t+l_t+h_n;l_n/2 h_t+l_t+h_n];
nacbot      = [-l_n/2 h_t+l_t;l_n/2 h_t+l_t];
nacleft     = [-l_n/2 h_t+l_t+h_n;-l_n/2 h_t+l_t];
nacright    = [l_n/2 h_t+l_t+h_n;l_n/2 h_t+l_t];

shaft       = [-l_n/2 h_t+l_t+h_n/2;-l_n/2-l_s h_t+l_t+h_n/2];

bladetop    = [-l_n/2-l_s h_t+l_t+h_n/2;-l_n/2-l_s-l_b*sind(cone) h_t+l_t+h_n/2+l_b*cosd(cone)];

bladebot    = [-l_n/2-l_s h_t+l_t+h_n/2;-l_n/2-l_s-l_b*sind(cone)*cosd(60) h_t+l_t+h_n/2-l_b*cosd(cone)*cosd(60)];

%% Plotting

for kk=1:length(t_sim)
    
    figure(1)
    pause(1e-6)
    
    subplot(3,2,1)
    plot(t_sim,surge,'b')
    hold on
    plot(t_sim(kk),surge(kk),'*r')
    hold off
    xlabel('t [s]')
    ylabel('Surge [m]')
    xlim([t_sim(kk)-30 t_sim(kk)+30])
    
    subplot(3,2,3)
    plot(t_sim,heave,'b')
    hold on
    plot(t_sim(kk),heave(kk),'*r')
    hold off
    xlabel('t [s]')
    ylabel('Heave [m]')
    xlim([t_sim(kk)-30 t_sim(kk)+30])
    
    subplot(3,2,5)
    plot(t_sim,rad2deg(pitch),'b')
    hold on
    plot(t_sim(kk),rad2deg(pitch(kk)),'*r')
    hold off
    xlabel('t [s]')
    ylabel('Pitch [deg]')
    xlim([t_sim(kk)-30 t_sim(kk)+30])
    
    subplot(3,2,[2 4 6])
    plot([-2.0 2.0],[0 0],'c')
    hold on
    
    dummy = moveline(cyl1top,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    dummy = moveline(cyl1bot,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    dummy = moveline(cyl1left,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    dummy = moveline(cyl1right,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')

    dummy = moveline(cyl2top,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    dummy = moveline(cyl2bot,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    dummy = moveline(cyl2left,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    dummy = moveline(cyl2right,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')

    dummy = moveline(con1,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    dummy = moveline(con2,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')

    dummy = moveline(tower,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')

    dummy = moveline(nactop,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    dummy = moveline(nacbot,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    dummy = moveline(nacleft,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    dummy = moveline(nacright,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')

    dummy = moveline(shaft,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    
    dummy = moveline(bladetop,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')
    
    dummy = moveline(bladebot,surge(kk),heave(kk),pitch(kk));
    plot(dummy(:,1),dummy(:,2),'k')

    axis equal
    xlim([-2.0 2.0])
    ylim([-1.0 4.0])
    hold off
    
    xlabel('x [m]')
    ylabel('z [m]')
    title(strcat('t[s]=',num2str(t_sim(kk))))

end

