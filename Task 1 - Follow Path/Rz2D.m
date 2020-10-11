% Rota��o:
% M1 � o(a) vetor/matriz (coluna) no frame original
% M2 � o(a) vetor/matriz (coluna) M1 rotacionado(a)
% th � o �ngulo de rota��o [radianos]
function M2 = Rz2D(M1 , th)
% Matriz de rota��o no eixo-z com duas dimens�es e coord. generalizadas.
Rz = [cos(th) -sin(th) 0
    sin(th) cos(th) 0
    0 0 1];
% Aplicando a rota��o
M2 = Rz * M1;
end