esperanca = E_posteriori;
sigma = sigma_posteriori;

dpx = sigma(1); dpy = sigma(2);
Sigma = [dpx^2 0
         0 dpy^2];

drangePlot = (range(2) - range(1))/100;
xyPlot = range(1):drangePlot:range(2);
[X,Y] = meshgrid(xyPlot , xyPlot);
mux = esperanca(1); muy = esperanca(2);
mu = [mux; muy];

N = 2;
for i = 1:size(X,1)
    for j = 1:size(X,2)
        x = [X(i,j) ; Y(i,j)];
        Gauss(i , j) = (2*pi)^(-N/2) * det(Sigma)^(-1/2) * ...
        exp(-1/2 * (x - mu)' * pinv(Sigma) * (x - mu));
    end
end
Gauss = Gauss / sum(sum(Gauss * drangePlot) * drangePlot);
mesh(X , Y , Gauss); xlabel('x'); ylabel('y'); view(0,90);
xlim(range);
ylim(range);