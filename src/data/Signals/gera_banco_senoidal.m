function [banco t] = gera_banco_senoidal(Nsinais,f0,fs,Nciclos,SNR)
%
%% Descri��o: Fun��o para gera��o de banco de dados senoidal
%% Autores: Paulo Careli
%% Baseado nos c�digos dos autores: CRISTIANO A. G. MARQUES, LUCAS R. FREITAS, LUCAS OLIVEIRA 
%% Data: may 2021                                       

%% Descri�ao do Programa                                              
%                                                                     
% Entradas:                                                           
%           Nsinais - n�mero de sinais a serem gerados;                    
%           f0 - frequ�ncia fundamental do sinal;                    
%           fs - frequ�ncia de amostragem;                    
%           Nciclos - n�mero de ciclos da fundamental dos sinais a serem gerados;                    
%           pt - ponto de inicio do dist�rbio; 
%           SNR - rela��o sinal ruido em dB (rela��o de pot�ncia entre fundamental e ru�do);            
%
% Saidas:                                                              
%           banco - matriz na qual os sinais est�o armazenados em suas colunas
%           t - vetor armazenando o eixo dos tempos
%
% Observa��es:                                                              
%           1)A refer�ncia cont�m apenas os valores t�picos de entrada do
%             programa.

%% Entradas adicionais (alterar se necess�rio)

%numero de pontos por ciclo
Nppc = fs/f0;

%% Processamento do Programa  

%eixo dos tempos
t=0:1/fs:Nciclos/60-1/fs;

for n=1:Nsinais
    
    %fase da componente fundamental
    fase = unifrnd(-pi,pi);
    
%     figure
%     plot(fase_dist)
    %gera��o do sinal fundamental + disturbio
    fund=cos(2*pi*f0*t);

    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10); 
    ruido=sqrt(var_ruido)*randn(1,length(t)); 

    %sinal
    sinal=fund+ruido;
    banco(:,n)=sinal;

    %porcentagem completa de execu��o do programa
    porcentagem=n/Nsinais*100;
    disp(['banco senoidal: ',num2str(porcentagem), '% completo'])

end
