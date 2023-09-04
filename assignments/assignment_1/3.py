import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

df = pd.read_csv('AirPassengers.csv')


def acf(dt, tc, lag):
    n = len(dt)
    d1 = dt[tc]
    mean_data = np.mean(dt[tc])
    acf_value = sum(
        (d1[:n - lag] - mean_data).reset_index(drop=True) * (d1[lag:] - mean_data).reset_index(drop=True)) / sum(
        (d1 - mean_data).reset_index(drop=True) ** 2)
    return acf_value


def acf_plot(data, target_column, lags):
    acf_values = []
    for i in range(0, lags + 1):
        acf_values.append(acf(data, target_column, i))
    fig, ax = plt.subplots(figsize=(10, 8))
    ax.bar(range(0, 11), acf_values, width=0.03, color='black', alpha=1, align='center')
    ax.set_xlim(-0.2, 10.2)
    ax.set_ylim(-1, 1)
    ax.set_xlabel('Lag')
    ax.set_ylabel('ACF Value')
    ax.set_title('Auto-correlation Function (ACF) for Airline Passengers Data')
    ax.grid(axis='y', linestyle='--', alpha=0.7)
    plt.show()
    return acf_values


print(acf_plot(df, '#Passengers', 10))
#test
