########## Libraries ##########
import sys
import os
import json
import numpy as np

########## Globals ##########
"""
    Path_Instances 
        Path of TSP instances in your
    max_calls_obj_func (global variable)
        Minimum of calls for end parametrization.
    obj_func_calls (global variable)
        Counter of every time that
        the objective function is called.
"""
Path_Instances = "C:/Users/Benjamin Gonzalez/Desktop/Workspace/Metaheuristicas_final/Instances/Experimental"
Path_Params = 'C:/Users/Benjamin Gonzalez/Desktop/Workspace/Metaheuristicas_final/Results/Parameters/Parte2_P/best_GAc_OX_invertion_params.txt'
Path_OPT = "C:/Users/Benjamin Gonzalez/Desktop/Workspace/Metaheuristicas_final/Optimals/Experimental/Optimals.txt"
output_directory = 'Results/Experimentals'


########## Own files ##########
# Path from the workspace.
sys.path.append("C:/Users/Benjamin Gonzalez/Desktop/Workspace/Metaheuristicas_final/Libraries")
from ReadTSP import ReadTsp # type: ignore
from ReadTSP import ReadTSP_optTour # type: ignore
from TabuSearch import ObjFun  # type: ignore
from TabuSearch import TabuSearch  # type: ignore
from GeneticAlgorithm_classic import GAc_PMX_swap # type: ignore
from GeneticAlgorithm_classic import GAc_OX_invertion # type: ignore
from GeneticAlgorithm_classic import GAc_PBX_scramble # type: ignore
from GeneticAlgorithm_C9 import GAe_PMX_swap # type: ignore
from GeneticAlgorithm_C9 import GAe_OX_invertion # type: ignore
from GeneticAlgorithm_C9 import GAe_PBX_scramble # type: ignore

########## Secundary functions ##########

def Read_Content(filenames_Ins, filenames_Opt):
    """
        Read_Content (function)
            Input: File names of TSP instances and
            optimal tour associated to TSP instances.
            Output: Distance Matrix and optimal solution
            permutation vector.
            Description: Read content.
    """
    # Instances and OPT_tour.
    Instances = []

    # Reading files.
    for file in filenames_Ins:
        Instances.append(ReadTsp(file))

    OPT_Instances = ReadTSP_optTour(filenames_Opt)

    return Instances, OPT_Instances

def load_best_params(file_path):
    """
    load_best_params (function)
        Input: File path to the best parameters.
        Output: Dictionary with best parameters.
        Description: Reads the best parameters from a JSON or text file.
    """
    with open(file_path, 'r') as file:
        params = json.load(file)
    return params

def write_results(file_path, results):
    """
    write_results (function)
        Input: File path to save the results and a list of results.
        Output: None.
        Description: Writes the results and corresponding errors to a text file.
    """
    with open(file_path, 'w') as file:
        for result in results:
            # Descomponer el resultado en el valor de la función objetivo y el error
            obj_value, error = result
            file.write(f"Objective Value: {obj_value}, Error: {error}\n")

def kendall_tau_distance(pi1, pi2):
    """
    Calcula la distancia de Kendall Tau entre dos permutaciones,
    ignorando pares iguales pero invertidos.

    Args:
        pi1 (np.array): Primera permutación (arreglo de enteros).
        pi2 (np.array): Segunda permutación (arreglo de enteros).

    Returns:
        int: Número de inversiones o distancia de Kendall Tau.
    """
    # Asegurarse de que las permutaciones tengan la misma longitud
    if len(pi1) != len(pi2):
        raise ValueError("Las permutaciones deben tener la misma longitud.")
    
    n = len(pi1)
    
    # Crear un diccionario de posiciones de los elementos en pi2
    pos_in_pi2 = {value: index for index, value in enumerate(pi2)}
    
    # Convertir pi1 a los índices de pi2
    pi1_indices_in_pi2 = [pos_in_pi2[value] for value in pi1]

    # Contar el número de inversiones (pares invertidos)
    inversions = 0
    for i in range(n):
        for j in range(i + 1, n):
            # Verificar si hay inversión y que los elementos no sean iguales
            if (pi1_indices_in_pi2[i] > pi1_indices_in_pi2[j] and
                pi1[i] != pi1[j]):
                inversions += 1

    return inversions


def kendall_tau_statistics(permutations):
    """
    Calcula la media, mediana y desviación estándar de las distancias de Kendall
    entre cada par de permutaciones en una lista de permutaciones.

    Args:
        permutations (list of np.array): Lista de permutaciones.

    Returns:
        dict: Diccionario con la media, mediana y desviación estándar de las distancias de Kendall.
    """
    n = len(permutations)
    distances = []

    # Comparar cada par de permutaciones
    for i in range(n):
        for j in range(i + 1, n):
            dist = kendall_tau_distance(permutations[i], permutations[j])
            distances.append(dist)
    
    # Calcular media, mediana y desviación estándar
    mean_distance = np.mean(distances)
    median_distance = np.median(distances)
    std_dev_distance = np.std(distances)

    return {
        'mean': mean_distance,
        'median': median_distance,
        'std_dev': std_dev_distance
    }

########## Procedure ##########

# Obtain TSP's instances.
Content_Instances = os.listdir(Path_Instances)
files_Instances = []
for file in Content_Instances:
    if(os.path.isfile(os.path.join(Path_Instances,file))):
        files_Instances.append(Path_Instances+"/"+file)

# Obtain TSP Instances and optimal tour
# corresponding to each one.
Instances, Opt_Instances = Read_Content(files_Instances, Path_OPT)

# Params.
#best_params = load_best_params(Path_Params)
#results_file_path = output_directory + '/genetic_algorithm_results_318_4000000.txt'
best_params = load_best_params(Path_Params)
results_file_path = output_directory + '/GAe_PMX_sw_results_194_80000.txt'

# Using best parameters to obtain solutions.
n = len(Instances)
results = []
#for Instance, opt_value in zip(Instances, Opt_Instances):

for i in range(11):
        result, _ = GAc_OX_invertion(best_params['POP_SIZE'], 
                                      Instances[1], 
                                      len(Instances[1]),
                                      80000,
                                      best_params['T_SIZE'],
                                      best_params['C_RATE'], 
                                      best_params['M_RATE'])
        
        """print("iteración número: {}".format(i+1))
        for j in range(200):
            print(kendall_tau_statistics(result[j]))"""
        # Calcular el valor de la función objetivo para la solución obtenida
        #obj_value = ObjFun(result, Instances[1])

        # Calcular el error respecto al valor óptimo
        #error = (obj_value - Opt_Instances[0]) / Opt_Instances[0]
        #error = (obj_value - Opt_Instances[1]) / Opt_Instances[1]
        error = (ObjFun(result[0], Instances[1]) - Opt_Instances[1]) / Opt_Instances[1]
        
        # Guardar el resultado y el error
        #results.append((obj_value, error))
        #results.append((result[1], error))
        
        # Imprimir el valor de la función objetivo para la solución obtenida.
        #print(f"Objective Value: {obj_value}, Error: {error}")
        print(f"Objective Value: {ObjFun(result[0], Instances[1])}, Error: {error}")



# Escribir los resultados en un archivo
#write_results(results_file_path, results)