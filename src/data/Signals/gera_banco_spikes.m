function [banco t] = gera_banco_spikes(Nsinais,f0,fs,Nciclos,SNR)
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
T = 1/f0;
%eixo dos tempos
t = 0:1/fs:Nciclos/60-1/fs;
%entrada do transit�rio
pt = fix(unifrnd(1,length(t)/2));


N = 1+Nciclos*T;

num = length(t) - pt;

for n=1:Nsinais
  %fase da componente fundamental
  fase = unifrnd(-pi,pi); 
  %gera��o do sinal fundamental
  fund = cos(2*pi*f0*t+fase);
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

%Dados referentes aos eventos spikes
spike(num) = zeros;
duracao_s = 1; % numero final de amostras referente � subida do spike
duracao_d = 2; % numero final de amostras referente � descida do spike

for n=1:num
  if (sinal(n)>0.99)
    aux = n;
    for i=1:duracao_s
      spike(aux+i) = ((sinal(aux)/duracao_d)*(aux+i)- ...
                     (aux+i)*(sinal(aux)/duracao_d))/3;
    end
    for i=duracao_s+1:duracao_d
      spike(aux+i) = ((-sinal(aux)/duracao_d)*(aux+i)+ ...
                      (aux+i+duracao_d)*(sinal(aux)/duracao_d))/3;
    end
  end
end

 spike = [zeros(1,pt) spike];

for i=1:num
  banco(i)=sinal(i)+spike(i);    
end

%fun��o degrau unit�rio 
function [saida]=degrau(entrada)

for n=1:length(entrada)
    if entrada(n)>=0
        saida(n)=1;
    else
        saida(n)=0;
    end
end




