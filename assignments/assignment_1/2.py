import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

data = [1.6, 0.8, 1.2, 0.5, 0.9, 1.1, 1.1, 0.6, 1.5, 0.8, 0.9, 1.2, 0.5, 1.3, 0.8, 1.2]
df = pd.DataFrame({'data': data})


def acf(dt, tc, lag):
    """
    Method to calculate auto-correlation coefficient of given lag
    :param dt: pd.DataFrame - dataset
    :param tc: string - target column
    :param lag: int - lag
    :return: int - auto-correlation coefficient
    """
    n = len(dt)
    d1 = dt[tc]
    mean_data = np.mean(dt[tc])
    acf_value = sum(
        (d1[:n - lag] - mean_data).reset_index(drop=True) * (d1[lag:] - mean_data).reset_index(drop=True)) / sum(
        (d1 - mean_data).reset_index(drop=True) ** 2)
    return acf_value


# a
fig1 = plt.figure()
plt.plot(range(1, len(data) + 1), df['data'], marker='o')
plt.title('Time Series Plot')
plt.xlabel('t')
plt.ylabel('x(t)')

# c
fig2 = plt.figure()
plt.scatter(df['data'][:15], df['data'][1:16], marker='o')
plt.xlabel('x(t)')
plt.ylabel('x(t+1)')
plt.title('Scatter Plot of x(t) vs x(t+1)')

# d
lag = 1
r1 = acf(df, 'data', lag)
print("Auto-correlation coefficient r1:", r1)
plt.show()

# mean = np.mean(df['data'])
# r1 = sum((data[i] - np.mean(data)) * (data[i + 1] - np.mean(data)) for i in range(len(data) - 1)) / sum(
#     (data[i] - np.mean(data)) ** 2 for i in range(len(data)))
# r1 = sum((df1[:len(data) - lag] - np.mean(df['data'])).reset_index(drop=True) * (
#         df1[lag:] - np.mean(df['data'])).reset_index(drop=True)) / sum(
#     (df1 - np.mean(df['data'])).reset_index(drop=True) ** 2)
