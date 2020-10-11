clear all; close all; clc;

Corpo = [100 , 227.5 , 227.5 , 100 , -200 ,-227.5 ,-227.5 ,-200
-190.5 ,-50 , 50 , 190.5 , 190.5 , 163 ,-163 ,-190.5]/1000;
Corpo = [Corpo ; [1 1 1 1 1 1 1 1]];

RodaE = [ 97.5 97.5 -97.5 -97.5
          170.5 210.5 210.5 170.5]/1000;
RodaE = [RodaE; [1 1 1 1]];

RodaD = [ 97.5 97.5 -97.5 -97.5
          -170.5 -210.5 -210.5 -170.5]/1000;
RodaD = [RodaD; [1 1 1 1]]; 

r = 1/2 * (195/1000);
l = 1/2 * (381/1000);
vMax = 0.25;
wMax = deg2rad(300);

P = [0;2;deg2rad(0)];
R = P;
Pini = P;

G = [6;-2];
raioobst = 0.3;
th = 0:2:360;
Obst(:,:,1) = [1 + raioobst*cosd(th)
               0 + raioobst*sind(th)];
Obst(:,:,2) = [3 + raioobst*cosd(th)
               0 + raioobst*sind(th)];
Obst(:,:,3) = [5 + raioobst*cosd(th)
               0 + raioobst*sind(th)];
Obst(:,:,4) = [2 + raioobst*cosd(th)
               2 + raioobst*sind(th)];
Obst(:,:,5) = [2 + raioobst*cosd(th)
               -2 + raioobst*sind(th)];
Obst(:,:,6) = [4 + raioobst*cosd(th)
               2 + raioobst*sind(th)];
Obst(:,:,7) = [4 + raioobst*cosd(th)
               -2 + raioobst*sind(th)];

pontosRobo = [RodaD RodaE Corpo];
zonacol = max(sqrt(pontosRobo(1,:).^2 + pontosRobo(2,:).^2));
colisao = 0;

xmin = min([pontosRobo(1,:), Obst(1,:), Pini(1), G(1)]);
xmax = max([pontosRobo(1,:), Obst(1,:), Pini(1), G(1)]);
ymin = min([pontosRobo(2,:), Obst(2,:), Pini(2), G(2)]);
ymax = max([pontosRobo(2,:), Obst(2,:), Pini(2), G(2)]);

katt = 1/4; krep = 1/400; epsilon0 = 13/20;

Dx = G(1) - P(1); Dy = G(2) - P(2);
rho = sqrt(Dx^2 + Dy^2);

delta = 1e-1;
dt = 0.2;

Fatt = [0;0]; Frep = [0;0]; Ftot = Fatt + Frep;

h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'avoid obstacles.gif';

PlotSimulacao; title('Em suas marcas!'); 
pause;

% Capture the plot as an image 
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 

imwrite(imind,cm,filename,'gif','DelayTime',0, 'Loopcount',inf); 

while rho > delta
    Fatt = katt*(G(1:2, :) - P(1:2,:));
    Frep = [0;0];
    for i = 1:size(Obst, 3)
        epsilon = sqrt((Obst(1,:,i) - P(1)).^2 + (Obst(2,:,i) - P(2)).^2);
        indobst = find(epsilon <= epsilon0);
        if ~isempty(indobst)
            io{i} = indobst;
            Z = 1./epsilon(indobst) .* (1/epsilon0 - 1./epsilon(indobst));
            Frep = Frep + [sum(Z .* (Obst(1,indobst,i) - P(1)))
                           sum(Z .* (Obst(2,indobst,i) - P(2)))];
            if(min(epsilon(indobst)) <= zonacol)
                colisao = 1;
                disp('colidiu')
            end
        else
            io{i} = -1;
        end
    end
    
    Ftot = Fatt + Frep;
    
    v = min(norm(Ftot, 2), vMax);
    w = AjustaAngulo(atan2(Ftot(2), Ftot(1)) - P(3));
    w = max(min(w, wMax), -wMax);
    
    dPdt = [v*cos(P(3));
            v*sin(P(3));
            w];
    P = P + dPdt*dt;
    P(3) = AjustaAngulo(P(3));
    R = [R, P];
    
    Dx = G(1) - P(1);
    Dy = G(2) - P(2);
    rho = sqrt(Dx^2 + Dy^2);
    
    PlotSimulacao;
    title(sprintf('Distancia \\rho = %.4f m,\\nu = %.4f m/s, \\omega = %.2f*/s', rho, v, rad2deg(w)));
    drawnow;
    
    % Capture the plot as an image 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 

    imwrite(imind,cm,filename,'gif', 'DelayTime',0,'WriteMode','append'); 
    
    if(colisao == 1)
        break;
    end
end

PlotSimulacao;
if(colisao == 0)
    title('Missão cumprida!');
else
    title('Colisão');
end

% Capture the plot as an image 
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 

imwrite(imind,cm,filename,'gif', 'DelayTime',0,'WriteMode','append'); 