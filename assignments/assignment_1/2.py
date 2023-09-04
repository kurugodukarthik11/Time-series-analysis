import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

data = [1.6, 0.8, 1.2, 0.5, 0.9, 1.1, 1.1, 0.6, 1.5, 0.8, 0.9, 1.2, 0.5, 1.3, 0.8, 1.2]
df = pd.DataFrame({'data': data})
df1 = df['data']
# a
fig1 = plt.figure()
plt.plot(range(1, len(data) + 1), df1, marker='o')
plt.xlabel('t')
plt.ylabel('x(t)')
# c
fig2 = plt.figure()
plt.scatter(df1[:15], df1[1:16], marker='o')
plt.xlabel('x(t)')
plt.ylabel('x(t+1)')
# d
# mean = np.mean(df['data'])
# r1 = sum((data[i] - np.mean(data)) * (data[i + 1] - np.mean(data)) for i in range(len(data) - 1)) / sum(
#     (data[i] - np.mean(data)) ** 2 for i in range(len(data)))
lag = 1
r1 = sum((df1[:len(data) - lag] - np.mean(df['data'])).reset_index(drop=True) * (
        df1[lag:] - np.mean(df['data'])).reset_index(drop=True)) / sum(
    (df1 - np.mean(df['data'])).reset_index(drop=True) ** 2)
print("Auto-correlation coefficient r1:", r1)
plt.show()
