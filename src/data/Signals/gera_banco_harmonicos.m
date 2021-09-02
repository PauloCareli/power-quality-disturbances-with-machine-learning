function [banco t fase] = gera_banco_harmonicos(Nsinais,f0,fs,Nciclos,SNR,sv)
%
%% Descri��o: Fun��o para gera��o de banco de dados com harm�nicos
%% Autores: CRISTIANO A. G. MARQUES, LUCAS R. FREITAS, LUCAS OLIVEIRA
%% Data: julho de 2008
%% Refer�ncias do programa:
%   IEEE Std 1159-1995
%   (IEEE Recommended Practice for Monitoring Electric Power Quality)
%
%   IEEE SM 519-1992
%   (IEEE Recommended Practices and Requirements for Harmonic Control in
%   Electrical Power Systems)
%% Descri�ao do Programa
%
% Entradas:
%           Nsinais - n�mero de sinais a serem gerados;
%           f0 - frequ�ncia fundamental do sinal;
%           fs - frequ�ncia de amostragem;
%           Nciclos - n�mero de ciclos da fundamental dos sinais a serem gerados;
%           pt - ponto de inicio dos harm�nicos em segundos (entrada da carga n�o-linear);
%           SNR - rela��o sinal ruido em dB (rela��o de pot�ncia entre fundamental e ru�do);
%
% Saidas:
%           banco - matriz na qual os sinais est�o armazenados em suas colunas
%           t - vetor armazenando o eixo dos tempos
%
% Observa��o:
%           1)As refer�ncias apenas cont�m os valores t�picos de entrada do
%             programa.
%           2)O programa gera os sinais com alguns par�metros pr�-especificados dos harm�nicos.
%             Neste caso, se necess�rio, deve-se alterar tais par�metros na parte "Entradas adicionais"


%% Entradas adicionais (alterar se necess�rio)

%m�xima ordem do harm�nico presente no sinal;
ordem_max=25;

%minima taxa de distor��o harm�nica em porcentagem que um sinal pode conter no banco (valor arbitr�rio);
THD_min=5;

%m�xima taxa de distor��o harm�nica em porcentagem que um sinal pode conter no banco (valor arbitr�rio);
THD_max=100;

%eixo dos tempos
t=0:1/fs:Nciclos/60-1/fs;

% casos a serem gerados
n_casos = 5;
    % 1 - somente harm�niocs �mpares
    % 2 - harm�niocs m�ltiplos de 3
    % 3 - harm�nicos de ordem 6k +/- 1
    % 4 - harm�nicos de ordem 12k +/- 1
    % 5 - todos os componentes

%matriz dos indices harmonicos que ser�o gerados
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
    
    %entrada dos harm�nicos
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
    
    %escolha das ordens dos harm�nicos
    indice = randi(100);
    ind = find(p_acc > indice, 1 );
%     ind = 3;
    %soma dos componentes harm�nicos
    harm=zeros(1,length(t(pt+1:end)));
    for n=find((ordem_h(ind,:) > 1) & (ordem_h(ind,:) < 18));
        ah=1/n;
        ph=unifrnd(-pi,pi);
        harm=harm+ah*cos(2*pi*n*f0*t(pt+1:end)+ph);
    end
    
    harm = [zeros(1,pt) harm];
        
    %c�lulo da THD
    THD=sqrt(sum(harm.^2)/sum(fund.^2))*100;
    
    %armazenamento dos sinais com THD contida entre os dois valores especificados
    if THD>THD_min & THD<THD_max
        m=m+1;
        banco(:,m)=fund+harm+ruido;
        
        %porcentagem completa de execu��o do programa
        porcentagem=m/Nsinais*100;
        disp(['banco de harm�nicos: ',num2str(porcentagem), '% completo'])
    end
end