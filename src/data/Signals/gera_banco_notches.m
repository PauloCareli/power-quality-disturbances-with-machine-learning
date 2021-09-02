function [banco t] = gera_banco_notches(Nsinais,f0,fs,Nciclos,SNR)
%
%% Descrição: Função para geração de banco de dados com flutuações de tensão (distúrbio que gera Flicker)
%% Autores: CRISTIANO A. G. MARQUES, LUCAS R. FREITAS, LUCAS OLIVEIRA
%% Data: julho de 2008

%% Referências do programa:
%   IEEE Std 1159-1995
%   (IEEE Recommended Practice for Monitoring Electric Power Quality)
%% Descriçao do Programa
%
% Entradas:
%           Nsinais - número de sinais a serem gerados;
%           f0 - frequência fundamental do sinal;
%           fs - frequência de amostragem;
%           Nciclos - número de ciclos da fundamental dos sinais a serem gerados;
%           pt - ponto de inicio do distúrbio;
%           SNR em dB - relação sinal ruido (relação de potência entre fundamental e ruído);
%
% Saidas:
%           banco - matriz na qual os sinais estão armazenados em suas colunas
%           t - vetor armazenando o eixo dos tempos
%
% Observação:
%           1)A referência apenas contém os valores típicos de entrada do
%             programa.
%           2)O programa gera os sinais com alguns parâmetros pré-especificados.
%             Neste caso, se necessário, deve-se alterar tais parâmetros na parte "Entradas adicionais"

%% Entradas adicionais (alterar se necessário)

%% Processamento do Programa
Ts=1/fs;
T = 1/60;
%eixo dos tempos
t = 0:1/fs:Nciclos/60-1/fs;

N=1+Nciclos*T;
%frequência do distúrbio
fd = 3000;

    %entrada do distubio
    pt = fix(unifrnd(1*length(t)/2,3*length(t)/4));

for n=1:Nsinais
    clear st
    % geração do distúrbio notch
    num = length(t)-pt;
    %Dados referentes ao evento transitório notch
    st(num)=zeros;
    wt = 2*pi*fd; % frequência angular de oscilação fixa em 3KHz
    alfa = 0.01;
    N_notcho = round(((N-1)/60)/Ts); % notches periódicos
    N_notch = N_notcho;
    for i=1:num
        if i==N_notch
            for j=i+1
                st(j) = 0.3*sin(wt*(j-i)*t(i))*exp(-alfa*(j-i)*t(i));
            end
            N_notch = N_notch + N_notcho;
        end
    end
    
    st = [zeros(1,pt) st];
    
    % for n=1:Nsinais
    %fase da componente fundamental
    fase = unifrnd(-pi,pi);
    %geração do sinal fundamental
    fund = cos(2*pi*f0.*t+fase);
    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10);
    ruido=sqrt(var_ruido)*randn(1,length(t));
    %sinal
    sinal = fund + ruido + st(1:length(fund));
    banco(:,n)=sinal;
    
    %porcentagem completa de execução do programa
    porcentagem=n/Nsinais*100;
    disp(['banco notches: ',num2str(porcentagem), '% completo'])
end
end

% for i=1:num
%   banco(i)=sinal(i)+st(i);
% end

