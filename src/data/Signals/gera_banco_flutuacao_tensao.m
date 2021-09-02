function [banco t] = gera_banco_flutuacao_tensao(Nsinais,f0,fs,Nciclos,SNR)
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

%amplitude m�ninima da flutua��o de tens�o;   
a_min=3/100;

%amplitude m�xima da flutua��o de tens�o;    
a_max=7/100;

%frequ�ncia m�ninima da flutua��o de tens�o;     
f_min=1;

%frequ�nciae m�xima da flutua��o de tens�o;                                       
f_max=25;

%numero de pontos por ciclo
Nppc = fs/f0;

%% Processamento do Programa  

%eixo dos tempos
t=0:1/fs:Nciclos/60-1/fs;

for n=1:Nsinais
    
    %entrada da flutua��o
    pt = fix(unifrnd(length(t)/2,3*length(t)/4));
    
    %fase da componente fundamental
    fase=unifrnd(-pi,pi); 
    
    %amplitude do dist�rbio
    a=unifrnd(a_min,a_max); 
    
    %frequ�ncia do dist�rbio
    fd=unifrnd(f_min,f_max); 
    
    flut = (1+a*sin(2*pi*fd*t(pt+1:end)));
    flut = [ones(1,pt) flut];

    %gera��o do sinal fundamental
    fund=flut.*cos(2*pi*f0*t+fase);

    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10); 
    ruido=sqrt(var_ruido)*randn(1,length(t)); 

    %sinal
    sinal=fund+ruido;
    banco(:,n)=sinal;

    %porcentagem completa de execu��o do programa
    porcentagem=n/Nsinais*100;
    disp(['banco flutua��o de tens�o: ',num2str(porcentagem), '% completo'])

end