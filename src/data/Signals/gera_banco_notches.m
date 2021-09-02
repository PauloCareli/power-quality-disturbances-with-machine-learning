function [banco t] = gera_banco_notches(Nsinais,f0,fs,Nciclos,SNR)
%
%% Descri��o: Fun��o para gera��o de banco de dados com flutua��es de tens�o (dist�rbio que gera Flicker)
%% Autores: CRISTIANO A. G. MARQUES, LUCAS R. FREITAS, LUCAS OLIVEIRA
%% Data: julho de 2008

%% Refer�ncias do programa:
%   IEEE Std 1159-1995
%   (IEEE Recommended Practice for Monitoring Electric Power Quality)
%% Descri�ao do Programa
%
% Entradas:
%           Nsinais - n�mero de sinais a serem gerados;
%           f0 - frequ�ncia fundamental do sinal;
%           fs - frequ�ncia de amostragem;
%           Nciclos - n�mero de ciclos da fundamental dos sinais a serem gerados;
%           pt - ponto de inicio do dist�rbio;
%           SNR em dB - rela��o sinal ruido (rela��o de pot�ncia entre fundamental e ru�do);
%
% Saidas:
%           banco - matriz na qual os sinais est�o armazenados em suas colunas
%           t - vetor armazenando o eixo dos tempos
%
% Observa��o:
%           1)A refer�ncia apenas cont�m os valores t�picos de entrada do
%             programa.
%           2)O programa gera os sinais com alguns par�metros pr�-especificados.
%             Neste caso, se necess�rio, deve-se alterar tais par�metros na parte "Entradas adicionais"

%% Entradas adicionais (alterar se necess�rio)

%% Processamento do Programa
Ts=1/fs;
T = 1/60;
%eixo dos tempos
t = 0:1/fs:Nciclos/60-1/fs;

N=1+Nciclos*T;
%frequ�ncia do dist�rbio
fd = 3000;

    %entrada do distubio
    pt = fix(unifrnd(1*length(t)/2,3*length(t)/4));

for n=1:Nsinais
    clear st
    % gera��o do dist�rbio notch
    num = length(t)-pt;
    %Dados referentes ao evento transit�rio notch
    st(num)=zeros;
    wt = 2*pi*fd; % frequ�ncia angular de oscila��o fixa em 3KHz
    alfa = 0.01;
    N_notcho = round(((N-1)/60)/Ts); % notches peri�dicos
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
    %gera��o do sinal fundamental
    fund = cos(2*pi*f0.*t+fase);
    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10);
    ruido=sqrt(var_ruido)*randn(1,length(t));
    %sinal
    sinal = fund + ruido + st(1:length(fund));
    banco(:,n)=sinal;
    
    %porcentagem completa de execu��o do programa
    porcentagem=n/Nsinais*100;
    disp(['banco notches: ',num2str(porcentagem), '% completo'])
end
end

% for i=1:num
%   banco(i)=sinal(i)+st(i);
% end

