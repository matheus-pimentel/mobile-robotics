% Transla��o:
% M1 � o(a) vetor/matriz (coluna) no frame original
% M2 � o(a) vetor/matriz (coluna) M1 transladado(a)
% DeltaX � a quantidade a ser transladada no eixo-x (original)
% DeltaY � a quantidade a ser transladada no eixo-y (original)
function M2 = T2D(M1 , DeltaX , DeltaY)
% Matriz de transla��o bidimensional (2D)
T = [1 0 DeltaX
    0 1 DeltaY
    0 0 1];
% Aplicando a transla��o
M2 = T * M1;
end