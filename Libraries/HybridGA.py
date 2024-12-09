########## Libraries ##########
import numpy as np
import sys
import os
import random
import copy

########## Own files ##########
# Path from the workspace.
sys.path.append(os.path.join(os.path.dirname(__file__), 'Libraries'))
import GAoperators
from TabuSearch import ObjFun
from GLS import Guided_Local_Search_H
from GLS import get_neighbors_2opt
from GLS import best_neighbor

###### LS classic #####

def GAc_Hybrid(Pop_size, DistanceMatrix, AmountNodes,
                     MaxOfCalls, tournament_size,
                     Crossover_rate, Mutation_rate, 
                     alpha, CallsGA, elitist):
    
    num_elitists = int(Pop_size * elitist)

    # Generar las soluciones elitistas basadas en GLS
    reference_solution = Guided_Local_Search_H(DistanceMatrix, AmountNodes, CallsGA, alpha)
    pop = [GAoperators.scramble_mutation(reference_solution[-1], 100) for _ in range(num_elitists)]
    pop[0] = reference_solution[-1]

    # Generar el resto de las soluciones aleatorias
    random_solutions = [
        np.random.permutation(reference_solution[-1]) for _ in range(Pop_size - num_elitists)
    ]

    # Combinar ambas partes de la población
    pop = pop + random_solutions

    # Evaluar la población inicial
    pop_eval = GAoperators.Evaluate(pop, DistanceMatrix)

    # Registro de las generaciones y la mejor solución
    calls = CallsGA + Pop_size
    Generations = []
    Generations.append(pop_eval)
    Best = min(pop_eval, key=lambda x: x[1])

    # Crear un conjunto con las representaciones de los cromosomas como tuplas
    pop_eval_set = set(tuple(par[0]) for par in pop_eval)

    # Iteraciones del algoritmo genético
    while calls < MaxOfCalls:
        childs = []
        
        # Selección, cruce y mutación
        for i in range(Pop_size):
            parent1 = GAoperators.tournament_selection(pop_eval, tournament_size)
            parent2 = GAoperators.tournament_selection(pop_eval, tournament_size)

            if random.random() < Crossover_rate:
                child1, child2 = GAoperators.OX(parent1[0], parent2[0])

                # Mutación
                m_child1 = GAoperators.inversion_mutation(child1, Mutation_rate)
                m_child2 = GAoperators.inversion_mutation(child2, Mutation_rate)

                # Evaluación de los hijos
                m_child1 = (m_child1, ObjFun(m_child1, DistanceMatrix))
                m_child2 = (m_child2, ObjFun(m_child2, DistanceMatrix))
                calls += 2

                # Agregar los hijos solo si no están duplicados
                if tuple(m_child1[0]) not in pop_eval_set:
                    childs.append(m_child1)
                    pop_eval_set.add(tuple(m_child1[0]))

                if tuple(m_child2[0]) not in pop_eval_set:
                    childs.append(m_child2)
                    pop_eval_set.add(tuple(m_child2[0]))

        # Integración de los nuevos hijos a la población
        pop_eval.extend(childs)

        # Reducción de población (sin necesidad de recorrer toda la población)
        pop_eval = GAoperators.reduce_population(pop_eval, Pop_size)
        
        # Actualizar la mejor solución
        current_best = min(pop_eval, key=lambda x: x[1])
        if current_best[1] < Best[1]:
            Best = current_best

        # Registrar las generaciones
        Generations.append(pop_eval)

    return Best, Generations


def GAc_Hybrid_1(Pop_size, DistanceMatrix, AmountNodes,
                     MaxOfCalls, tournament_size,
                     Crossover_rate, Mutation_rate):
    
    calls = 0

    # Generar las soluciones elitistas basadas en GLS
    pop = [GAoperators.first_solution(AmountNodes) for _ in range(Pop_size)]
    for i in range(len(pop)):
        cost = ObjFun(pop[i], DistanceMatrix)
        calls += 1
        vecinos = get_neighbors_2opt(pop[i],DistanceMatrix)
        for vecino in vecinos:
            cost_vecino = ObjFun(vecino, DistanceMatrix)
            calls += 1
            if(cost_vecino < cost):
                pop[i] = vecino
                break

    # Evaluar la población inicial
    pop_eval = GAoperators.Evaluate(pop, DistanceMatrix)

    # Registro de las generaciones y la mejor solución
    calls += Pop_size + (AmountNodes*(AmountNodes-1)//2)
    Generations = []
    Generations.append(pop_eval)
    Best = min(pop_eval, key=lambda x: x[1])

    # Crear un conjunto con las representaciones de los cromosomas como tuplas
    pop_eval_set = set(tuple(par[0]) for par in pop_eval)

    # Iteraciones del algoritmo genético
    while calls < MaxOfCalls:
        childs = []
        
        # Selección, cruce y mutación
        for i in range(Pop_size):
            parent1 = GAoperators.tournament_selection(pop_eval, tournament_size)
            parent2 = GAoperators.tournament_selection(pop_eval, tournament_size)

            if random.random() < Crossover_rate:
                child1, child2 = GAoperators.OX(parent1[0], parent2[0])

                # Mutación
                m_child1 = GAoperators.inversion_mutation(child1, Mutation_rate)
                m_child2 = GAoperators.inversion_mutation(child2, Mutation_rate)

                # Evaluación de los hijos
                m_child1 = (m_child1, ObjFun(m_child1, DistanceMatrix))
                m_child2 = (m_child2, ObjFun(m_child2, DistanceMatrix))
                calls += 2

                # Agregar los hijos solo si no están duplicados
                if tuple(m_child1[0]) not in pop_eval_set:
                    childs.append(m_child1)
                    pop_eval_set.add(tuple(m_child1[0]))

                if tuple(m_child2[0]) not in pop_eval_set:
                    childs.append(m_child2)
                    pop_eval_set.add(tuple(m_child2[0]))

        # Integración de los nuevos hijos a la población
        pop_eval.extend(childs)

        # Reducción de población (sin necesidad de recorrer toda la población)
        pop_eval = GAoperators.reduce_population(pop_eval, Pop_size)
        
        # Actualizar la mejor solución
        current_best = min(pop_eval, key=lambda x: x[1])
        if current_best[1] < Best[1]:
            Best = current_best

        # Registrar las generaciones
        Generations.append(pop_eval)

    vecinos_final = get_neighbors_2opt(Best[0], DistanceMatrix)
    for vecino in vecinos_final:
        cost = ObjFun(vecino, DistanceMatrix)
        if(cost < Best[1]):
            Best = (vecino, cost)

    return Best, Generations

