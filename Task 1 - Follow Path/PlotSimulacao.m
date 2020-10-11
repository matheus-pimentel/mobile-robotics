GoalC = T2D(Rz2D(Corpo, G(3)), G(1), G(2));
GoalE = T2D(Rz2D(RodaE, G(3)), G(1), G(2));
GoalD = T2D(Rz2D(RodaD, G(3)), G(1), G(2));

RoboC = T2D(Rz2D(Corpo , P(3)) , P(1) , P(2)); % incremental
RoboE = T2D(Rz2D(RodaE , P(3)) , P(1) , P(2)); % incremental
RoboD = T2D(Rz2D(RodaD , P(3)) , P(1) , P(2)); % incremental

% Plot
fill(GoalC(1,:) , GoalC(2,:) , 'y') % Corpo
hold on;
fill(GoalE(1,:) , GoalE(2,:) , 'y') % roda esquerda
fill(GoalD(1,:) , GoalD(2,:) , 'y') % roda esquerda

% Posição atual do robô: onde ele está no momento atual 't'
plot(G(1) , G(2) , 'ob' , 'linewidth' , 2 , 'markersize' , 15)
% Orientação atual do robô: para onde ele aponta no momento atual 't'
plot([G(1) G(1)+0.1*cos(G(3))] , [G(2) G(2)+0.1*sin(G(3))] , 'b' , 'linewidth' , 2)
% Eixo das rodas
plot([G(1) G(1)+l*cos(G(3)+pi/2)] , [G(2) G(2)+l*sin(G(3)+pi/2)] , 'k' , 'linewidth' , 2)
plot([G(1) G(1)+l*cos(G(3)-pi/2)] , [G(2) G(2)+l*sin(G(3)-pi/2)] , 'k' , 'linewidth' , 2)

fill(RoboC(1,:) , RoboC(2,:) , 'r') % corpo
fill(RoboE(1,:) , RoboE(2,:) , 'k') % roda esquerda
fill(RoboD(1,:) , RoboD(2,:) , 'k') % roda direita
% Histórico de posições: o 'rastro' do robô, por onde ele passou.
plot(R(1,:) , R(2,:) , 'b' , 'linewidth' , 2);
% Posição atual do robô: onde ele está no momento atual 't'
plot(P(1) , P(2) , 'ob' , 'linewidth' , 2 , 'markersize' , 15)
% Orientação atual do robô: para onde ele aponta no momento atual 't'
plot([P(1) P(1)+0.1*cos(P(3))] , [P(2) P(2)+0.1*sin(P(3))] , 'b' , 'linewidth' , 2)
% Eixo das rodas
plot([P(1) P(1)+l*cos(P(3)+pi/2)] , [P(2) P(2)+l*sin(P(3)+pi/2)] , 'k' , 'linewidth' , 2)
plot([P(1) P(1)+l*cos(P(3)-pi/2)] , [P(2) P(2)+l*sin(P(3)-pi/2)] , 'k' , 'linewidth' , 2)
hold off;axis equal; grid on;