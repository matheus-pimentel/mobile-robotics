clear all; close all; clc;

K = [0,0,0];

dK = [1,1,1];

ksi = 1/100;

delta = 0.001;

Erro_best = SimulaProcesso(K, 0);

k = 0;

while sum(dK) > delta
    
    k = k + 1;
    
    for i = 1:length(K)
        K(i) = K(i) + dK(i);
        Erro = SimulaProcesso(K, 0);
        
        if Erro < Erro_best
            Erro_best = Erro;
            
            dK(i) = dK(i)*(1+ksi);
        else
            K(i) = K(i) - 2*dK(i);
            Erro = SimulaProcesso(K, 0);
            
            if Erro < Erro_best
                Erro_best = Erro;
                dK(i) = dK(i)*(1+ksi);
            else
                K(i) = K(i) + dK(i);
                dK(i) = dK(i)*(1-ksi);
            end
        end
    end
    fprintf('Rodada = %i: Melhor erro = %.4f, soma(dK) = %.6f\n', k, Erro_best, sum(dK))
end

fprintf('Parâmetros: P = %.4f, I = %.4f, D = %.4f\n', K(1), K(2), K(3))
SimulaProcesso(K, 1);