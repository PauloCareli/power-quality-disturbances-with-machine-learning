function [banco t] = gera_banco_interrupcao(Nsinais,f0,fs,Nciclos,SNR)
%
%% Descrição: Função para geração de banco de dados com interrupções  
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
%           1)A referência apenas contém os valores típicos de entrada do
%             programa.
%           2)O programa gera os sinais com as amplitudes das interrupções pré-especificadas. 
%             Neste caso, se necessário, deve-se alterar tais parâmetros na parte "Entradas adicionais" 

%% Entradas adicionais (alterar se necessário)

%amplitude míninima da interrupção;   
a_min=0;

%amplitude máxima da interrupção;                                       
a_max=0.1;

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

    %duração da interrupção
    dpt=fix(unifrnd(0.5*Nppc,9*Nppc)); %=> variação da duração do distúrbio entre 0.5 a 30 ciclos
    
    %inicio da interrupção
    pt = fix(unifrnd(3*Nppc,length(t)-dpt));
    
    %decaimento e subida da interrupção
    dec = a + exp(-(t(1:dpt)/0.01)+log(1-a));
    sub = 1 - exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(1-a));
       
    %disturbio
    int = [ones(1,pt) dec.*ones(1,dpt) sub.*ones(1,length(t)-(pt+dpt))];
        
    %geração do sinal fundamental + disturbio
    fund=cos(2*pi*f0*t+fase).*int;
    
    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10); 
    ruido=sqrt(var_ruido)*randn(1,length(t)); 

    %sinal
    sinal=fund+ruido;
    banco(:,n)=sinal;

    %porcentagem completa de execução do programa
    porcentagem=n/Nsinais*100;
    disp(['banco interrupção: ',num2str(porcentagem), '% completo'])

end