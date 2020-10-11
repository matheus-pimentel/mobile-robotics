Dx = G(1) - P(1);
Dy = G(2) - P(2);
Dth = G(3) - P(3);

rho = sqrt(Dx^2 + Dy^2);
gamma = AjustaAngulo(atan2(Dy,Dx));
alpha = AjustaAngulo(gamma - P(3));
beta = AjustaAngulo(G(3) - gamma);

iin = 0
while (rho > delta1) || (abs(alpha) > delta2) || (abs(beta) > delta2 && Kbeta < 0)
    Dx = G(1) - P(1);
    Dy = G(2) - P(2);
    Dth = G(3) - P(3);
    
    rho = sqrt(Dx^2 + Dy^2);
    gamma = AjustaAngulo(atan2(Dy,Dx));
    alpha = AjustaAngulo(gamma - P(3));
    beta = AjustaAngulo(G(3) - gamma);
    
    v = min(Krho*rho, vMax);
    if abs(alpha) > pi/2
        v = -v;
        alpha = AjustaAngulo(alpha + pi);
        beta = AjustaAngulo(beta + pi);
    end
    w = max(min(Kalpha*alpha + Kbeta*beta, wMax), -wMax);
    
    dPdt = [v*cos(P(3));
            v*sin(P(3));
            w];
    P = P + dPdt*dt;
    R = [R, P];
    
    PlotSimulacao;
    title(sprintf('\\nu = %.4f m/s, \\omega = %.2f*/s', v, rad2deg(w)));
    drawnow;
    
    iin = iin + 1;
    
    if(iin > 4)
        % Capture the plot as an image 
        frame = getframe(h); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 

        imwrite(imind,cm,filename,'gif','DelayTime',0, 'WriteMode','append'); 
        iin = 0;
    end
    
end

PlotSimulacao; title('Missão cumprida!');