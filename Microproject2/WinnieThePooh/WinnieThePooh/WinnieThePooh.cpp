#include "pthread.h"
#include <iostream>
#include <windows.h>

size_t n; //количество пчел
size_t H; //размер горшка в глотках
size_t fullness; //сколько сейчас глотков в горшке

pthread_t* bees; //указатель на команду пчел

pthread_mutex_t beelock;
pthread_mutex_t bearlock;

size_t iterations;

int getNumber(int left, int right)
{
    int temp;
    while (true)
    {
        std::cout << "Set the number [" << left << " ; " << right << "]" << std::endl;
        std::cin >> temp;
        if (temp <left || temp > right)
            continue;
        else
            break;
    }

    return temp;
}

void* fillPot(void* param)
{
    int bnum = *((int*)param);// указываю номер пчелки
    while (true) //ограничение на работу
    { 
        pthread_mutex_lock(&beelock); //закрываю доступ другим пчелкам на заполнение горшка. Все по очереди
        if (iterations >= UINT16_MAX)// для критического случая, когда все отработали достаточно долго
        {
            pthread_mutex_unlock(&beelock);
            pthread_mutex_unlock(&bearlock);
            return NULL;
        }
        fullness++; // пчелка заполняет горшок на глоток
        std::cout << "Bee number " << bnum << " filled pot and now it contains " << fullness << " lips" << std::endl;
        
        if (fullness == H)
        {
            std::cout << "Bee number " << bnum << " calls Bear" << std::endl;
            pthread_mutex_unlock(&bearlock); //говорим медведю что можно пить
            continue; //снова заполнять горшок пчелкам разрешит уже медведь
        }
        iterations++;
        std::cout << "\tOther bees can get access to fill the pot" << std::endl;
        pthread_mutex_unlock(&beelock); //разрешаем другим пчелкам заполнять горшок
        Sleep(1000);
    }
}

void* drinkPot()
{
    while (true)
    { 
        pthread_mutex_lock(&bearlock); //если медведь не получил разрешение от пчелок на опорожнение горшка, то он будет ждать
        if (iterations >= UINT16_MAX) // для критического случая, когда все отработали достаточно долго
        {
            pthread_mutex_unlock(&beelock);
            return NULL;
        }
        std::cout << "Bear has drunk " << fullness << " lips of honey" << std::endl;
        fullness = 0;
        Sleep(1000);
        iterations++;
        std::cout << "\tOther bees can get access to fill the pot\n" << std::endl;
        pthread_mutex_unlock(&beelock); //говорит пчелкам что 
    }
}


int main()
{
    std::cout << "Set size of the bees team" << std::endl;
    n = getNumber(1, 100); //получение количества пчел в команде
    std::cout << "Set size of the pot" << std::endl;
    H = getNumber(1,1000); //получение размера горшка

    pthread_mutex_init(&beelock, NULL);
    pthread_mutex_init(&bearlock, NULL);

    bees = new pthread_t[n]; // нанятие команды пчел
    fullness = 0;

    int* bs = new int[n];
    for (size_t i = 0; i < n; i++)
    {
        bs[i] = i + 1;
        pthread_create(&bees[i], NULL, fillPot, (void*)(bs+i)); // запускаем команду пчел
    }

    pthread_mutex_lock(&bearlock); //заранее говорим медведю чтобы тот не пил пока пчелки не скажут
    //основной поток это медведь
    drinkPot();


    delete[] bs;
    delete[] bees;
    return 0;

}

