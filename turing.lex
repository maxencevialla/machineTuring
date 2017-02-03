/*
 * Simulateur de machine de Turing
 * Paramètres :
 * 		- nom de fichier contenant les instructions sous la forme p,s:o,q
 * (les états p et q n'auront qu'un seul caractère, l'alphabet reconnu est constitué
 * de tous les caractères alphanumériques et du caractère espace)
 * 		- état initial de la bande de la machine de Turing sous forme de chaîne de
 * caractères
 * 
 * Le fichier test.tur fourni fait l'opération suivante (les bâtons sont représentés par des 'I' : 
 * 		Entrée: Une séquence de k := a + 1 bâtons suivie d'une séquence de l := b + 1 bâtons.
 * 		Sortie: Une séquence de a + b + 1 bâtons. 
 * 
 * (algorithme détaillé sur http://zanotti.univ-tln.fr/turing/)
 */



%option noyywrap
%{
/* * * * * * * * * * * *
 * * * DEFINITIONS * * *
 * * * * * * * * * * * */
%}

%{
int line_num = 1;
%}

alphanum [0-9a-zA-Z ]
%%

%{
/* * * * * * * * * 
 * * * RULES * * *
 * * * * * * * * */
%}

^[0-9a-zA-Z ],[0-9a-zA-Z ]:[<>0-9a-zA-Z ],[0-9a-zA-Z ]$  { lancer(); }

.* { printf("%d: error: %s \n", line_num, yytext);  }
\n { line_num++; }
%%

/* * * * * * * * * * * 
 * * * USER CODE * * *
 * * * * * * * * * * *
 */
#include "listeD.c"

char currentState;
Dlist *list;
Node *currentNode;
int isTurning;

int main(int argc, char *argv[]) {
	
	//Initialisation de la bande et du statut courant
	list = dlist_new();
	currentNode = malloc(sizeof *currentNode); //Node représentant la position du curseur
	setInitialBande(argv[2]);
	currentNode = list->p_head;
	currentState = 'S';
	
	dlist_display(list, currentNode);
	
	isTurning = 1; //Détermine si on a executé une instruction lors de la lecture du fichier
	
	//Gestion du fichier d'instructions
	char filename[30];
    strcpy(filename, argv[1]);
    FILE *test = fopen(filename, "r+");
    
	yyin = test;
	
	//Tant qu'on execute une instruction parmi celles contenues dans le fichier, on recommence
	while(isTurning) {
		isTurning = 0;
		fseek(test, 0, SEEK_SET); //reset le curseur dans le fichier
		yylex();
	}
	
}

//Initialise la bande avec la chaine de caractères fournis par l'utilisateur
void setInitialBande(char *bandeInit) {
	int size = strlen(bandeInit);
	printf("Initialise la bande avec %s de longueur %d\n", bandeInit, size);
	int i;
	
	for(i = 0 ; i < size+1 ; i++) {
		dlist_append(list, bandeInit[i]);
	}
	
	dlist_append(list, ' '); //On rajoute un espace en fin de bande pour la cohérence
}

//Déplace la tête de L/E à droite de la bande
void moveRight() {
	if(currentNode->p_next == NULL) { //On créé la case à droite si elle n'existe pas
		list = dlist_append(list, ' ');
	}
	
	currentNode = currentNode->p_next;	
}

//Idem vers la gauche
void moveLeft() {
	if(currentNode->p_prev == NULL) {
		list = dlist_prepend(list, ' ');
	}
	
	currentNode = currentNode->p_prev;	
}

//Analyse l'instruction lue par flex et la lance si besoin
void lancer() {
	
	//Chaque information est sur une seule lettre, on peut donc facilement "split"
	char initState = yytext[0];
	char testInst = yytext[2];
	char instruc = yytext[4];
	char nextState = yytext[6];
	
	//Si on doit executer cette instruction
	if(currentState == initState && currentNode->data == testInst) { 
		printf("\n(Etat courant, donnée courante) = (%c, %c)\n", currentState, currentNode->data);
		printf("Instruction valide trouvée : %s\n", yytext);
		
		isTurning = 1; //La machine a executé une instruction pendant cette boucle
		//TODO : idéalement, on recommence au début du fichier à ce moment là
		
		currentState = nextState;
		
		//Traitement particulier des déplacements
		if(instruc == '>') {
			moveRight();
		}
		else if(instruc == '<') {
			moveLeft();
		}
		else { //Si ce n'est pas un déplacement, on a juste à remplacer le contenu de la case
			currentNode->data = instruc;
		}
		dlist_display(list, currentNode);	
	}
	
}
