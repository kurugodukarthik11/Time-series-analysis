s_bagh_weekly <- read.csv("/Users/poseidon_ktk/Desktop/Desktop - Karthik’s MacBook Air/SEM 7/Time series/Group assignment/assignments/sj/class/ShazdaBahfiltered - ShazdaBahfiltered.csv") # importing the data into R

#
head(s_bagh_weekly) # taking a look at a slice of the dataset
tail(s_bagh_weekly)

levels(s_bagh_weekly$Location.of.Monitoring.Station)
levels(s_bagh_weekly$Type.of.Location)

library(forecast) # for the functions tsclean(), auto.arima()

plot(s_bagh_weekly$PM.2.5, type = "l", xlab = "Weeks from Jan, 2015 to Nov, 2015",
     ylab = "PM2.5 levels at Shahzada Bagh") # simple plot of weekly PM2.5 levels

library(ggplot2)

s_bagh_weekly$Date <- as.Date(s_bagh_weekly$Sampling.Date, "%d-%m-%Y") # formatting the date

ggplot(s_bagh_weekly, aes(Date, PM.2.5)) +
  geom_line() +
  scale_x_date('month') +
  ylab("Monthly PM2.5 levels") +
  xlab("")
#sophisticated plot

# Replacing outliers
s_bagh_weekly$new_PM2.5 <- tsclean(s_bagh_weekly$PM.2.5)

# plots with the outlier replaced by a smoothed value

plot(s_bagh_weekly$new_PM2.5, type = "l", xlab = "Weeks from Jan, 2015 to Nov, 2015",
     ylab = "PM2.5 levels at Shahzada Bagh")

ggplot(s_bagh_weekly, aes(Date, new_PM2.5)) +
  geom_line() +
  scale_x_date('month') +
  ylab("Monthly PM2.5 levels") +
  xlab("")

# introducing monthly seasonality in the model
s_bagh_weekly$new_PM2.5_monthly <- ma(s_bagh_weekly$new_PM2.5, order = 4)

# superimposing the deseasonalized curve (monthly effect has been removed - so curve has
#been smoothened) on the raw data

ggplot() +
  geom_line(data = s_bagh_weekly, lwd = 2, aes(x = Date, y = new_PM2.5, colour = "Weekly PM2.5 levels")) +
  geom_line(data = s_bagh_weekly, lwd = 2, aes(x = Date, y = new_PM2.5_monthly, colour = "Monthly Moving Average")) +
  ylab('PM2.5 levels')

# decomposing the time series into its components - trend, seasonality, irregular component (noise)
count_ma <- ts(na.omit(s_bagh_weekly$new_PM2.5_monthly), frequency = 4)
decomp <- stl(count_ma, s.window = "periodic")
deseasonal_cnt <- seasadj(decomp)
plot(decomp)
#
# # # not recommended
auto.arima(s_bagh_weekly$new_PM2.5) # ARIMA fits better to stationary series

# determining the AR, MA order and order of differencing required
par(mfrow=c(1,2))
Acf(s_bagh_weekly$new_PM2.5,main="")
Pacf(s_bagh_weekly$new_PM2.5,main="")
# dev.off()
# #
# # testing for stationarity
# library(tseries) # for the function adf.test
#
# adf.test(s_bagh_weekly$new_PM2.5, alternative = "stationary") # Augmented Dickey Fuller test
# # Conclusion: Series is not stationary
#
# # might need differencing to make it stationary
#
# # differencing the series: second order differencing as suggested by the PACF plot
# count_d2 <- diff(deseasonal_cnt, differences = 2)
# plot(count_d2)
#
# adf.test(count_d2, alternative = "stationary")
# # Conclusion: Series is stationary
#
# # Checking AR, MA orders and order of differncing for the differenced series
# par(mfrow=c(1,2))
# Acf(count_d2, main='ACF for Differenced Series')
# Pacf(count_d2, main='PACF for Differenced Series')
# dev.off()
#
# auto.arima(count_d2, seasonal=FALSE) # fitting an ARIMA model to the differenced series
#
# # fitting an ARIMA function to the deseasonalized series
# auto.arima(deseasonal_cnt, seasonal=FALSE)
#
# fit<-auto.arima(deseasonal_cnt, seasonal=FALSE)
# tsdisplay(residuals(fit), lag.max=45, main='(0,2,0) Model Residuals') # Model diagnostics
#
# # Ljung Box test to test independence of model residuals
# Box.test(resid(fit),lag=2,type="Ljung",fitdf=0)
# # p-value provides evidence against dependence of residuals - model residudals are independent
#
# # forecasting for the month of December
# fcast <- forecast(fit, h=4)
# fcast
# plot(fcast)
# #
# # ## Prepared by Dr. Sayantee Jana, IIM N
# # ## This is only for use in classroom lectures and shouldn't be distributed outside of lectures
#
