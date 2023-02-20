#include <fstream>
#include <unordered_set>

using namespace std;

ifstream in("muzica.in");
ofstream out("muzica.out");

unordered_set<long long> melodii_vasile(100001);

int main()
{
    long long n, m, a, b, c, d, e, x, cnt = 0;
    in >> n >> m >> a >> b >> c >> d >> e;

    for(int i = 0; i < n; i++){
        in >> x;
        if(x == a || x == b)
            cnt++;
        else if(x < e)
            melodii_vasile.insert(x);
    }

    for(int i = 2; i < m; i++){
        long long melodie_dj =(c * b + d * a) % e;
        if(melodii_vasile.find(melodie_dj) != melodii_vasile.end()){
            melodii_vasile.erase(melodie_dj);
            cnt++;
        }
        a = b;
        b = melodie_dj;
    }
    out << cnt;
    return 0;
}
