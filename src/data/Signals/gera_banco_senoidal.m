function [banco t] = gera_banco_senoidal(Nsinais,f0,fs,Nciclos,SNR)
%
%% Descrição: Função para geração de banco de dados senoidal
%% Autores: Paulo Careli
%% Baseado nos códigos dos autores: CRISTIANO A. G. MARQUES, LUCAS R. FREITAS, LUCAS OLIVEIRA 
%% Data: may 2021                                       

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

%% Entradas adicionais (alterar se necessário)

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
    %geração do sinal fundamental + disturbio
    fund=cos(2*pi*f0*t);

    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10); 
    ruido=sqrt(var_ruido)*randn(1,length(t)); 

    %sinal
    sinal=fund+ruido;
    banco(:,n)=sinal;

    %porcentagem completa de execução do programa
    porcentagem=n/Nsinais*100;
    disp(['banco senoidal: ',num2str(porcentagem), '% completo'])

end
