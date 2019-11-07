#include <iostream>
#include <string.h>
#include <algorithm>
#include <list>
#include <vector>
#include <map>
#include <assert.h>

using namespace std;
int n, m;

vector<int> del;
vector<vector<char>> adj;
vector<vector<int>> ans;

int mask[200];
bool vis[200];

map<vector<int>, bool> a;

void dfs(int i) {
    vis[i] = 1;
    for (int j = 0; j < n; j++) {
        if (adj[i][j] && !vis[j]) dfs(j);
    }
}

int main() {
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
    short u, v, f, s;
    cin >> n >> m;

    adj.resize(n, vector<char>(n));



    int st = 201;
    for (int i = 0; i < m; ++i) {
        cin >> u >> v;
        --u, --v;
        adj[u][v] = 1;
        adj[v][u] = 1;
        if (st > u) st = u;
        if (st > v) st = v;
        mask[u]++;
        mask[v]++;
    }

    if(st == 201){
        cout<<"0";
        return 0;
    }

    dfs(st);
    for (int i = 0; i < n; i++) {
        if (mask[i] > 0) {
            if (mask[i] % 2 == 1 || !vis[i]) {
                cout <<0;
                return 0;
            }
        }
    }
    int sz = 0;
    int last = 0;
    bool exit = false;
    int count = 0;
    int j = st;
    while(sz<10000) {
        while (count < m) {
            bool dlt = false;
            for (int i = last; i < n; i++) {
                if (adj[i][j]) {
                    del.push_back(j);
                    adj[i][j] = 0;
                    adj[j][i] = 0;
                    j = i;
                    dlt = true;
                    count++;
                    break;
                }
            }
            if (!dlt) {
                if (count == 0) {
                    exit = true;
                    break;
                }
                --count;
                last = j + 1;
                adj[del.back()][j] = 1;
                adj[j][del.back()] = 1;
                j = del.back();
                del.pop_back();
                //cout<<endl;
            } else {
                last = 0;
            }
        }
        if (exit) break;
        vector< int> locans;
        locans.resize(0);
        for (int i = 0; i < m; i++) {
            locans.push_back(del[i]);
        }
        locans.push_back(st);
        vector<int> revlocans;
        revlocans.resize(0);
        for (int i = locans.size(); i > 0; i--) {
            revlocans.push_back(locans[i - 1]);
        }

        if (!a[revlocans]) {
            a[locans] = true;
            ans.push_back(locans);
            sz++;
        }
        --count;
        last = j + 1;
        adj[del.back()][j] = 1;
        adj[j][del.back()] = 1;
        j = del.back();
        del.pop_back();
    }

    cout << sz << '\n';
    for (int i = 0; i < ans.size(); i++) {
        for (int j = 0; j < m + 1; j++) {
            cout << ans[i][j] + 1 ;
            if(j<m) cout<<' ';
        }
        if(i+1<ans.size()) cout << '\n';
    }
    return 0;
}