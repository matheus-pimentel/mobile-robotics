set(gcf, 'color', 'w');
% P priori
subplot(2,3,1);
plotGaussianaPriori;
title('Ppriori');

% P posteriori
subplot(2,3,2);
plotGaussianaPosteriori;
title('Pposteriori');

% P bayes
subplot(2,3,3);
plotGaussianaBayes;
title('Pbayes');

% Medidas do sensor
subplot(2,3,4);
plot(E_Bayes(1,:), E_Bayes(2,:), 'k', 'linewidth', 2);
hold on;
plot(z(1,:), z(2,:), '.r', 'linewidth', 1);
plot(objPos(1), objPos(2), '*b', 'markersize', 3);
xlim(range)
ylim(range)
legend('filtro','sensor', 'real');
hold off;
title('Medidas do sensor');

% Valor esperado X
subplot(2,3,5);
plot(1:1:size(E_Bayes,2), E_Bayes(1,:), 'r', 'linewidth', 2);
hold on;
plot(1:1:size(E_Bayes,2), objPos(1)*ones(1,size(E_Bayes,2)), 'k', 'linewidth', 2);
legend('filtro','real');
hold off;
title('Valor esperado X');

% Valor esperado Y
subplot(2,3,6);
plot(1:1:size(E_Bayes,2), E_Bayes(2,:), 'r', 'linewidth', 2);
hold on;
plot(1:1:size(E_Bayes,2), objPos(2)*ones(1,size(E_Bayes,2)), 'k', 'linewidth', 2);
legend('filtro','real');
hold off;
title('Valor esperado Y');

drawnow;