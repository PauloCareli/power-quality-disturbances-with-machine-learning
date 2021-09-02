function [banco t] = gera_banco_swell(Nsinais,f0,fs,Nciclos,SNR)
%
%% Descrição: Função para geração de banco de dados com swells
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
%           SNR - relação sinal ruido em dB (relação de potência entre fundamental e ruído);            
%
% Saidas:                                                              
%           banco - matriz na qual os sinais estão armazenados em suas colunas
%           t - vetor armazenando o eixo dos tempos
%
% Observações:                                                              
%           1)A referência contém apenas os valores típicos de entrada do
%             programa.
%           2) O programa gera os sinais com as amplitudes dos swells
%              pré-especificadas. Neste caso, se necessário, deve-se alterar tais parâmetros na parte "Entradas adicionais" 

%% Entradas adicionais (alterar se necessário)

%amplitude míninima do swell;   
a_min=1.1;

%amplitude máxima do swell;                                       
a_max=1.9;

%numero de pontos por ciclo
Nppc = fs/f0;

%% Processamento do Programa  

%eixo dos tempos
t=0:1/fs:Nciclos/60-1/fs;

for n=1:Nsinais
    
    %fase da componente fundamental
    fase=unifrnd(-pi,pi); 
    
    %amplitude do distúrbio
    a=unifrnd(a_min,a_max); 

    %inicio do sag
    pt = fix(unifrnd(Nppc,length(t)/2));
    
    %duração do sag
    dpt=fix(unifrnd(0.5*Nppc,min([Nciclos*Nppc-pt-1 30*Nppc]))); %=> variação da duração do distúrbio entre 0.5 a 30 ciclos
    
    %decaimento e subida do swell
    sub = a - exp(-(t(1:dpt)/0.01)+log(a-1));
    dec = 1 + exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(a-1));
        
    %disturbio
    swell = [ones(1,pt) sub.*ones(1,dpt) dec.*ones(1,length(t)-(pt+dpt))];
    
    %geração do sinal fundamental + disturbio
    fund=cos(2*pi*f0*t+fase).*swell;

    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10); 
    ruido=sqrt(var_ruido)*randn(1,length(t)); 

    %sinal
    sinal=fund+ruido;
    banco(:,n)=sinal;

    %porcentagem completa de execução do programa
    porcentagem=n/Nsinais*100;
    disp(['banco swell: ',num2str(porcentagem), '% completo'])

end