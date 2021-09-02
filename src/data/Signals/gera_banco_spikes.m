function [banco t] = gera_banco_spikes(Nsinais,f0,fs,Nciclos,SNR)
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

%% Processamento do Programa  
Ts=1/fs;
T = 1/f0;
%eixo dos tempos
t = 0:1/fs:Nciclos/60-1/fs;
%entrada do transitório
pt = fix(unifrnd(1,length(t)/2));


N = 1+Nciclos*T;

num = length(t) - pt;

for n=1:Nsinais
  %fase da componente fundamental
  fase = unifrnd(-pi,pi); 
  %geração do sinal fundamental
  fund = cos(2*pi*f0*t+fase);
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

%Dados referentes aos eventos spikes
spike(num) = zeros;
duracao_s = 1; % numero final de amostras referente à subida do spike
duracao_d = 2; % numero final de amostras referente à descida do spike

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

%função degrau unitário 
function [saida]=degrau(entrada)

for n=1:length(entrada)
    if entrada(n)>=0
        saida(n)=1;
    else
        saida(n)=0;
    end
end




