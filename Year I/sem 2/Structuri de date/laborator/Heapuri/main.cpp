#include <fstream>
#include <vector>

using namespace std;

ifstream in("heapuri.in");
ofstream out("heapuri.out");


int v[200001], heap[200001], poz[200001], aux, ind_heap;

void push(int x){
	while (x / 2 && v[heap[x]] < v[heap[x / 2]]){
		aux = heap[x];
		heap[x] = heap[x / 2];
		heap[x / 2] = aux;
		poz[heap[x]] = x;
		poz[heap[x / 2]] = x / 2;
		x /= 2;
	}
}

void pop(int x){
	int y = 0;
	while (x != y){
		y = x;
		if (y * 2 <= ind_heap && v[heap[x]] > v[heap[y * 2]])
            x = y * 2;
		if (y * 2 + 1 <= ind_heap && v[heap[x]]>v[heap[y * 2 + 1]])
            x = y * 2 + 1;

		aux = heap[x];
		heap[x] = heap[y];
		heap[y] = aux;

		poz[heap[x]] = x;
		poz[heap[y]] = y;
	}
}

int main()
{
	int n, cod, x, ind_v = 0;
    in >> n;
	for (int i = 0; i < n; i++){
		in >> cod;
		if (cod == 1){
		    in >> x;
			v[++ind_v] = x;
			heap[++ind_heap] = ind_v;
			poz[ind_v] = ind_heap;
			push(ind_heap);
		} else if (cod == 2) {
			in >> x;
			v[x] = -1;
			push(poz[x]);
			poz[heap[1]] = 0;
			heap[1] = heap[ind_heap--];
			poz[heap[1]] = 1;
			pop(1);
		} else if (cod == 3)
            out << v[heap[1]] <<"\n";
	}

	return 0;
}
