RoboC = T2D(Rz2D(Corpo , P(3)) , P(1) , P(2)); 
RoboE = T2D(Rz2D(RodaE , P(3)) , P(1) , P(2)); 
RoboD = T2D(Rz2D(RodaD , P(3)) , P(1) , P(2)); 

plot([P(1) G(1)], [P(2) G(2)], 'b', 'linewidth' , 2);
hold on;
plot(P(1) + zonacol*cosd(th), P(2) + zonacol*sind(th), 'r', 'linewidth' , 3);
for i = 1:size(Obst,3)
    fill(Obst(1,:,i), Obst(2,:,i), 'k');
    if(exist('io', 'var'))
        if ~isequal(io{i}, -1)
            fill(Obst(1,io{i},i), Obst(2,io{i},i), 'm');
        end
    end
end

plot(P(1) + epsilon0*cosd(th), P(2) + epsilon0*sind(th), 'g', 'linewidth' , 3);
plot(G(1), G(2), '*m', 'linewidth' , 2, 'markersize', 10);

fill(RoboC(1,:) , RoboC(2,:) , 'r');
fill(RoboE(1,:) , RoboE(2,:) , 'k');
fill(RoboD(1,:) , RoboD(2,:) , 'k');

plot(R(1,:) , R(2,:) , 'b' , 'linewidth' , 2);
plot([P(1) P(1)+0.1*cos(P(3))] , [P(2) P(2)+0.1*sin(P(3))] , 'b' , 'linewidth' , 2);
plot([P(1) P(1)+l*cos(P(3)+pi/2)] , [P(2) P(2)+l*sin(P(3)+pi/2)] , 'k' , 'linewidth' , 2);
plot([P(1) P(1)+l*cos(P(3)-pi/2)] , [P(2) P(2)+l*sin(P(3)-pi/2)] , 'k' , 'linewidth' , 2);

if norm(Frep) > 0
    plot([P(1) P(1)+Fatt(1)], [P(2) P(2)+Fatt(2)], 'b', 'linewidth' , 4);
    text(P(1)+Fatt(1), P(2)+Fatt(2), 'Fatt', 'Color', 'b', 'FontSize', 14);
    
    plot([P(1) P(1)+Frep(1)], [P(2) P(2)+Frep(2)], 'm', 'linewidth' , 4);
    text(P(1)+Frep(1), P(2)+Frep(2), 'Frep', 'Color', 'm', 'FontSize', 14);
    
    plot([P(1) P(1)+Ftot(1)], [P(2) P(2)+Ftot(2)], 'k', 'linewidth' , 4);
    text(P(1)+Ftot(1), P(2)+Ftot(2), 'Ftot', 'Color', 'k', 'FontSize', 14);
else
    if norm(Ftot) > 0.1
        plot([P(1) P(1)+Ftot(1)], [P(2) P(2)+Ftot(2)], 'k', 'linewidth' , 4);
        text(P(1)+Ftot(1), P(2)+Ftot(2), 'Ftot', 'Color', 'k', 'FontSize', 14);
    end
end

hold off;axis equal; grid on; set(gcf, 'color', 'w');
axis([min(xmin, P(1))-1 max(xmax, P(1))+1 min(ymin, P(2))-1 max(ymax, P(2))+1]);