#include <stdio.h>
#include <stdlib.h>

/*
 * Très fortement inspiré de
 * https://openclassrooms.com/courses/les-listes-doublement-chainees-en-langage-c
 * 
 * Ne sont codées que les fonctions ajoutant un élément en début et
 * en fin de chaine. Ces instructions seront les seules utiles
 * lors de la manipulation de la bande de la machine de Turing
 * 
 */

typedef struct node {
	int data;
	struct node *p_next;
	struct node *p_prev;
} Node;

typedef struct dlist {
	size_t length;
	struct node *p_tail;
	struct node *p_head;
} Dlist;

//Constructeur
Dlist *dlist_new(void)
{
    Dlist *p_new = malloc(sizeof *p_new);
    if (p_new != NULL)
    {
        p_new->length = 0;
        p_new->p_head = NULL;
        p_new->p_tail = NULL;
    }
    return p_new;
}
	
//Ajoute un élément data à la fin de la chaine	
Dlist *dlist_append(Dlist *p_list, int data)
{
    if (p_list != NULL)
    {
        Node *p_newNode = malloc(sizeof *p_newNode);
        if (p_newNode != NULL)
        {
            p_newNode->data = data; //Ajout de notre int
            p_newNode->p_next = NULL; //c'est le dernier de la dlist
            if (p_list->p_tail == NULL) 
            {
                p_newNode->p_prev = NULL; //SI la liste était vide, notre elmt est le premier
                p_list->p_head = p_newNode; 
                p_list->p_tail = p_newNode;
            }
            else 
            {
                p_list->p_tail->p_next = p_newNode; 
                p_newNode->p_prev = p_list->p_tail; 
                p_list->p_tail = p_newNode; 
            }
            p_list->length++; 
        }
    }
    return p_list;
}

//Idem au début
Dlist *dlist_prepend(Dlist *p_list, int data)
{
    if (p_list != NULL)
    {
        Node *p_new = malloc(sizeof *p_new);
        if (p_new != NULL)
        {
            p_new->data = data;
            p_new->p_prev = NULL;
            if (p_list->p_tail == NULL)
            {
                p_new->p_next = NULL;
                p_list->p_head = p_new;
                p_list->p_tail = p_new;
            }
            else
            {
                p_list->p_head->p_prev = p_new;
                p_new->p_next = p_list->p_head;
                p_list->p_head = p_new;
            }
            p_list->length++;
       }
    }
    return p_list;
}

/* Affiche la liste p_list en considérant myNode comme le noeud sur lequel
 * la tête de L/E de la machine de Turing est placé
 * 
 * Attention : le caractère espace est affiché _ pour des raisons de lisibilité
 * 
 */
void dlist_display(Dlist *p_list, Node *myNode) {
	int value;
	Node *current_node = malloc(sizeof *current_node);
	printf("Bande : ");
	current_node = p_list->p_head;
	while(current_node != NULL) {
		value = current_node->data;
		if(myNode == current_node) { //Affichage en couleur de myNode
			if(value == ' ') {
				printf("\033[1;33m\033[40m_\033[0m");
			} else {
				printf("\033[1;33m\033[40m%c\033[0m", value);
			}
		} else {
			if(value == ' ') {
				printf("_");
			} else {
				printf("%c", value);
			}
		}
		
		current_node = current_node->p_next;
	}
	printf("\n");
}
