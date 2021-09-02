function [banco t fase] = gera_banco_harmonicos(Nsinais,f0,fs,Nciclos,SNR,sv)
%
%% Descrição: Função para geração de banco de dados com harmônicos
%% Autores: CRISTIANO A. G. MARQUES, LUCAS R. FREITAS, LUCAS OLIVEIRA
%% Data: julho de 2008
%% Referências do programa:
%   IEEE Std 1159-1995
%   (IEEE Recommended Practice for Monitoring Electric Power Quality)
%
%   IEEE SM 519-1992
%   (IEEE Recommended Practices and Requirements for Harmonic Control in
%   Electrical Power Systems)
%% Descriçao do Programa
%
% Entradas:
%           Nsinais - número de sinais a serem gerados;
%           f0 - frequência fundamental do sinal;
%           fs - frequência de amostragem;
%           Nciclos - número de ciclos da fundamental dos sinais a serem gerados;
%           pt - ponto de inicio dos harmônicos em segundos (entrada da carga não-linear);
%           SNR - relação sinal ruido em dB (relação de potência entre fundamental e ruído);
%
% Saidas:
%           banco - matriz na qual os sinais estão armazenados em suas colunas
%           t - vetor armazenando o eixo dos tempos
%
% Observação:
%           1)As referências apenas contém os valores típicos de entrada do
%             programa.
%           2)O programa gera os sinais com alguns parâmetros pré-especificados dos harmônicos.
%             Neste caso, se necessário, deve-se alterar tais parâmetros na parte "Entradas adicionais"


%% Entradas adicionais (alterar se necessário)

%máxima ordem do harmônico presente no sinal;
ordem_max=25;

%minima taxa de distorção harmônica em porcentagem que um sinal pode conter no banco (valor arbitrário);
THD_min=5;

%máxima taxa de distorção harmônica em porcentagem que um sinal pode conter no banco (valor arbitrário);
THD_max=100;

%eixo dos tempos
t=0:1/fs:Nciclos/60-1/fs;

% casos a serem gerados
n_casos = 5;
    % 1 - somente harmôniocs ímpares
    % 2 - harmôniocs múltiplos de 3
    % 3 - harmônicos de ordem 6k +/- 1
    % 4 - harmônicos de ordem 12k +/- 1
    % 5 - todos os componentes

%matriz dos indices harmonicos que serão gerados
ordem_h = zeros(n_casos,ordem_max);

ordem_h(1,1:2:25) = 1:2:25;
ordem_h(2,[1 3:3:25]) = [1 3:3:25];
ordem_h(3,[1 5 7 11 13 17 19 23 25]) = [1 5 7 11 13 17 19 23 25];
ordem_h(4,[1 11 13 23 25]) = [1 11 13 23 25];
ordem_h(5,1:25) = 1:25;

%porcentagem dos eventos a serem sorteados
%determina quais tipos de eventos devem ser gerados com mais frequencia, a
%soma dos valores dessa matriz devem ser igual a 100;
porcentagem = [20 25 25 25 5];
p_acc = cumsum(porcentagem);

%% Processamento do Programa

m=0;
while m<Nsinais
    
    %entrada dos harmônicos
    if(sv == 0)
        pt = 1;
    else
        pt = fix(unifrnd(2*length(t)/3,3*length(t)/4));%
    end
    
    %fase da componente fundamental
    fase=unifrnd(-pi,pi);
    
    %ruido de fundo
    var_ruido=1/2*10^(-SNR/10);
    ruido=sqrt(var_ruido)*randn(1,length(t));
    
    %componente fundamental
    fund = cos(2*pi*f0.*t+fase);
    
    %escolha das ordens dos harmônicos
    indice = randi(100);
    ind = find(p_acc > indice, 1 );
%     ind = 3;
    %soma dos componentes harmônicos
    harm=zeros(1,length(t(pt+1:end)));
    for n=find((ordem_h(ind,:) > 1) & (ordem_h(ind,:) < 18));
        ah=1/n;
        ph=unifrnd(-pi,pi);
        harm=harm+ah*cos(2*pi*n*f0*t(pt+1:end)+ph);
    end
    
    harm = [zeros(1,pt) harm];
        
    %cálulo da THD
    THD=sqrt(sum(harm.^2)/sum(fund.^2))*100;
    
    %armazenamento dos sinais com THD contida entre os dois valores especificados
    if THD>THD_min & THD<THD_max
        m=m+1;
        banco(:,m)=fund+harm+ruido;
        
        %porcentagem completa de execução do programa
        porcentagem=m/Nsinais*100;
        disp(['banco de harmônicos: ',num2str(porcentagem), '% completo'])
    end
end