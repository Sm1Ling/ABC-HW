#include <iostream>
#include<string>
#include<ctime>
#include<vector>
#include<omp.h>

using namespace std;



size_t x; //размер матрицы
int** matrix; //матрица
size_t thr; //количество потоков 
long long d = 0; //определитель 



int getNumber(int left, int right)
{
	int temp;
	while (true)
	{
		cout << "Set the number [" << left << " ; " << right << "]" << endl;
		cin >> temp;
		if (temp <left || temp > right)
			continue;
		else
			break;
	}

	return temp;
}


void matrix_generator(int** matrix, bool random)
{
	for (size_t i = 0; i < x; i++)
	{
		for (size_t j = 0; j < x; j++)
		{
			if (random)
			{
				matrix[i][j] = -30 + rand() % 60;
			}
			else
			{
				matrix[i][j] = getNumber(-30, 60);
			}
		}
	}
}


void print_m(int** matrix, int size)
{
	cout << endl;
	for (size_t i = 0; i < size; i++)
	{
		for (size_t j = 0; j < size; j++)
		{
			cout << matrix[i][j] << " ";
		}
		cout << endl;
	}

}

int** minor_matrix(int** matrix, int i, int j, int size)
{
	int** minor_m = new int* [size - 1]; // создание минора по ячейке i;j
	for (size_t k = 0; k < size - 1; k++)
	{
		minor_m[k] = new int[size - 1];
		for (size_t m = 0; m < size - 1; m++)
		{
			if (k < i && m < j)
				minor_m[k][m] = matrix[k][m];
			else if (k >= i && m < j)
				minor_m[k][m] = matrix[1 + k][m];
			else if (k < i && m >= j)
				minor_m[k][m] = matrix[k][m + 1];
			else
				minor_m[k][m] = matrix[k + 1][m + 1];
		}
	}

	//print_m(minor_m, size - 1);

	return minor_m;
}



long long recur_det(int** minor, int n) //вычисление определителя через миноры i,j -отсутствующие строки. n - размер минора
{
	if (n == 1)
		return minor[0][0];
	if (n == 2)
		return (long long)minor[0][0] * (long long)minor[1][1] - (long long)minor[0][1] * (long long)minor[1][0];

	long long dt = 0;
	int k = 1;

	for (size_t i = 0; i < n; i++)
	{
		int** minor_m = minor_matrix(minor, 0, i, n); // получаем миноры минора по первой строке
		k = (i % 2 == 1 ? -1 : 1);
		dt += k * (long long)minor[0][i] * recur_det(minor_m, n - 1);
	}

	return dt;

}


void* count_thread_det(void* param)
{
	int i = (int)param;
	int** minor_m = minor_matrix(matrix, 0, i, x);
	long long k = recur_det(minor_m, x - 1);
	k = (i % 2 == 1 ? -k : k);

	return (void*)(matrix[0][i] * k);
}

long long det()
{

	if (thr > x) //чтобы не получилось что потоков больше чем итераций цикла -- (я ведь потом пытаюсь закрыть неоткрытые потоки)
		thr = x;

	bool firstiter = true;

#pragma omp parallel num_threads(x) reduction (+: d)
	{
#pragma omp for
		for (size_t i = 0; i < x; i++)
		{
			d += (long long) count_thread_det((void*)i);
		}
	}

	return d;
}


int main()
{
	srand(time(0));

	cout << "Set the matix size" << endl;
	x = getNumber(2, 10);
	cout << "Set the number of threads" << endl;
	thr = getNumber(1, 20);

	matrix = new int* [x]; //инициализация 

	for (size_t i = 0; i < x; i++)
	{
		matrix[i] = new int[x];
	}

	cout << "Generate Matrix randomly? Set 1 to agree or 0 to set matrix by your own" << endl;
	matrix_generator(matrix, getNumber(0, 1));

	print_m(matrix, x);

	cout << "Determinant: " << det(); //если посчитал неправильно, то скорее всего произошло переполнение 



}
