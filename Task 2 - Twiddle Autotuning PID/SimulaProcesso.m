function deltaErro = SimulaProcesso(K, plotSim)

Kp = K(1);
Ki = K(2);
Kd = K(3);
Krho = 1;

r = 1/2 * (195/1000);
l = 1/2 * (381/1000);
vMax = 0.25;
wMax = deg2rad(300);

dt = 0.1;

Corpo = [100 , 227.5 , 227.5 , 100 , -200 ,-227.5 ,-227.5 ,-200
-190.5 ,-50 , 50 , 190.5 , 190.5 , 163 ,-163 ,-190.5]/1000;
Corpo = [Corpo ; [1 1 1 1 1 1 1 1]];

RodaE = [ 97.5 97.5 -97.5 -97.5
          170.5 210.5 210.5 170.5]/1000;
RodaE = [RodaE; [1 1 1 1]];

RodaD = [ 97.5 97.5 -97.5 -97.5
          -170.5 -210.5 -210.5 -170.5]/1000;
RodaD = [RodaD; [1 1 1 1]]; 

P = [0;0;deg2rad(0)];
R = P;
Pini = P;

kwerr = 1;
gTheta = deg2rad(-135);

G = [Pini(1) + 1.5*cos(gTheta);
     Pini(2) + 1.5*sin(gTheta);
     gTheta];

a = G(2) - Pini(2);
b = Pini(1) - G(1);
c = G(1)*Pini(2) - Pini(1)*G(2);

Erro = abs(a*P(1) + b*P(2) + c)/sqrt(a^2 + b^2);

diffAlpha = 0;
intAlpha = 0;
alphaOld = 0;

delta1 = 0.01;

t = 0;
tMax = 10*sqrt((G(1) - Pini(1))^2 + (G(2) - Pini(2))^2)/vMax;

Dx = G(1) - P(1);
Dy = G(2) - P(2);

rho = sqrt(Dx^2 + Dy^2);
gamma = AjustaAngulo(atan2(Dy,Dx));
alpha = AjustaAngulo(gamma - P(3));

if (plotSim == 1)
    h = figure;
    axis tight manual % this ensures that getframe() returns a consistent size
    filename = 'PID.gif';
end
ind = 0;

while (rho > delta1) && (t <= tMax)
    t = t + dt;
    
    Dx = G(1) - P(1);
    Dy = G(2) - P(2);
    
    rho = sqrt(Dx^2 + Dy^2);
    gamma = AjustaAngulo(atan2(Dy,Dx));
    alpha = AjustaAngulo(gamma - P(3));
    
    diffAlpha = alpha - alphaOld; alphaOld = alpha;
    intAlpha = intAlpha + alpha;

    v = min(Krho*rho, vMax);
%     if abs(alpha) > pi/2
%         v = -v;
%         alpha = AjustaAngulo(alpha + pi);
%         beta = AjustaAngulo(beta + pi);
%     end
    w = Kp*alpha + Ki*intAlpha + Kd*diffAlpha;
    w = max(min(w, wMax), -wMax);
    
    dPdt = [v*cos(P(3));
            v*sin(P(3));
            w];
    P = P + dPdt*dt;
    R = [R, P];
    
    Erro = [Erro; abs(w)*kwerr + abs(a*P(1) + b*P(2) + c)/sqrt(a^2 + b^2)];
    
    if (plotSim == 1)
        PlotSimulacao;
        title(sprintf('\\nu = %.4f m/s, \\omega = %.2f*/s', v, rad2deg(w)));
        drawnow;
        % Capture the plot as an image 
        frame = getframe(h); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 

        if (ind == 0)
            imwrite(imind,cm,filename,'gif','DelayTime',0, 'Loopcount',inf); 
            ind = ind + 1;
        else
            imwrite(imind,cm,filename,'gif', 'DelayTime',0,'WriteMode','append'); 
            ind = ind + 1;
        end
    end
    
end

if (plotSim == 1)
    set(gcf,'color','w');
    PlotSimulacao;
    title('Missão cumprida!');
    xlabel('x') 
    ylabel('y') 
    drawnow;
    
    figure
    set(gcf,'color','w');
    plot(0:dt:t+dt, Erro*1000, 'b');
    title('Erros');
    xlabel('Tempo (s)') 
    ylabel('Erro (mm)') 
    
    % Capture the plot as an image 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    
    if (ind == 0)
        imwrite(imind,cm,filename,'gif','DelayTime',0, 'Loopcount',inf); 
        ind = ind + 1;
    else
        imwrite(imind,cm,filename,'gif', 'DelayTime',0,'WriteMode','append'); 
        ind = ind + 1;
    end
    
end

deltaErro = mean(Erro);

end