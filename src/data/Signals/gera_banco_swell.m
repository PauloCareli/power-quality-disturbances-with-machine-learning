function [banco t] = gera_banco_swell(Nsinais,f0,fs,Nciclos,SNR)
%
%% Descri��o: Fun��o para gera��o de banco de dados com swells
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
%           SNR - rela��o sinal ruido em dB (rela��o de pot�ncia entre fundamental e ru�do);            
%
% Saidas:                                                              
%           banco - matriz na qual os sinais est�o armazenados em suas colunas
%           t - vetor armazenando o eixo dos tempos
%
% Observa��es:                                                              
%           1)A refer�ncia cont�m apenas os valores t�picos de entrada do
%             programa.
%           2) O programa gera os sinais com as amplitudes dos swells
%              pr�-especificadas. Neste caso, se necess�rio, deve-se alterar tais par�metros na parte "Entradas adicionais" 

%% Entradas adicionais (alterar se necess�rio)

%amplitude m�ninima do swell;   
a_min=1.1;

%amplitude m�xima do swell;                                       
a_max=1.9;

%numero de pontos por ciclo
Nppc = fs/f0;

%% Processamento do Programa  

%eixo dos tempos
t=0:1/fs:Nciclos/60-1/fs;

for n=1:Nsinais
    
    %fase da componente fundamental
    fase=unifrnd(-pi,pi); 
    
    %amplitude do dist�rbio
    a=unifrnd(a_min,a_max); 

    %inicio do sag
    pt = fix(unifrnd(Nppc,length(t)/2));
    
    %dura��o do sag
    dpt=fix(unifrnd(0.5*Nppc,min([Nciclos*Nppc-pt-1 30*Nppc]))); %=> varia��o da dura��o do dist�rbio entre 0.5 a 30 ciclos
    
    %decaimento e subida do swell
    sub = a - exp(-(t(1:dpt)/0.01)+log(a-1));
    dec = 1 + exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(a-1));
        
    %disturbio
    swell = [ones(1,pt) sub.*ones(1,dpt) dec.*ones(1,length(t)-(pt+dpt))];
    
    %gera��o do sinal fundamental + disturbio
    fund=cos(2*pi*f0*t+fase).*swell;

    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10); 
    ruido=sqrt(var_ruido)*randn(1,length(t)); 

    %sinal
    sinal=fund+ruido;
    banco(:,n)=sinal;

    %porcentagem completa de execu��o do programa
    porcentagem=n/Nsinais*100;
    disp(['banco swell: ',num2str(porcentagem), '% completo'])

end