function [banco t fase] = gera_banco_harmonicos_and(Nsinais,f0,fs,Nciclos,SNR,sv,soma)
%
%% Descrição: Função para geração de banco de dados com harmônicos e outra disturbância
%% Autores: Paulo Careli
%% Baseado nos códigos dos autores: CRISTIANO A. G. MARQUES, LUCAS R. FREITAS, LUCAS OLIVEIRA
%% Data: maio de 2021

%% Descriçao do Programa
%
% Entradas:
%           Nsinais - número de sinais a serem gerados;
%           f0 - frequência fundamental do sinal;
%           fs - frequência de amostragem;
%           Nciclos - número de ciclos da fundamental dos sinais a serem gerados;
%           pt - ponto de inicio dos harmônicos em segundos (entrada da carga não-linear);
%           SNR - relação sinal ruido em dB (relação de potência entre fundamental e ruído);
%           sv  - 0, 1
%           soma - distúrbio adicional junto ao harmonico (
%           flicker (flutuacao_tensao), sag, swell, interrupcao,
%           transitorio, none)
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

%numero de pontos por ciclo
Nppc = fs/60;

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
%determina quais somas de eventos devem ser gerados com mais frequencia, a
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
    
    if (strcmp(soma,'flicker'))   
        %amplitude míninima da flutuação de tensão;   
        a_min=3/100;

        %amplitude máxima da flutuação de tensão;    
        a_max=7/100;

        %frequência míninima da flutuação de tensão;     
        f_min=1;

        %frequênciae máxima da flutuação de tensão;                                       
        f_max=25;
        %amplitude do distúrbio
        a=unifrnd(a_min,a_max); 

        %frequência do distúrbio
        fd=unifrnd(f_min,f_max); 

        flut = (1+a*sin(2*pi*fd*t(pt+1:end)));
        flut = [ones(1,pt) flut];

        %geração do sinal fundamental
        fund=flut.*cos(2*pi*f0*t+fase);
    end
    
    if (strcmp(soma,'sag'))   
        %amplitude míninima do sag;   
        a_min=0.2;

        %amplitude máxima do sag;                                       
        a_max=0.9;

       %amplitude do distúrbio
        a=unifrnd(a_min,a_max); 

        %inicio do sag
        pt = fix(unifrnd(1*length(t)/4,3*length(t)/4));

        %duração do sag
        dpt=fix(unifrnd(0.5*Nppc,min([Nciclos*Nppc-pt-1 30*Nppc]))); %=> variação da duração do distúrbio entre 0.5 a 30 ciclos

        %decaimento e subida do sag
        dec = a + exp(-(t(1:dpt)/0.01)+log(1-a));
        sub = 1 - exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(1-a));

        %disturbio
        sag = [ones(1,pt) dec.*ones(1,dpt) sub.*ones(1,length(t)-(pt+dpt))];

        %geração do sinal fundamental + disturbio
        fund=cos(2*pi*f0.*t+fase).*sag;
    end
    
    if (strcmp(soma,'swell'))
        %amplitude míninima do swell;   
        a_min=1.1;

        %amplitude máxima do swell;                                       
        a_max=1.9;
        
        a=unifrnd(a_min,a_max); 

        %inicio do sag
        pt = fix(unifrnd(Nppc,length(t)/2));

        %duração do sag
        dpt=fix(unifrnd(0.5*Nppc,min([Nciclos*Nppc-pt-1 30*Nppc]))); %=> variação da duração do distúrbio entre 0.5 a 30 ciclos

        %decaimento e subida do swell
        sub = a - exp(-(t(1:dpt)/0.01)+log(a-1));
        dec = 1 + exp(-(t(1:length(t)-(pt+dpt))/0.01)+log(a-1));

        %disturbio
        swell = [ones(1,pt) sub.*ones(1,dpt) dec.*ones(1,length(t)-(pt+dpt))];

        %geração do sinal fundamental + disturbio
        fund=cos(2*pi*f0*t+fase).*swell;
    end
    
    if (strcmp(soma,'interrupcao'))   
        %amplitude míninima da interrupção;   
        a_min=0;

        %amplitude máxima da interrupção;                                       
        a_max=0.1;

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
    end
    
    if (strcmp(soma,'transitorio'))  
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
        fund=fund+trans;
      end

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
        disp(['banco de harmônicos e ',soma, ': ',num2str(porcentagem), '% completo'])
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