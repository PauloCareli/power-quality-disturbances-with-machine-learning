function [banco t fase] = gera_banco_transitorio(Nsinais,f0,fs,Nciclos,SNR)
%
%% Descri��o: Fun��o para gera��o de banco de dados com transit�rios oscilat�rios  
%% Autores: CRISTIANO A. G. MARQUES, LUCAS R. FREITAS, LUCAS OLIVEIRA  
%% Data: julho de 2008   
%% Refer�ncia do programa:  
%   IEEE Std 1159-1995
%   IEEE Recommended Practice for Monitoring Electric Power Quality
%% Descri�ao do Programa                                              
%                                                                     
% Entradas:                                                           
%           Nsinais - n�mero de sinais a serem gerados;                    
%           f0 - frequ�ncia fundamental do sinal;                    
%           fs - frequ�ncia de amostragem;                    
%           Nciclos - n�mero de ciclos da fundamental dos sinais a serem gerados;                    
%           pt - ponto de inicio do transit�rio em segundos; 
%           SNR - rela��o sinal ruido em dB (rela��o de pot�ncia entre fundamental e ru�do);            
% Saidas:                                                              
%           banco - matriz na qual os sinais est�o armazenados em suas colunas
%           t - vetor armazenando o eixo dos tempos
%
% Observa��es:                                                              
%           1)A refer�ncia apenas cont�m os valores t�picos de entrada do
%             programa.
%           2)O programa gera os sinais com alguns par�metros pr�-especificados. 
%             Neste caso, se necess�rio, deve-se alterar tais par�metros na parte "Entradas adicionais" 

%% Entradas adicionais (alterar se necess�rio)

%tempo m�nimo que pode durar do transit�rio;  
tt_min=0.3e-3;

%tempo m�ximo que pode durar do transit�rio;  
tt_max=10e-3;

%frequ�ncia m�nima que o transit�rio pode possuir; 
ft_min=1000;

%frequ�ncia m�xima que o transit�rio pode possuir; 
ft_max=min([5000 128*60/4]);

%amplitude m�nima que o transit�rio pode possuir;   
at_min=1;

%amplitude m�xima que o transit�rio pode possuir;            
at_max=4;

%% Processamento do Programa  

%eixo dos tempos
t=0:1/fs:Nciclos/60-1/fs;

for n=1:Nsinais

    %entrada do transit�rio
    pt = fix(unifrnd(2*length(t)/3,3*length(t)/4));
    
    %amplitude m�xima do transit�rio sorteada entre dois valores 
    at=unifrnd(at_min,at_max);

    %tempo de dura��o do transit�rio sorteada entre dois valores 
    tt=unifrnd(tt_min,tt_max);

    %argumento da exponencial (baseado na constante de tempo)
    A=4/tt;

    %fase da componente fundamental
    fase=unifrnd(-pi,pi);

    %componente fundamental
    fund=cos(2*pi*f0.*t+fase);

    %argumento da exponencial (baseado na constante de tempo)
    ft=unifrnd(ft_min,ft_max);

    %fase do transit�rio sorteada entre dois valores 
    fase_t=unifrnd(-pi,pi);  
    trans=at*exponencial(-A*t(1:end-pt)).*cos(2*pi*ft*t(pt+1:end)+fase_t);
%     trans=at*(1 - exp(-(t(1:end-pt)/0.001))).*exponencial(-A*t(1:end-pt)).*cos(ft*t(pt+1:end)+fase_t);
%     at
    trans = [zeros(1,pt) trans];
%     plot(trans)
    
    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10); 
    ruido=sqrt(var_ruido)*randn(1,length(t)); 

    %soma da componente fundamnetal com o sinal transit�rio
    sinal=fund+trans+ruido;
    
    %armazenamento de cada sinal gerado no banco de dados
    banco(:,n)=sinal;    

    %porcentagem completa de execu��o do programa
    porcentagem=n/Nsinais*100;
    disp(['banco transit�rios oscilat�rios: ',num2str(porcentagem), '% completo'])

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

function [saida] = exponencial(entrada)
    
for n=1:length(entrada)
    if entrada(n)>=0
        saida(n)=0;
    else
        saida(n)=exp(entrada(n));
    end
end




