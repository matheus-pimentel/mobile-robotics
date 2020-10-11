function angulo = AjustaAngulo(angulo)

angulo = mod(angulo,2*pi);
if angulo > pi
    angulo = angulo - 2*pi;
end

end