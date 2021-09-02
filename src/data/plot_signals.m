function [n_signals_plotted] = plot_signals(f0,fs,Nciclos,SNR,n,pt,n_bancos)
    
    dataset_plot = [];
    
    for i = 1:1:n_bancos        
        switch i        
            case 1
                [banco t] = gera_banco_senoidal(n,f0,fs,Nciclos,SNR);%ok
                tipo(i) = "Senoidal";
                dataset_plot = [dataset_plot banco];         

            case 2
                [banco t] = gera_banco_swell(n,f0,fs,Nciclos,SNR);%ok
                tipo(i) = "Swell";
                dataset_plot = [dataset_plot banco];   

            case 3
                [banco t] = gera_banco_sag(n,f0,fs,Nciclos,SNR);%ok
                tipo(i) = "Sag";
                dataset_plot = [dataset_plot banco];

            case 4
                [banco t] = gera_banco_interrupcao(n,f0,fs,Nciclos,SNR); %ok
                tipo(i) = "Interrupção";
                dataset_plot = [dataset_plot banco]; 

            case 5
                [banco t] = gera_banco_flutuacao_tensao(n,f0,fs,Nciclos,SNR);%ok
                tipo(i) = "Flutuação de tensão";
                dataset_plot = [dataset_plot banco];             

            case 6
                [banco t] = gera_banco_transitorio(n,f0,fs,Nciclos,SNR); %ok
                tipo(i) = "Transitório oscilatório";
                dataset_plot = [dataset_plot banco];             

            case 7            
                [banco t] = gera_banco_notches(n,f0,fs,Nciclos,SNR); %ok
                tipo(i) = "Notch";
                dataset_plot = [dataset_plot banco];

            case 8
                [banco t] = gera_banco_spikes(n,f0,fs,Nciclos,SNR);%ok
                tipo(i) = "Spike";
                dataset_plot = [dataset_plot banco];                                 

            case 9
                [banco t] = gera_banco_harmonicos(n,f0,fs,Nciclos,SNR,pt); %quando utilizaria o pt = 0 ?
                tipo(i) = "Harmônico";
                dataset_plot = [dataset_plot banco];

            case 10
                [banco t] = gera_banco_harmonicos_and(n,f0,fs,Nciclos,SNR,pt,'flicker');%ok    
                tipo(i) = "Flutuação de tensão com harmônico";
                dataset_plot = [dataset_plot banco]; 

            case 11
                [banco t] = gera_banco_harmonicos_and(n,f0,fs,Nciclos,SNR,pt,'sag');%ok    
                tipo(i) = "Sag com harmônico";
                dataset_plot = [dataset_plot banco];            

            case 12
                [banco t] = gera_banco_harmonicos_and(n,f0,fs,Nciclos,SNR,pt,'swell');%ok    
                tipo(i) = "Swell com harmônico";
                dataset_plot = [dataset_plot banco];           

            case 13
                [banco t] = gera_banco_harmonicos_and(n,f0,fs,Nciclos,SNR,pt,'interrupcao');%ok    
                tipo(i) = " Interrupção com harmônico";
                dataset_plot = [dataset_plot banco];

            case 14
                [banco t] = gera_banco_harmonicos_and(n,f0,fs,Nciclos,SNR,pt,'transitorio');%ok    
                tipo(i) = "Transitório oscilatório com harmônico";
                dataset_plot = [dataset_plot banco];  

        end
        
        
        if(not(rem(i, 2) == 0)) figure(i); end
        
        subplot(1,2,1);       
        
        if(rem(i, 2) == 0) subplot(1,2,2); end
        
        plot(t, banco)         
        title(tipo(i));
        
        xlabel('Tempo (s)');
        ylabel('Amplitude (V)');
        
    end
end
