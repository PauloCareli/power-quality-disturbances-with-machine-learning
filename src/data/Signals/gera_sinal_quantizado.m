clear all
close all
clc

%% Par�metros do Sinal
f1 = 60;        % Frequ�ncia Fundamental
Nppc = 128;     % N�mero de pontos por ciclo
fs = Nppc*f1;   % Frequ�ncia de amostragem
Ts = 1/fs;      % Periodo de Amostragem

tamanho_frame = 4;  % Tamanho do Frame Utilizado na Dete��o em ciclos
N_frames = 15;      % N�mero total de Frames a serem analisados + 2
Nppf = Nppc*tamanho_frame;

Nciclos = N_frames*tamanho_frame + 1; % N�mero de ciclos de sinal que serao gerados
t = (0:Nciclos*Nppc-1)*Ts;            % Vetor de tempo para gera��o do sinal

SNR = 30;                                    % Rela��o Sinal Ru�do
var_ruido = 1/2*10^(-SNR/10);                % Vari�ncia do Ru�do

%% Gera��o dos Sinais com Frequ�ncia Variante
% delta_f = 1;          % Varia��o na Frequ�ncia em Hz
% ciclo_ini = 14;       % Ciclo onde ir� come�ar a    varia��o
% ciclo_fim = 44;       % Ciclo onde ir� encerrar a varia��o
% tipo = 'senoidal';       % Tipo de varia��o de frequ�ncia que pode ser aplicada ('senoidal', 'rampa', 'degrau')
% 
% harms = 1;%[1 3 5 7 11 13]; % Ordem dos componentes harm�nicos que ser�o gerados
% 
% sinal = zeros(1,length(t));           % vetor que ira armazenar o sinal composto por componentes harm�nicos com frequencia variante
% ft = zeros(length(t),length(harms));  % vetor que ira armazenar o a fase total do sinal gerado
% f = zeros(length(t),length(harms));   % vetor que ira armazenar o a frequ�ncia do sinal gerado
% 
% for h = harms
%     fase = unifrnd(-pi,pi);
%     % A fun��o gera_seno_fv gera uma senoide de frequ�ncia variante conforme a variavel 'tipo' e frequ�ncia base 'f1',
%     % no intervalo especificado por 'ciclo_ini' e 'ciclo_fim'
%     [x_fv1,ft(:,h),f(:,h)] = gera_seno_fv(f1,fase,Ts,h,Nppc,Nciclos,delta_f,tipo,ciclo_ini,ciclo_fim);
%     
%     sinal = sinal +(1/h)*x_fv1; % Soma os harmonicos gerdos para formar o sinal.
% end
% ruido = sqrt(var_ruido)*randn(1,length(t)); % Gera��o do Ru�do com vari�ncia pr�-estabelecida
% 
% sinal = sinal + ruido;
% 
% % Plotagem da frequ�ncia do sinal gerado.
% %----------------------------------------
% figure
% plot(f(:,1))
% hold on
% for jj=2:N_frames
%     plot(jj*Nppf*ones(1,20)+1,linspace(min(f(:,1))-0.5,max(f(:,1))+0.5,20),'k-.')
%     if(jj > 2)
%         text(jj*Nppf-Nppf/2,max(f(:,1))+0.5,num2str(jj-2),'FontSize',18)
%     end
% end
%----------------------------------------

%% Gera��o dos Sinais com Dist�rbios

N_sinais = 1; % N�mero de Sinais com Dist�rbios a serem gerados 
% [banco t] = gera_banco_harmonicos(N_sinais,f1,fs,Nciclos,SNR);
% [banco t] = gera_banco_interrupcao(N_sinais,f1,fs,Nciclos,SNR);
% [banco t] = gera_banco_notches(N_sinais,f1,fs,Nciclos,SNR);
% [banco t] = gera_banco_sag(N_sinais,f1,fs,Nciclos,SNR);
% [banco t] = gera_banco_sag_fase(N_sinais,f1,fs,Nciclos,SNR);
% [banco t] = gera_banco_spikes(N_sinais,f1,fs,Nciclos,SNR);
% [banco t] = gera_banco_swell(N_sinais,f1,fs,Nciclos,SNR);
[banco t] = gera_banco_transitorio(N_sinais,f1,fs,Nciclos,SNR);
sinal = banco';

figure
plot(sinal)

%% Quantiza o Sinal

N_bits = 16;
nivel_max = 4; % PU

sinal_q = sinal*(2^(N_bits-nivel_max));

figure
plot(sinal_q)
hold on
plot(ones(1,length(sinal_q))*(2^(N_bits-1) - 1),'k')
plot(-ones(1,length(sinal_q))*2^(N_bits-1),'k')

% Saturacao
%-------------------------------------------------------
sinal_q(find(sinal_q >= 2^(N_bits-1))) = 2^(N_bits-1)-1;
sinal_q(find(sinal_q < -2^(N_bits-1))) = -2^(N_bits-1);

plot(sinal_q,'r')

%% Sinal Gerador

sinal_gerador = sinal_q/(2^(N_bits-1));

figure
plot(sinal_gerador)
hold on
plot(ones(1,length(sinal_gerador)),'k')
plot(-ones(1,length(sinal_gerador)),'k')

