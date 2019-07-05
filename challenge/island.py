dir = [(-1, 0), (0, -1)]
map = []
uf = []

def u(x, y):
    if x == y:
        return
    if uf[x] < uf[y]:
        uf[x] += uf[y]
        uf[y] = x
    else:
        uf[y] += uf[x]
        uf[x] = y

def f(x):
    i = x
    while uf[i] >= 0:
        i = uf[i]
    j = x
    while j != i:
        k = j
        j = uf[j]
        uf[k] = i
    return i

if __name__ == '__main__':
    [n, m] = [int(x) for x in input().strip().split()]
    uf = [-1] * n * m
    for i in range(n):
        map.append(input().strip())
    for i in range(n):
        for j in range(m):
            if map[i][j] == '0':
                continue
            for (dx, dy) in dir:
                ni, nj = i + dx, j + dy
                if ni < 0 or ni >= n or nj < 0 or nj >= m or map[ni][nj] == '0':
                    continue
                u(f(i*m+j), f(ni*m+nj))
    ans = 0;
    for i in range(n):
        for j in range(m):
            if map[i][j] == '1' and uf[i*m + j] < 0:
                ans += 1
    print(ans)
