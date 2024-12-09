########## Libraries ##########
import numpy as np
import random
import os
import sys
import copy
sys.path.append(os.path.join(os.path.dirname(__file__), 'Libraries'))
from TabuSearch import (
    ObjFun,
    first_solution
)

def two_opt_swap(Solution, i, j, DistanceMatrix):
    """
    two_opt_swap (function)
        Input: Solution, two indices i and j, and the DistanceMatrix.
        Output: New solution with 2-opt swap applied and updated cost.
        Description: Reverses the tour between indices i and j
        and calculates the change in the objective function.
    """
    n = len(Solution)
    
    # Cost before the swap
    before_swap = (DistanceMatrix[Solution[i - 1] - 1][Solution[i] - 1] +
                   DistanceMatrix[Solution[j] - 1][Solution[(j + 1) % n] - 1])
    
    # Cost after the swap
    after_swap = (DistanceMatrix[Solution[i - 1] - 1][Solution[j] - 1] +
                  DistanceMatrix[Solution[i] - 1][Solution[(j + 1) % n] - 1])
    
    # Reverse the segment between i and j
    new_solution = np.copy(Solution)
    new_solution[i:j+1] = np.flip(Solution[i:j+1])  # Reverse the segment
    
    # Calculate the change in objective function
    cost_change = after_swap - before_swap
    return new_solution

def get_neighbors_2opt(Solution, DistanceMatrix):
    neighbors = []
    n = len(Solution)
    for i in range(n - 1):
        for j in range(i + 1, n):
            if j - i == 1:  # Cambiar sólo si i y j no son adyacentes
                continue
            if j == n - 1:  # Evitar el último índice para j
                neighbor = two_opt_swap(Solution, i, j, DistanceMatrix)
                neighbors.append(neighbor)
            else:  # Aquí j puede ser el penúltimo índice
                neighbor = two_opt_swap(Solution, i, j, DistanceMatrix)
                neighbors.append(neighbor)
    return neighbors

def best_neighbor(Neighborhood, alpha, DistanceMatrix, penalties):
    """
    Buscar el mejor vecino según la penalización.
    """
    Best = None
    Best_f = float('inf')

    for candidate in Neighborhood:
        candidate_f = ObjFun(candidate, DistanceMatrix)
        candidate_f_p = candidate_f

        # Agregar penalización a la función objetivo
        for i in range(len(candidate) - 1):
            candidate_f_p += alpha * penalties[candidate[i]-1, candidate[i + 1]-1]

        if candidate_f_p < Best_f:
            Best = copy.deepcopy(candidate)
            Best_f = copy.deepcopy(candidate_f_p)

    return Best, Best_f


def Guided_Local_Search(DistanceMatrix, AmountNodes, MaxOFcalls=100, alpha=0.2):
    """
    Implementación de Guided Local Search para TSP
    """
    # Inicialización de la solución
    BestSolution = first_solution(AmountNodes)
    CurrentSolution = np.copy(BestSolution)

    # Matriz de penalizaciones
    penalties = np.zeros((AmountNodes, AmountNodes))  # Penalización entre todas las ciudades
    utilities = np.zeros((AmountNodes, AmountNodes))  # Utilidad de los pares de ciudades
    
    # Registro de resultados
    bests_n = []  # Historial de costos de las mejores soluciones
    best_sol = []  # Historial de las mejores soluciones
    
    calls = 1  # Contador de llamadas a la función objetivo

    # Regularización dinamica.
    regularizacion = alpha * (ObjFun(BestSolution,DistanceMatrix) / (AmountNodes))

    while calls < MaxOFcalls:
        # Generar vecinos usando 2-opt
        Neighborhood = get_neighbors_2opt(CurrentSolution, DistanceMatrix)
        calls += len(Neighborhood)
        Aux_calls = calls
        calls = 2 + calls + (AmountNodes-1)*(AmountNodes-2)//2

        if MaxOFcalls < calls:
            n = MaxOFcalls - Aux_calls
            BestNeighbor, BestNeighbor_f = best_neighbor(Neighborhood[:n], regularizacion, 
                                                         DistanceMatrix, penalties)
        else:
            BestNeighbor, BestNeighbor_f = best_neighbor(Neighborhood, regularizacion, 
                                                         DistanceMatrix, penalties)

        regularizacion = alpha * (ObjFun(BestNeighbor, DistanceMatrix) / (AmountNodes))

        # Calcular la utilidad y actualizar las penalizaciones
        max_utility = 0
        for i in range(len(BestNeighbor) - 1):
            pair_penalty = penalties[BestNeighbor[i]-1, BestNeighbor[i + 1]-1]
            pair_distance = DistanceMatrix[BestNeighbor[i]-1, BestNeighbor[i + 1]-1]
            utilities[BestNeighbor[i]-1, BestNeighbor[i + 1]-1] = pair_distance / (1 + pair_penalty)
            utilities[BestNeighbor[i + 1]-1, BestNeighbor[i]-1] = pair_distance / (1 + pair_penalty)

            # Encontrar la utilidad máxima
            max_utility = max(max_utility, utilities[BestNeighbor[i]-1, BestNeighbor[i + 1]-1])

        # Actualizar las penalizaciones basadas en la utilidad máxima
        for i in range(len(BestNeighbor) - 1):
            if utilities[BestNeighbor[i]-1, BestNeighbor[i + 1]-1] == max_utility:
                penalties[BestNeighbor[i]-1, BestNeighbor[i + 1]-1] += 1
                penalties[BestNeighbor[i + 1]-1, BestNeighbor[i]-1] += 1 

        # Actualizar la solución si se encuentra una mejora
        if BestNeighbor_f < ObjFun(BestSolution, DistanceMatrix):
            BestSolution = np.copy(BestNeighbor)
        
        CurrentSolution = BestNeighbor

        # Registrar las mejores soluciones y costos
        best_sol.append(ObjFun(BestSolution, DistanceMatrix))
        bests_n.append(ObjFun(BestNeighbor, DistanceMatrix))

    return bests_n, best_sol

def Guided_Local_Search_H(DistanceMatrix, AmountNodes, MaxOFcalls=100, alpha=0.2):
    """
    Implementación de Guided Local Search para TSP
    """
    # Inicialización de la solución
    BestSolution = first_solution(AmountNodes)
    CurrentSolution = np.copy(BestSolution)

    # Matriz de penalizaciones
    penalties = np.zeros((AmountNodes, AmountNodes))  # Penalización entre todas las ciudades
    utilities = np.zeros((AmountNodes, AmountNodes))  # Utilidad de los pares de ciudades
    
    # Registro de resultados
    bests_n = []  # Historial de costos de las mejores soluciones
    best_sol = []  # Historial de las mejores soluciones
    
    calls = 1  # Contador de llamadas a la función objetivo

    # Regularización dinamica.
    regularizacion = alpha * (ObjFun(BestSolution,DistanceMatrix) / (AmountNodes))

    while calls < MaxOFcalls:
        # Generar vecinos usando 2-opt
        Neighborhood = get_neighbors_2opt(CurrentSolution, DistanceMatrix)
        calls += len(Neighborhood)
        Aux_calls = calls

        if MaxOFcalls < calls:
            n = MaxOFcalls - Aux_calls
            BestNeighbor, BestNeighbor_f = best_neighbor(Neighborhood[:n], regularizacion, 
                                                         DistanceMatrix, penalties)
        else:
            BestNeighbor, BestNeighbor_f = best_neighbor(Neighborhood, regularizacion, 
                                                         DistanceMatrix, penalties)

        regularizacion = alpha * (ObjFun(BestNeighbor, DistanceMatrix) / (AmountNodes))

        # Calcular la utilidad y actualizar las penalizaciones
        max_utility = 0
        for i in range(len(BestNeighbor) - 1):
            pair_penalty = penalties[BestNeighbor[i]-1, BestNeighbor[i + 1]-1]
            pair_distance = DistanceMatrix[BestNeighbor[i]-1, BestNeighbor[i + 1]-1]
            utilities[BestNeighbor[i]-1, BestNeighbor[i + 1]-1] = pair_distance / (1 + pair_penalty)
            utilities[BestNeighbor[i + 1]-1, BestNeighbor[i]-1] = pair_distance / (1 + pair_penalty)

            # Encontrar la utilidad máxima
            max_utility = max(max_utility, utilities[BestNeighbor[i]-1, BestNeighbor[i + 1]-1])

        # Actualizar las penalizaciones basadas en la utilidad máxima
        for i in range(len(BestNeighbor) - 1):
            if utilities[BestNeighbor[i]-1, BestNeighbor[i + 1]-1] == max_utility:
                penalties[BestNeighbor[i]-1, BestNeighbor[i + 1]-1] += 1
                penalties[BestNeighbor[i + 1]-1, BestNeighbor[i]-1] += 1 

        # Actualizar la solución si se encuentra una mejora
        if BestNeighbor_f < ObjFun(BestSolution, DistanceMatrix):
            BestSolution = np.copy(BestNeighbor)
        
        CurrentSolution = BestNeighbor

        # Registrar las mejores soluciones y costos
        best_sol.append(copy.deepcopy(BestSolution))

    return best_sol