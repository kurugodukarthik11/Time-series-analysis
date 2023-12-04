library(forecast)

Amtrak.data <- read.csv("/Users/poseidon_ktk/Desktop/SEM 7/Time series/Group assignment/assignments/sj/Amtrak_data.csv")
ridership.ts <- ts(Amtrak.data$Ridership, start = c(1991, 1), end = c(2004, 3), freq = 12)
ridership.lm <- tslm(ridership.ts ~ trend + I(trend^2))

plot(ridership.ts, xlab = "Time", ylab = "Ridership", ylim = c(1300, 2300), bty = "l")

par(mfrow = c(2, 1))
plot(ridership.ts, xlab = "Time", ylab = "Ridership", ylim = c(1300, 2300), bty = "l")
lines(ridership.lm$fitted, lwd = 2)
ridership.ts.zoom <- window(ridership.ts, start = c(1997, 1), end = c(2000, 12))
plot(ridership.ts.zoom, xlab = "Time", ylab = "Ridership", ylim = c(1300, 2300), bty = "l")


nValid <- 36
nTrain <- length(ridership.ts) - nValid
train.ts <- window(ridership.ts, start = c(1991, 1), end = c(1991, nTrain))
valid.ts <- window(ridership.ts, start = c(1991, nTrain + 1), end = c(1991, nTrain + nValid))
ridership.lm <- tslm(train.ts ~ trend + I(trend^2))
ridership.lm.pred <- forecast(ridership.lm, h = nValid, level = 0)
plot(ridership.lm.pred, ylim = c(1300, 2600), ylab = "Ridership", xlab = "Time", bty = "l",
xaxt = "n", xlim = c(1991,2006.25), main = "", flty = 2)
axis(1, at = seq(1991, 2006, 1), labels = format(seq(1991, 2006, 1)))
lines(ridership.lm$fitted, lwd = 2)
lines(valid.ts)
#
accuracy(ridership.lm.pred$mean, valid.ts)
#
# forecast residuals
names(ridership.lm.pred)
ridership.lm.pred$residuals
valid.ts - ridership.lm.pred$mean
hist(ridership.lm.pred$residuals, ylab = "Frequency", xlab = "Forecast Error", bty = "l", main = "")

## Prediction cones

# tumblr.data <- read.csv("Tumblr.csv")
# people.ts <- ts(tumblr.data$People.Worldwide) / 1000000 # Create a time series out of the data.
# people.ets.AAN <- ets(people.ts, model = "AAN") # Fit Model 1 to the time series.
# people.ets.MMN <- ets(people.ts, model = "MMN", damped = FALSE) # Fit Model 2.
# people.ets.MMdN <- ets(people.ts, model = "MMN", damped = TRUE) # Fit Model 3.
# people.ets.AAN.pred <- forecast(people.ets.AAN, h = 115, level = c(0.2, 0.4, 0.6, 0.8))
# people.ets.MMN.pred <- forecast(people.ets.MMN, h = 115, level = c(0.2, 0.4, 0.6, 0.8))
# people.ets.MMdN.pred <- forecast(people.ets.MMdN, h = 115, level = c(0.2, 0.4, 0.6, 0.8))
# par(mfrow = c(1, 3)) # This command sets the plot window to show 1 row of 3 plots.
# plot(people.ets.AAN.pred, xlab = "Month", ylab = "People (in millions)", ylim = c(0, 1000))
# plot(people.ets.MMN.pred, xlab = "Month", ylab="People (in millions)", ylim = c(0, 1000))
# plot(people.ets.MMdN.pred, xlab = "Month", ylab="People (in millions)", ylim = c(0, 1000))
#
## MA

library(zoo)
ma.trailing <- rollmean(ridership.ts, k = 12, align = "right")
ma.centered <- ma(ridership.ts, order = 12)
plot(ridership.ts, ylim = c(1300, 2200), ylab = "Ridership", xlab = "Time", bty = "l", xaxt = "n",
xlim = c(1991,2004.25), main = "")
axis(1, at = seq(1991, 2004.25, 1), labels = format(seq(1991, 2004.25, 1)))
lines(ma.centered, lwd = 2)
lines(ma.trailing, lwd = 2, lty = 2)
legend(1994,2200, c("Ridership","Centered Moving Average", "Trailing Moving Average"), lty=c(1,1,2),
lwd=c(1,2,2), bty = "n")

nValid <- 36
nTrain <- length(ridership.ts) - nValid
train.ts <- window(ridership.ts, start = c(1991, 1), end = c(1991, nTrain))
valid.ts <- window(ridership.ts, start = c(1991, nTrain + 1), end = c(1991, nTrain + nValid))
ma.trailing <- rollmean(train.ts, k = 12, align = "right")
last.ma <- tail(ma.trailing, 1)
ma.trailing.pred <- ts(rep(last.ma, nValid), start = c(1991, nTrain + 1),
end = c(1991, nTrain + nValid), freq = 12)
plot(train.ts, ylim = c(1300, 2600), ylab = "Ridership", xlab = "Time", bty = "l", xaxt = "n",
xlim = c(1991,2006.25), main = "")
axis(1, at = seq(1991, 2006, 1), labels = format(seq(1991, 2006, 1)))
lines(ma.trailing, lwd = 2, col = "blue")
lines(ma.trailing.pred, lwd = 2, col = "blue", lty = 2)
lines(valid.ts)
#
#
#
# ## Visualizations
#
# t(matrix(AirPassengers, nrow = 12, ncol = 12))
#
# colors <- c("green", "red", "pink", "blue",
# "yellow","lightsalmon", "black", "gray",
# "cyan", "lightblue", "maroon", "purple")
# matplot(matrix(AirPassengers, nrow = 12, ncol = 12),
#  type = 'l', col = colors, lty = 1, lwd = 2.5,
#  xaxt = "n", ylab = "Passenger Count")
#  legend("topleft", legend = 1949:1960, lty = 1, lwd = 2.5,
#  col = colors)
#  axis(1, at = 1:12, labels = c("Jan", "Feb", "Mar", "Apr",
#  "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
#
# require(forecast)
# seasonplot(AirPassengers)
# months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
# "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
# matplot(t(matrix(AirPassengers, nrow = 12, ncol = 12)),
# type = 'l', col = colors, lty = 1, lwd = 2.5)
# legend("left", legend = months,
# col = colors, lty = 1, lwd = 2.5)
# monthplot(AirPassengers)
#
# ## 3D plots
#
# require(plotly)
# require(data.table)
# months = 1:12
# ap = data.table(matrix(AirPassengers, nrow = 12, ncol = 12))
# names(ap) = as.character(1949:1960)
# ap[, month := months]
# ap = melt(ap, id.vars = 'month')
# names(ap) = c("month", "year", "count")
# p <- plot_ly(ap, x = ~month, y = ~year, z = ~count,
# color = ~as.factor(month)) %>%
# add_markers() %>%
# layout(scene = list(xaxis = list(title = 'Month'),
# yaxis = list(title = 'Year'),
# zaxis = list(title = 'PassengerCount')))