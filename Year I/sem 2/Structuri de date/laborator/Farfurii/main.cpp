#include <fstream>

using namespace std;

ifstream in("farfurii.in");
ofstream out("farfurii.out");

int main()
{
    long long n, k, nr = 1, i;
    in >> n >> k;

    while(nr * (nr - 1) / 2 < k)
        nr++;

    for(i = 1; i <= n - nr; i++)
        out << i <<' ';

    k = n - (nr * (nr - 1) / 2 - k);
    out << k <<' ';

    for(i = n; i > n - nr; i--)
        if(i != k)
            out << i <<' ';

    return 0;
}
