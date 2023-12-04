import numpy as np
import matplotlib.pyplot as plt

data = [2.7, 7.8, 6.2, 10.7, 9.6, 14.0, 13.2, 16.1, 17.9, 22.2, 23.7, 24.6, 24.6, 28.7, 28.6, 34.5, 34.1, 39.0,
        38.7, 43.2, 42.3, 46.2, 46.3, 48.5, 49.8]

y = np.matrix(data).reshape(len(data), 1)
a_0 = np.matrix(np.ones((len(data), 1)))
a_1 = np.matrix(range(1, len(data) + 1)).reshape(len(data), 1)
b_1 = np.matrix([np.cos(np.pi * t) for t in range(1, len(data) + 1)]).reshape(len(data), 1)
c_1 = np.matrix([np.sin(np.pi * t) for t in range(1, len(data) + 1)]).reshape(len(data), 1)
X = np.hstack([a_0, a_1, b_1, c_1])
beta = (X.T * X).I * X.T * y
print(f"a_0: {beta[0, 0]}")
print(f"a_1: {beta[1, 0]}")
print(f"b_1: {beta[2, 0]}")
print(f"c_1: {beta[3, 0]}")
plt.figure(figsize=(10, 6))
plt.plot(range(1, len(data) + 1), data, color='black', label="Actual Data")
plt.plot(range(1, len(data) + 1), X * beta, color='red', label="Predicted Values")
plt.xlabel("t")
plt.ylabel("X_t")
plt.title("Actual vs Predicted Values")
plt.legend()
plt.show()

# # import numpy as np
# # import matplotlib.pyplot as plt
# from scipy.optimize import curve_fit
#
#
# # Define the function to model the time series
# def time_series_model(t, a0, a1, b1, c1):
#     lambda_val = np.pi
#     return a0 + a1 * t + b1 * np.cos(lambda_val * t) + c1 * np.sin(lambda_val * t)
#
#
# # Time series data
# t = np.arange(1, 26)
# data = np.array(
#     [2.7, 7.8, 6.2, 10.7, 9.6, 14.0, 13.2, 16.1, 17.9, 22.2, 23.7, 24.6, 24.6, 28.7, 28.6, 34.5, 34.1, 39.0, 38.7, 43.2,
#      42.3, 46.2, 46.3, 48.5, 49.8])
#
# # Use curve_fit to estimate the coefficients
# initial_guess = (0, 0, 0, 0)  # Initial guess for the coefficients
# params, covariance = curve_fit(time_series_model, t, data, p0=initial_guess)
#
# # Extract the estimated coefficients
# a0_est, a1_est, b1_est, c1_est = params
#
# # Print the estimated coefficients
# print("Estimated Coefficients:")
# print(f"a0: {a0_est}")
# print(f"a1: {a1_est}")
# print(f"b1: {b1_est}")
# print(f"c1: {c1_est}")
# #
# # # Plot the original data and the fitted curve
# # plt.figure(figsize=(10, 6))
# # plt.scatter(t, data, label="Original Data")
# # plt.plot(t, time_series_model(t, *params), 'r', label="Fitted Curve")
# # plt.xlabel("t")
# # plt.ylabel("Xt")
# # plt.legend()
# # plt.title("Fitting Time Series Model")
# # plt.show()
