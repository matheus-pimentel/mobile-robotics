clear all; close all; clc;

rng('default');

% mesmo range x e y
range = [0 10];
drange = (range(2) - range(1))/1000;
xy = range(1):drange:range(2);

objPos = [3;4];

sigma_z = 1;

% primeira medida
z = objPos + sigma_z * randn(2,1);

% PDF Probabilidade à Priori (inicial é uniforme)
P_prioriX = 1/(range(2) - range(1)) * ones(size(xy));
P_prioriY = 1/(range(2) - range(1)) * ones(size(xy));

E_priori = [sum(xy .* P_prioriX * drange);
            sum(xy .* P_prioriY * drange)];
    
var_priori = [sum((xy - E_priori(1)).^2 .* P_prioriX * drange);
              sum((xy - E_priori(2)).^2 .* P_prioriY * drange)];

sigma_priori = sqrt(var_priori);

% PDF Probabilidade à Posterior (medida inicial do z)
P_posterioriX = 1/sqrt(2 * pi * sigma_z^2) * exp(-1/2 * (xy - z(1,end)).^2 / sigma_z^2);
P_posterioriY = 1/sqrt(2 * pi * sigma_z^2) * exp(-1/2 * (xy - z(2,end)).^2 / sigma_z^2);

E_posteriori = [sum(xy .* P_posterioriX * drange);
                sum(xy .* P_posterioriY * drange)];
    
var_posteriori = [sum((xy - E_posteriori(1)).^2 .* P_posterioriX * drange);
                  sum((xy - E_posteriori(2)).^2 .* P_posterioriY * drange)];

sigma_posteriori = sqrt(var_posteriori);

% PDF Teorema de Bayes: P(X|Z) = P(Z|X) * P(X) / P(Z)
P_BayesX = P_posterioriX .* P_prioriX / sum(P_posterioriX .* P_prioriX * drange);
P_BayesY = P_posterioriY .* P_prioriY / sum(P_posterioriY .* P_prioriY * drange);

E_Bayes = [sum(xy .* P_BayesX * drange);
           sum(xy .* P_BayesY * drange)];
       
var_Bayes = [sum((xy - E_Bayes(1,end)).^2 .* P_BayesX * drange);
             sum((xy - E_Bayes(2,end)).^2 .* P_BayesY * drange)];

sigma_Bayes = sqrt(var_Bayes);

sigma_parada = 0.05 * sigma_z;

h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'bayesian filter.gif';

k = 1;
plotResultados;
pause;

% Capture the plot as an image 
frame = getframe(h); 
im = frame2im(frame); 
[imind,cm] = rgb2ind(im,256); 

imwrite(imind,cm,filename,'gif','DelayTime',0.2, 'Loopcount',inf); 

while sigma_Bayes(1) > sigma_parada && sigma_Bayes(2) > sigma_parada
    k = k + 1;
    P_prioriX = P_BayesX;
    P_prioriY = P_BayesY;
    
    E_priori = [sum(xy .* P_prioriX * drange);
                sum(xy .* P_prioriY * drange)];
    
    var_priori = [sum((xy - E_priori(1)).^2 .* P_prioriX * drange);
                  sum((xy - E_priori(2)).^2 .* P_prioriY * drange)];
    
    sigma_priori = sqrt(var_priori);
    
    z = [z , objPos + sigma_z * randn(2,1)];
    
    P_posterioriX = 1/sqrt(2 * pi * sigma_z^2) * exp(-1/2 * (xy - z(1,end)).^2 / sigma_z^2);
    P_posterioriY = 1/sqrt(2 * pi * sigma_z^2) * exp(-1/2 * (xy - z(2,end)).^2 / sigma_z^2);
    
    E_posteriori = [sum(xy .* P_posterioriX * drange);
                    sum(xy .* P_posterioriY * drange)];
    
    var_posteriori = [sum((xy - E_posteriori(1)).^2 .* P_posterioriX * drange);
                      sum((xy - E_posteriori(2)).^2 .* P_posterioriY * drange)];
    
    sigma_posteriori = sqrt(var_posteriori);
    
    P_BayesX = P_posterioriX .* P_prioriX / sum(P_posterioriX .* P_prioriX * drange);
    P_BayesY = P_posterioriY .* P_prioriY / sum(P_posterioriY .* P_prioriY * drange);
    
    E_Bayes = [E_Bayes [sum(xy .* P_BayesX * drange);
                        sum(xy .* P_BayesY * drange)]];
                    
    var_Bayes = [sum((xy - E_Bayes(1,end)).^2 .* P_BayesX * drange);
                 sum((xy - E_Bayes(2,end)).^2 .* P_BayesY * drange)];
    
    sigma_Bayes = sqrt(var_Bayes);
    
    % plota a cada 10 iterações
    if mod(k,5) == 0
        plotResultados;
        % Capture the plot as an image 
        frame = getframe(h); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 

        imwrite(imind,cm,filename,'gif', 'DelayTime',0,'WriteMode','append'); 
    end
end

fprintf('O valor verdadeiro escolhido para a posição do objeto foi X = %.4f, Y = %.4f\n' , objPos(1), objPos(2))

fprintf('Com 68.2689%% de confiança, o valor X encontra-se no intervalo [%.4f , %.4f] \n' , E_Bayes(1,end) - 1 * sigma_Bayes(1,end) , E_Bayes(1,end) + 1 * sigma_Bayes(1,end))
fprintf('Com 68.2689%% de confiança, o valor Y encontra-se no intervalo [%.4f , %.4f] \n' , E_Bayes(2,end) - 1 * sigma_Bayes(2,end) , E_Bayes(2,end) + 1 * sigma_Bayes(2,end))
fprintf('Com 99.9999%% de confiança, o valor X encontra-se no intervalo [%.4f , %.4f] \n' , E_Bayes(1,end) - 5 * sigma_Bayes(1,end) , E_Bayes(1,end) + 5 * sigma_Bayes(1,end))
fprintf('Com 99.9999%% de confiança, o valor Y encontra-se no intervalo [%.4f , %.4f] \n' , E_Bayes(2,end) - 5 * sigma_Bayes(2,end) , E_Bayes(2,end) + 5 * sigma_Bayes(2,end))