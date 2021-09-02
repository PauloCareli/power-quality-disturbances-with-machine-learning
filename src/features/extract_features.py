import numpy as np
import pandas as pd
from scipy.signal import chirp
import matplotlib.pyplot as plt
import stockwell 

import sys #insert a new path to get the parameters_calculator
# insert at 1, 0 is the script path (or '' in REPL)
sys.path.insert(1, 'src/features')
import parameters_calculator

import time


t = np.linspace(0, 10, 5001)
t_df = np.linspace(0, 10, 3072)
w = chirp(t, f0=12.5, f1=2.5, t1=10, method='linear')

print('Importing dataset...')
df_input = '256_20k_14possibilidades_dataset' 
df_input_extension = '.csv'
df = pd.read_csv("data/raw/" + df_input + df_input_extension) #import your dataset generated with .m files
print('Import complete')

#teste = df['banco1'].values #df to array
#plt.plot(t_df,df['banco1']) #plot a signal
#plt.show()

df_original = df
tipo = df['tipo']
df = df.drop(columns=df.columns[-1]) #remove the last column which contains the types of each signal
df = df.T
column_n = len(df.columns)

fmin = 0  # Hz
fmax = 60 # Hz
d_f = 1./(t[-1]-t[0])  # sampling step in frequency domain (Hz)
fmin_samples = int(fmin/d_f)
fmax_samples = int(fmax/d_f)

d_fdf = 1./(t_df[-1]-t_df[0])  # sampling step in frequency domain (Hz)
fmin_samples_df = int(fmin/d_fdf)
fmax_samples_df = int(fmax/d_fdf)

data = []
print('Starting Feature extraction...')
for column in df:
    start = time.time()
    #teste = df[column].values
    pd_stock = stockwell.st(df[column],fmin_samples_df,fmax_samples_df)
    pd_stock = stockwell.st(df[1],fmin_samples_df,fmax_samples_df)
    #np.save('st_dataset.npy', pd_stock) #save s-transform array
    #pd_stock = np.load('st_dataset.npy') #load s-transform array
    """ plt.plot(pd_stock)
    plt.show() """

    #stock = stockwell.st(w, fmin_samples, fmax_samples)  
    

    """ # ------------ PLOT ------------
    extent = (t[0], t[-1], fmin, fmax)
    extent_df = (t_df[0], t_df[-1], fmin, fmax)
    
    fig, ax = plt.subplots(2, 1, sharex=True)
    ax[0].plot(t, w)
    ax[0].set(ylabel='amplitude')
    ax[1].imshow(np.abs(stock), origin='lower', extent=extent)
    ax[1].axis('tight')
    ax[1].set(xlabel='time (s)', ylabel='frequency (Hz)')
    plt.show()

    chosen_signal = 1
    tipo[chosen_signal] #shows which one was the signal chosen

    fig, ax = plt.subplots(2, 1, sharex=True) #check the "tipo" dataframe to see which signal you are ploting
    fig.suptitle("Sinal antes e depois da Transformada de Stockwell", fontsize = 16)

    ax[0].plot(t_df, df[chosen_signal])
    ax[0].set(ylabel='Amplitude')
    ax[0].set_title("Swell com Harmônico antes da Transformada de Stockwell")

    ax[1].imshow(np.abs(pd_stock), origin='lower', extent=extent_df)
    ax[1].axis('tight')
    ax[1].set(xlabel='time (s)', ylabel='Frequência (Hz)')
    ax[1].set_title("Swell com Harmônico depois da Transformada de Stockwell")
    plt.show()
    """
    
    #calculating the 9 features:
    F1 = np.max(np.abs(pd_stock)) #maximum
    F2 = np.min(np.abs(pd_stock)) #minimum
    F3 = np.mean(np.abs(pd_stock)) #mean value    
    F4 = parameters_calculator.rmsValue(np.abs(pd_stock)) #RMS
    F5 = parameters_calculator.DER(df[column]) #DER (DIsturbance Energy Ratio) 
    F6 = np.std(np.abs(pd_stock)) #Standard deviation
    F7 = np.var(np.abs(pd_stock)) #variance    
    F8 = parameters_calculator.p_skewness(pd_stock) #Skewness (phase)
    F9 = parameters_calculator.p_kurtosis(pd_stock) #kurtosis
    
    F_parameters = np.array([F1,F2,F3,F4,F5,F6,F7,F8,F9]) 
    data.append(F_parameters) #create a matrix with the extracted features

    print(column, ' feature set complete - ', round((column/column_n)*100, 2),'%')
    end = time.time()
    print("time taken: %s seconds" %round((end-start),3), " - ", "Time left to complete all sets: ", round((end-start)*(column_n-column)/60,3), "minutes" )

F_columns = ["F1","F2","F3","F4","F5","F6","F7","F8","F9"] #create index for our dataframe
df_parameters = pd.DataFrame(data=data,columns=F_columns) #create dataframe
df_parameters['tipo'] = tipo.values #add column "tipo" that has the type of each signal
df_output = df_input + '_features' + df_input_extension
path = 'data\processed\\'
df_parameters.to_csv(path + df_output) #export and save the new dataset with extracted features
print("Dataset export complete")



