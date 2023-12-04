TourismInd = read.csv("TourismData.csv") # importing the data into R

head(TourismInd) # taking a look at a slice of the dataset
tail(TourismInd)

library(forecast) # for the functions tsclean(), ma(), auto.arima()

plot(TourismInd$Y2013, type = "b", xlab = "Jan, 2013 to Dec, 2013",
     ylab = "Foreign Tourist Arrivals in India") # simple plot

plot(y = TourismInd[13, 2:11], x = c(2004:2013), type = "b", xlab = "Years",
     ylab = "Foreign Tourist Arrivals in India") # simple plot

TourismInd1 = TourismInd[-13,]
tail(TourismInd1)

yy = c(TourismInd1[, 2], TourismInd1[, 3], TourismInd1[, 4], TourismInd1[, 5], TourismInd1[, 6],
       TourismInd1[, 7], TourismInd1[, 8], TourismInd1[, 9], TourismInd1[, 10], TourismInd1[, 11])

plot(yy, type = "l")

plot(yy, type = "l", xaxt = "n", xlab = "Years", ylab = "Foreign Tourist Arrivals in India")
axis(side = 1, at = c(6, 18, 30, 42, 54, 66, 78, 90, 102, 114), labels = c(2004:2013))


# Replacing outliers
yy = tsclean(yy)

# plots with the outlier replaced by a smoothed value

plot(yy, type = "l", xaxt = "n", xlab = "Years", ylab = "Foreign Tourist Arrivals in India")
axis(side = 1, at = c(6, 18, 30, 42, 54, 66, 78, 90, 102, 114), labels = c(2004:2013))

TourismDatalong = read.csv("TourismDatalong.csv")

tail(TourismDatalong)

# introducing monthly seasonality in the model
TourismDatalong$MAFTA = ma(TourismDatalong$FTA, order = 12)

tail(TourismDatalong)

library(ggplot2)

# superimposing the deseasonalized curve (monthly effect has been removed - so curve has
#been smoothened) on the raw data

ggplot() +
  geom_line(data = TourismDatalong, lwd = 2, aes(x = Year, y = FTA, colour = "Monthly FTA")) +
  geom_line(data = TourismDatalong, lwd = 2, aes(x = Year, y = MAFTA, colour = "Annual Moving Average")) +
  ylab('Foreign Tour Arrivals')

# decomposing the time series into its components - trend, seasonality, irregular component (noise)
count_ma = ts(na.omit(TourismDatalong$FTA), frequency = 12)
decomp = stl(count_ma, s.window = "periodic")
deseasonal_cnt <- seasadj(decomp)
plot(decomp)

# not recommended
auto.arima(TourismDatalong$FTA) # ARIMA fits better to stationary series

# determining the AR, MA order and order of differencing required
par(mfrow = c(1, 2))
Acf(TourismDatalong$FTA, main = "")
Pacf(TourismDatalong$FTA, main = "")
dev.off()

# testing for stationarity
library(tseries) # for the function adf.test

# might need differencing to make it stationary

# differencing the series: second order differencing as suggested by the PACF plot
count_d2 = diff(deseasonal_cnt, differences = 1)
plot(count_d2)
abline(0, 1, col = 2)

adf.test(count_d2, alternative = "stationary")
# Conclusion: Series is stationary

# Checking AR, MA orders and order of differncing for the differenced series
par(mfrow = c(1, 2))
Acf(count_d2, main = 'ACF for Differenced Series')
Pacf(count_d2, main = 'PACF for Differenced Series')
dev.off()

auto.arima(count_d2, seasonal = FALSE) # fitting an ARIMA model to the differenced series

fit <- auto.arima(count_d2, seasonal = FALSE)
tsdisplay(residuals(fit), lag.max = 45, main = '(0,0,1) Model Residuals') # Model diagnostics

# Ljung Box test to test independence of model residuals
Box.test(resid(fit), lag = 1, type = "Ljung", fitdf = 0)
# p-value provides evidence against dependence of residuals - model residudals are independent

# forecasting for 2014
fcast <- forecast(fit, h = 12)
fcast
plot(fcast)


# fitting an ARIMA function to the deseasonalized series
auto.arima(deseasonal_cnt, seasonal = FALSE)

fit <- auto.arima(deseasonal_cnt, seasonal = FALSE)
tsdisplay(residuals(fit), lag.max = 45, main = '(0,1,1) Model Residuals') # Model diagnostics

# Ljung Box test to test independence of model residuals
Box.test(resid(fit), lag = 1, type = "Ljung", fitdf = 0)
# p-value provides evidence against dependence of residuals - model residudals are independent

# forecasting for 2014
fcast = forecast(fit, h = 12)
fcast
plot(fcast)

library(astsa)

fit = sarima(TourismDatalong$FTA, 5, 1, 12, 0, 1, 1, 12)

fcast = sarima.for(TourismDatalong$FTA, 12, 5, 1, 12, 0, 1, 1, 12)
fcast


