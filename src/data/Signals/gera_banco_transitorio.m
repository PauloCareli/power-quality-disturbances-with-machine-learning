function [banco t fase] = gera_banco_transitorio(Nsinais,f0,fs,Nciclos,SNR)
%
%% Descrição: Função para geração de banco de dados com transitórios oscilatórios  
%% Autores: CRISTIANO A. G. MARQUES, LUCAS R. FREITAS, LUCAS OLIVEIRA  
%% Data: julho de 2008   
%% Referência do programa:  
%   IEEE Std 1159-1995
%   IEEE Recommended Practice for Monitoring Electric Power Quality
%% Descriçao do Programa                                              
%                                                                     
% Entradas:                                                           
%           Nsinais - número de sinais a serem gerados;                    
%           f0 - frequência fundamental do sinal;                    
%           fs - frequência de amostragem;                    
%           Nciclos - número de ciclos da fundamental dos sinais a serem gerados;                    
%           pt - ponto de inicio do transitório em segundos; 
%           SNR - relação sinal ruido em dB (relação de potência entre fundamental e ruído);            
% Saidas:                                                              
%           banco - matriz na qual os sinais estão armazenados em suas colunas
%           t - vetor armazenando o eixo dos tempos
%
% Observações:                                                              
%           1)A referência apenas contém os valores típicos de entrada do
%             programa.
%           2)O programa gera os sinais com alguns parâmetros pré-especificados. 
%             Neste caso, se necessário, deve-se alterar tais parâmetros na parte "Entradas adicionais" 

%% Entradas adicionais (alterar se necessário)

%tempo mínimo que pode durar do transitório;  
tt_min=0.3e-3;

%tempo máximo que pode durar do transitório;  
tt_max=10e-3;

%frequência mínima que o transitório pode possuir; 
ft_min=1000;

%frequência máxima que o transitório pode possuir; 
ft_max=min([5000 128*60/4]);

%amplitude mínima que o transitório pode possuir;   
at_min=1;

%amplitude máxima que o transitório pode possuir;            
at_max=4;

%% Processamento do Programa  

%eixo dos tempos
t=0:1/fs:Nciclos/60-1/fs;

for n=1:Nsinais

    %entrada do transitório
    pt = fix(unifrnd(2*length(t)/3,3*length(t)/4));
    
    %amplitude máxima do transitório sorteada entre dois valores 
    at=unifrnd(at_min,at_max);

    %tempo de duração do transitório sorteada entre dois valores 
    tt=unifrnd(tt_min,tt_max);

    %argumento da exponencial (baseado na constante de tempo)
    A=4/tt;

    %fase da componente fundamental
    fase=unifrnd(-pi,pi);

    %componente fundamental
    fund=cos(2*pi*f0.*t+fase);

    %argumento da exponencial (baseado na constante de tempo)
    ft=unifrnd(ft_min,ft_max);

    %fase do transitório sorteada entre dois valores 
    fase_t=unifrnd(-pi,pi);  
    trans=at*exponencial(-A*t(1:end-pt)).*cos(2*pi*ft*t(pt+1:end)+fase_t);
%     trans=at*(1 - exp(-(t(1:end-pt)/0.001))).*exponencial(-A*t(1:end-pt)).*cos(ft*t(pt+1:end)+fase_t);
%     at
    trans = [zeros(1,pt) trans];
%     plot(trans)
    
    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10); 
    ruido=sqrt(var_ruido)*randn(1,length(t)); 

    %soma da componente fundamnetal com o sinal transitório
    sinal=fund+trans+ruido;
    
    %armazenamento de cada sinal gerado no banco de dados
    banco(:,n)=sinal;    

    %porcentagem completa de execução do programa
    porcentagem=n/Nsinais*100;
    disp(['banco transitórios oscilatórios: ',num2str(porcentagem), '% completo'])

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

function [saida] = exponencial(entrada)
    
for n=1:length(entrada)
    if entrada(n)>=0
        saida(n)=0;
    else
        saida(n)=exp(entrada(n));
    end
end




