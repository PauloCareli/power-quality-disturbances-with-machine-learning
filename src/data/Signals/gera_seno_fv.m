function [x_fv,ft,f] = gera_seno_fv(f1,fase,Ts,h,Nppc,Nciclos,delta_f,tipo,ciclo_ini,ciclo_fim)

if (strcmp(tipo,'senoidal'))   
        
    t = (0:ciclo_ini*Nppc-1)*Ts; 
    f = f1*ones(1,length(t));
    ft = (2*pi*h*f1*t + fase);
    x_fv = cos(ft);
    
    if((x_fv(end) - x_fv(end-1)) < 0)
        tet = acos(x_fv(end)); 
    else
        tet = 2*pi - acos(x_fv(end)); 
    end   
           
    t = (1:(ciclo_fim - ciclo_ini)*Nppc)*Ts;
    f2 = 1/t(end);
    f = [f (f1 + delta_f*sin(2*pi*f2*t))];
    ft = [ft (h*(2*pi*f1*t - (delta_f/f2)*(cos(2*f2*pi*t) - 1)) + tet)];
               
    x_fv = cos(ft);
        
    if((x_fv(end) - x_fv(end-1)) < 0)
        tet = acos(x_fv(end)); 
    else
        tet = 2*pi - acos(x_fv(end)); 
    end
    
    t = (1:(Nciclos - ciclo_fim)*Nppc)*Ts;
    f = [f f1*ones(1,length(t))]; 
    ft = [ft (2*pi*h*f1*t + tet)];
    
    x_fv = cos(ft);
    
    ft = wrapTo2Pi(ft);
    
end

if (strcmp(tipo,'rampa'))
    
    t = (0:ciclo_ini*Nppc-1)*Ts; 
    f = f1*ones(1,length(t));
    ft = (2*pi*h*f1*t + fase);
    x_fv = cos(ft);
    
    if((x_fv(end) - x_fv(end-1)) < 0)
        tet = acos(x_fv(end)); 
    else
        tet = 2*pi - acos(x_fv(end)); 
    end    
        
    t = (1:(ciclo_fim - ciclo_ini)*Nppc)*Ts;
    f = [f (f1 + (delta_f)/((ciclo_fim - ciclo_ini)*Nppc*Ts)*t)];
    a = (delta_f)/((ciclo_fim - ciclo_ini)*Nppc*Ts);
    ft = [ft (2*pi*h*(f1*t + (a/2)*t.^2) + tet)];
    
    x_fv = cos(ft);
    
    if((x_fv(end) - x_fv(end-1)) < 0)
        tet = acos(x_fv(end)); 
    else
        tet = 2*pi - acos(x_fv(end)); 
    end
    t = (1:(Nciclos - ciclo_fim)*Nppc)*Ts;
    f = [f (f1 + delta_f)*ones(1,length(t))];
                  
    if(delta_f > 0)
        ft = [ft (2*pi*h*((f1 + delta_f)*t) + tet)];
    else
        ft = [ft (2*pi*h*((f1 + delta_f)*t) - tet)];
    end
    
    x_fv = cos(ft);
    
    ft = wrapTo2Pi(ft);
    
end

if (strcmp(tipo,'degrau'))
    
    t = (0:ciclo_ini*Nppc-1)*Ts; 
    f = f1*ones(1,length(t));
    ft = (2*pi*h*f1*t + fase); 
    x_fv = cos(ft);
    
    if((x_fv(end) - x_fv(end-1)) < 0)
        tet = acos(x_fv(end)); 
    else
        tet = 2*pi - acos(x_fv(end)); 
    end    
    
    t = (1:(ciclo_fim - ciclo_ini)*Nppc)*Ts;
    f = [f (f1 + delta_f)*ones(1,length(t))];
    a = (delta_f);
    
    ft = [ft (2*pi*h*((f1 + a)*t) + tet)];    
    
    x_fv = cos(ft);
        
    if((x_fv(end) - x_fv(end-1)) < 0)
        tet = acos(x_fv(end)); 
    else
        tet = 2*pi - acos(x_fv(end)); 
    end
    t = (1:(Nciclos - ciclo_fim)*Nppc)*Ts;
    f = [f f1*ones(1,length(t))];
      
    if(a > 0)
        ft = [ft (2*pi*h*f1*t + tet)];
    else
        ft = [ft (2*pi*h*f1*t - tet)];
    end
    
    x_fv = cos(ft);
        
    ft = wrapTo2Pi(ft);

end
end