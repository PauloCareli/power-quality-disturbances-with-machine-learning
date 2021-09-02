function [banco t] = gera_banco_flutuacao_tensao(Nsinais,f0,fs,Nciclos,SNR)
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

%amplitude míninima da flutuação de tensão;   
a_min=3/100;

%amplitude máxima da flutuação de tensão;    
a_max=7/100;

%frequência míninima da flutuação de tensão;     
f_min=1;

%frequênciae máxima da flutuação de tensão;                                       
f_max=25;

%numero de pontos por ciclo
Nppc = fs/f0;

%% Processamento do Programa  

%eixo dos tempos
t=0:1/fs:Nciclos/60-1/fs;

for n=1:Nsinais
    
    %entrada da flutuação
    pt = fix(unifrnd(length(t)/2,3*length(t)/4));
    
    %fase da componente fundamental
    fase=unifrnd(-pi,pi); 
    
    %amplitude do distúrbio
    a=unifrnd(a_min,a_max); 
    
    %frequência do distúrbio
    fd=unifrnd(f_min,f_max); 
    
    flut = (1+a*sin(2*pi*fd*t(pt+1:end)));
    flut = [ones(1,pt) flut];

    %geração do sinal fundamental
    fund=flut.*cos(2*pi*f0*t+fase);

    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10); 
    ruido=sqrt(var_ruido)*randn(1,length(t)); 

    %sinal
    sinal=fund+ruido;
    banco(:,n)=sinal;

    %porcentagem completa de execução do programa
    porcentagem=n/Nsinais*100;
    disp(['banco flutuação de tensão: ',num2str(porcentagem), '% completo'])

end