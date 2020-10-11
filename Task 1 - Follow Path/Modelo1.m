clear; clc; close all;

Corpo = [100 , 227.5 , 227.5 , 100 , -200 ,-227.5 ,-227.5 ,-200
-190.5 ,-50 , 50 , 190.5 , 190.5 , 163 ,-163 ,-190.5]/1000;
Corpo = [Corpo ; [1 1 1 1 1 1 1 1]];% linha de 1s para transf. homogenea.

% Roda esquerda
RodaE = [ 97.5 97.5 -97.5 -97.5
          170.5 210.5 210.5 170.5]/1000;
RodaE = [RodaE; [1 1 1 1]];% linha de 1s para transf. homogenea.

% Roda direita
RodaD = [ 97.5 97.5 -97.5 -97.5
          -170.5 -210.5 -210.5 -170.5]/1000;
RodaD = [RodaD; [1 1 1 1]]; % linha de 1s para transf. homogenea.

P = [0;0;deg2rad(90)];
R = P;

Goals = [];
Goals = [Goals [0;4.5;atan2(5 - 4.5, 0 - 0)]];
Goals = [Goals [0;5;atan2(2.5 - 5, 2.5 - 0)]];
Goals = [Goals [2.5;2.5;atan2(4.5 - 2.5, 4.5 - 2.5)]];
Goals = [Goals [4.5;4.5;atan2(5 - 4.5, 5 - 4.5)]];
Goals = [Goals [5;5;atan2(0.5 - 5, 5 - 5)]];
Goals = [Goals [5;0.5;atan2(0 - 0.5, 5 - 5)]];
Goals = [Goals [5;0;atan2(0 - 0, 0 - 5)]];

G = Goals(:, 1);

r = 1/2 * (195/1000);
l = 1/2 * (381/1000);
vMax = 0.25;
wMax = deg2rad(300);

dt = 0.1;

Krho = 4/11;
Kalpha = 690/823;
Kbeta = -4/11;

delta1 = 0.01;
delta2 = deg2rad(1);

h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'testAnimated.gif';

PlotSimulacao; title('Em suas marcas ...'); pause;

% Capture the plot as an image 
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 

imwrite(imind,cm,filename,'gif','DelayTime',0.5, 'Loopcount',inf); 

for i = 1:7
    G = Goals(:, i);
    Simulacao;
    
    % Capture the plot as an image 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 

    imwrite(imind,cm,filename,'gif', 'DelayTime',0,'WriteMode','append'); 
end

PlotSimulacao; title('Missão cumprida!');

% Capture the plot as an image 
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 

imwrite(imind,cm,filename,'gif','DelayTime',0, 'WriteMode','append'); 