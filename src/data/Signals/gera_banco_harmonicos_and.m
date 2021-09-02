function [banco t fase] = gera_banco_harmonicos_and(Nsinais,f0,fs,Nciclos,SNR,sv,soma)
%
%% Descri��o: Fun��o para gera��o de banco de dados com harm�nicos e outra disturb�ncia
%% Autores: Paulo Careli
%% Baseado nos c�digos dos autores: CRISTIANO A. G. MARQUES, LUCAS R. FREITAS, LUCAS OLIVEIRA
%% Data: maio de 2021

%% Descri�ao do Programa
%
% Entradas:
%           Nsinais - n�mero de sinais a serem gerados;
%           f0 - frequ�ncia fundamental do sinal;
%           fs - frequ�ncia de amostragem;
%           Nciclos - n�mero de ciclos da fundamental dos sinais a serem gerados;
%           pt - ponto de inicio dos harm�nicos em segundos (entrada da carga n�o-linear);
%           SNR - rela��o sinal ruido em dB (rela��o de pot�ncia entre fundamental e ru�do);
%           sv  - 0, 1
%           soma - dist�rbio adicional junto ao harmonico (
%           flicker (flutuacao_tensao), sag, swell, interrupcao,
%           transitorio, none)
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

%numero de pontos por ciclo
Nppc = fs/60;

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
%determina quais somas de eventos devem ser gerados com mais frequencia, a
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
    
    if (strcmp(soma,'flicker'))   
        %amplitude m�ninima da flutua��o de tens�o;   
        a_min=3/100;

        %amplitude m�xima da flutua��o de tens�o;    
        a_max=7/100;

        %frequ�ncia m�ninima da flutua��o de tens�o;     
        f_min=1;

        %frequ�nciae m�xima da flutua��o de tens�o;                                       
        f_max=25;
        %amplitude do dist�rbio
        a=unifrnd(a_min,a_max); 

        %frequ�ncia do dist�rbio
        fd=unifrnd(f_min,f_max); 

        flut = (1+a*sin(2*pi*fd*t(pt+1:end)));
        flut = [ones(1,pt) flut];

        %gera��o do sinal fundamental
        fund=flut.*cos(2*pi*f0*t+fase);
    end
    
    if (strcmp(soma,'sag'))   
        %amplitude m�ninima do sag;   
        a_min=0.2;

        %amplitude m�xima do sag;                                       
        a_max=0.9;

       %amplitude do dist�rbio
        a=unifrnd(a_min,a_max); 

        %inicio do sag
        pt = fix(unifrnd(1*length(t)/4,3*length(t)/4));

        %dura��o do sag
        dpt=fix(unifrnd(0.5*Nppc,min([Nciclos*Nppc-pt-1 30*Nppc]))); %=> varia��o da dura��o do dist�rbio entre 0.5 a 30 ciclos

        %decaimento e subida do sag
        dec = a + exp(-(t(1:dpt)/0.01)+log(1-a));
        sub = 1 - exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(1-a));

        %disturbio
        sag = [ones(1,pt) dec.*ones(1,dpt) sub.*ones(1,length(t)-(pt+dpt))];

        %gera��o do sinal fundamental + disturbio
        fund=cos(2*pi*f0.*t+fase).*sag;
    end
    
    if (strcmp(soma,'swell'))
        %amplitude m�ninima do swell;   
        a_min=1.1;

        %amplitude m�xima do swell;                                       
        a_max=1.9;
        
        a=unifrnd(a_min,a_max); 

        %inicio do sag
        pt = fix(unifrnd(Nppc,length(t)/2));

        %dura��o do sag
        dpt=fix(unifrnd(0.5*Nppc,min([Nciclos*Nppc-pt-1 30*Nppc]))); %=> varia��o da dura��o do dist�rbio entre 0.5 a 30 ciclos

        %decaimento e subida do swell
        sub = a - exp(-(t(1:dpt)/0.01)+log(a-1));
        dec = 1 + exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(a-1));

        %disturbio
        swell = [ones(1,pt) sub.*ones(1,dpt) dec.*ones(1,length(t)-(pt+dpt))];

        %gera��o do sinal fundamental + disturbio
        fund=cos(2*pi*f0*t+fase).*swell;
    end
    
    if (strcmp(soma,'interrupcao'))   
        %amplitude m�ninima da interrup��o;   
        a_min=0;

        %amplitude m�xima da interrup��o;                                       
        a_max=0.1;

        %amplitude do dist�rbio
        a=unifrnd(a_min,a_max); 

        %dura��o da interrup��o
        dpt=fix(unifrnd(0.5*Nppc,9*Nppc)); %=> varia��o da dura��o do dist�rbio entre 0.5 a 30 ciclos

        %inicio da interrup��o
        pt = fix(unifrnd(3*Nppc,length(t)-dpt));

        %decaimento e subida da interrup��o
        dec = a + exp(-(t(1:dpt)/0.01)+log(1-a));
        sub = 1 - exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(1-a));

        %disturbio
        int = [ones(1,pt) dec.*ones(1,dpt) sub.*ones(1,length(t)-(pt+dpt))];

        %gera��o do sinal fundamental + disturbio
        fund=cos(2*pi*f0*t+fase).*int;
    end
    
    if (strcmp(soma,'transitorio'))  
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
        fund=fund+trans;
      end

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
        disp(['banco de harm�nicos e ',soma, ': ',num2str(porcentagem), '% completo'])
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