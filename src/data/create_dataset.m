clear all; close all; clc;

addpath('./Signals');

export_name = '256_2k_45SNR_14possibilidades_dataset.csv';

% Parametros usados no TCC:
% clear all; close all; clc;
% 
% f0 = 60;
% fs = 256*60; %256*60,128*60
% Nciclos = 12;
% SNR = 40;
% n = 1; %n de bancos por vez
% pt = 1; %início
% n_sinais = 20000;
% n_bancos = 14;

f0 = 60;
fs = 256*60; %256*60,128*60
Nciclos = 12;
SNR = 45;
n = 1; %n de bancos por vez
pt = 1; %início
n_sinais = 2000;
n_bancos = 14;

dataset = zeros(fs*Nciclos/f0,1); %dataset inicializado com zeros para poder concatenar com os demais os dados das funcoes

% ------Distúrbios:
% 1.	Normal - gera_banco_senoidal.m
% 2.	Swell - gera_banco_swell.m
% 3.	Sag - gera_banco_sag.m
% 4.	Interruption - gera_banco_interrupcao.m
% 5.	Flicker - gera_banco_flutuacao_tensao.m
% 6.	Oscillatory transient - gera_banco_transitorio.m
% 7.	Notch - gera_banco_notches.m
% 8.	Spike - gera_banco_spikes.m
% 9.	Harmonics - gera_banco_harmonicos.m
% 10.	Flicker and harmonics
% 11.	Sag and harmonics
% 12.	Swell and harmonics
% 13.	Interruption and Harmonics
% 14.   Oscillatory transient and harmonic

%gera n_sinais aleatórios
for i = 1:1:n_sinais
    random = randi(n_bancos);
    switch random        
        case 1
            [banco t] = gera_banco_senoidal(n,f0,fs,Nciclos,SNR);%ok
            tipo(i) = "senoidal";
            dataset = [dataset banco];         
                        
        case 2
            [banco t] = gera_banco_swell(n,f0,fs,Nciclos,SNR);%ok
            tipo(i) = "swell";
            dataset = [dataset banco];   
                        
        case 3
            [banco t] = gera_banco_sag(n,f0,fs,Nciclos,SNR);%ok
            tipo(i) = "sag";
            dataset = [dataset banco];
          
        case 4
            [banco t] = gera_banco_interrupcao(n,f0,fs,Nciclos,SNR); %ok
            tipo(i) = "interruption";
            dataset = [dataset banco]; 
                     
        case 5
            [banco t] = gera_banco_flutuacao_tensao(n,f0,fs,Nciclos,SNR);%ok
            tipo(i) = "flicker";
            dataset = [dataset banco];             
           
        case 6
            [banco t] = gera_banco_transitorio(n,f0,fs,Nciclos,SNR); %ok
            tipo(i) = "transitorio_oscilatorio";
            dataset = [dataset banco];             
            
        case 7            
            [banco t] = gera_banco_notches(n,f0,fs,Nciclos,SNR); %ok
            tipo(i) = "notches";
            dataset = [dataset banco];
            
        case 8
            [banco t] = gera_banco_spikes(n,f0,fs,Nciclos,SNR);%ok
            tipo(i) = "spikes";
            dataset = [dataset banco];                                 
          
        case 9
            [banco t] = gera_banco_harmonicos(n,f0,fs,Nciclos,SNR,pt); %quando utilizaria o pt = 0 ?
            tipo(i) = "harmonico";
            dataset = [dataset banco];
            
        case 10
            [banco t] = gera_banco_harmonicos_and(n,f0,fs,Nciclos,SNR,pt,'flicker');%ok    
            tipo(i) = "flicker_and_harmonic";
            dataset = [dataset banco]; 
        
        case 11
            [banco t] = gera_banco_harmonicos_and(n,f0,fs,Nciclos,SNR,pt,'sag');%ok    
            tipo(i) = "sag_and_harmonic";
            dataset = [dataset banco];            
 
        case 12
            [banco t] = gera_banco_harmonicos_and(n,f0,fs,Nciclos,SNR,pt,'swell');%ok    
            tipo(i) = "swell_and_harmonic";
            dataset = [dataset banco];           
 
        case 13
            [banco t] = gera_banco_harmonicos_and(n,f0,fs,Nciclos,SNR,pt,'interrupcao');%ok    
            tipo(i) = "interruption_and_harmonic";
            dataset = [dataset banco];
 
        case 14
            [banco t] = gera_banco_harmonicos_and(n,f0,fs,Nciclos,SNR,pt,'transitorio');%ok    
            tipo(i) = "oscillatory_transient_and_harmonic";
            dataset = [dataset banco];  
            
    end
    
    display_percentage = sprintf('%d bancos completos - %.2f%% completo.',i,(i/n_sinais)*100);
    disp(display_percentage)
    disp(display_percentage)
    disp(display_percentage)
end

disp('Creating Dataset')
dataset(:,1)=[]; %deleta a coluna de zeros
dataset = transpose(dataset); 
tipo = transpose(tipo);

final_dataset = table(dataset);
tipo = table(tipo);
final_dataset = [final_dataset tipo]; %alinha sinais com seu determinado tipo para manipulação posterior

writetable(final_dataset, export_name) %salva o dataset em .csv
disp('Dataset Created!')

plot_signals(f0,fs,Nciclos,SNR,n,pt,n_bancos); %plota os sinais

% utilizando os comandos para dataset do matlab (site indica como não
% recomendados)
% final_dataset = mat2dataset(dataset);
% tipo = mat2dataset(tipo);
% final_dataset = [final_dataset tipo]; %alinha sinais com seu determinado tipo para manipulação posterior
% export(final_dataset,'File','bancoharmonicos.csv','Delimiter',',')


% figure
% plot(banco);
% figure
% plot(banco(:,1)); %1 sinal
% x = banco(:,1);
% 
% load('bancoIEEE.mat')
% figure
% plot(bancoIEEE);
% figure
% plot(bancoIEEE(:,1)); %1 sinal
% csvwrite('bancoIEEE.csv',banco) %salva banco IEE em .csv
% csvwrite('bancoharmonicos.csv',final_dataset) %salva banco de harmonicos em .csv









