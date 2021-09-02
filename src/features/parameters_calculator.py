import numpy as np
#import cmath #cmath.phase() or np.angle()
from scipy.fft import fft, fftfreq
from numba import njit, prange


def DER(signal):    
    signal_fft = abs(fft(np.array(signal)))
    m = len(signal) #(rows, columns)
    rms60 = 0
    rms_rest = 0
    for i in prange(0,60):
        rms60 += signal_fft[i]
    for j in prange(60,m):
        rms_rest += signal_fft[j]
    return rms_rest/rms60

@njit(parallel=True, fastmath=True)
#Function that Calculate Root Mean Square 
def rmsValue(matrix):
    [m, n] = matrix.shape #(rows, columns)
    square = 0
    mean = 0.0
    root = 0.0
      
    #Calculate square
    for j in prange(0,m-1):
        for i in prange(0,n-1):
            square += (matrix[j][i]**2)           
   
    #Calculate Mean 
    mean = (square / (float)(n*m))
      
    #Calculate Root
    root = (mean**(1/2))    
      
    return root

@njit(parallel=True, fastmath=True)
def p_skewness(matrix):
    [m, n] = matrix.shape #(rows, columns)
    sum = 0
    phases = np.zeros ((m,n))
    mean_phase = np.zeros(m)
    abs_matrix = np.abs(matrix) #abs   

    for j in prange(0,m-1): #row
        for i in prange(0,n-1): #column
            phases [j][i] = np.angle(matrix[j][i]) #to abs phase

    #abs_phase = np.abs(phases) #abs    

    for j in prange(0,m-1):  #row     
        mean_phase[j] = np.mean(phases[j][:]) #mean value of each row 
        for i in prange(0,n-1): #columns            
            sum += (phases[j][i]-mean_phase[j])**3
            
    p_skewness = sum/(m*n*((np.std(phases))**3))
   
    return np.abs(p_skewness)

@njit(parallel=True,fastmath=True)
def p_kurtosis(matrix):
    [m, n] = matrix.shape
    sum = 0
    mean_matrix = np.zeros(m)
    abs_matrix = np.abs(matrix) #abs   

    for j in prange(0,m-1):
        mean_matrix[j] = np.mean(abs_matrix[j][:]) #mean value of each row 
        for i in prange(0,n-1):
            sum += (abs_matrix[j][i]-mean_matrix[j])**3  

    p_kurtosis = sum/(m*n*((np.std(abs_matrix))**4))

    return p_kurtosis