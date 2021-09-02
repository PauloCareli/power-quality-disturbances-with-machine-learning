function [banco t] = gera_banco_sag_fase(Nsinais,f0,fs,Nciclos,SNR)
%
%% Descri��o: Fun��o para gera��o de banco de dados com sags 
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
%           2)O programa gera os sinais com as amplitudes do sags
%             pr�-especificadas. Neste caso, se necess�rio, deve-se alterar tais par�metros na parte "Entradas adicionais" 

%% Entradas adicionais (alterar se necess�rio)

%amplitude m�ninima do sag;   
a_min=0.2;

%amplitude m�xima do sag;                                       
a_max=0.9;

%numero de pontos por ciclo
Nppc = fs/f0;

%% Processamento do Programa  

%eixo dos tempos
t=0:1/fs:Nciclos/60-1/fs;

for n=1:Nsinais
    
    %fase da componente fundamental
    fase = unifrnd(-pi,pi);
    
    %fase da componente fundamental
    fase_sag = fase + pi; %+ unifrnd(-pi/3,pi/3)
    
    %amplitude do dist�rbio
    a=unifrnd(a_min,a_max); 

    %dura��o do sag
    dpt=fix(unifrnd(0.5*Nppc,9*Nppc)); %=> varia��o da dura��o do dist�rbio entre 0.5 a 30 ciclos
    
    %inicio do sag
    pt = fix(unifrnd(3*Nppc,length(t)-dpt));
    
    %decaimento e subida do sag
    dec = a + exp(-(t(1:dpt)/0.01)+log(1-a));
    sub = 1 - exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(1-a));
        
    %disturbio
    sag = [ones(1,pt) dec.*ones(1,dpt) sub.*ones(1,length(t)-(pt+dpt))];
    
    if (fase_sag <= fase)
        %decaimento e subida do sag
        dec = fase_sag + exp(-(t(1:dpt)/0.01)+log(fase - fase_sag));
        sub = fase - exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(fase - fase_sag));
    
        fase_dist = [fase*ones(1,pt)  dec.*ones(1,dpt)  sub.*ones(1,length(t)-(pt+dpt))];
    end
    
    if (fase_sag > fase)
        %decaimento e subida do sag
        sub = fase_sag - exp(-(t(1:dpt)/0.01)+log(fase_sag - fase));
        dec = fase + exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(fase_sag - fase));
        
        fase_dist = [fase*ones(1,pt)  sub.*ones(1,dpt)  dec.*ones(1,length(t)-(pt+dpt))];
    end
    
%     figure
%     plot(fase_dist)
    %gera��o do sinal fundamental + disturbio
    fund=cos(2*pi*f0*t+fase_dist).*sag;

    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10); 
    ruido=sqrt(var_ruido)*randn(1,length(t)); 

    %sinal
    sinal=fund+ruido;
    banco(:,n)=sinal;

    %porcentagem completa de execu��o do programa
    porcentagem=n/Nsinais*100;
    disp(['banco sag: ',num2str(porcentagem), '% completo'])

end
