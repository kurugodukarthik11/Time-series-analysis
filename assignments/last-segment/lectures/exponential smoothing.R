library(forecast)
library(zoo)

Amtrak.data <- read.csv("/Users/poseidon_ktk/Desktop/Desktop - Karthik’s MacBook Air/SEM 7/Time series/Group assignment/assignments/sj/lectures/Amtrak_data.csv")
ridership.ts <- ts(Amtrak.data$Ridership, start = c(1991, 1), end = c(2004, 3), freq = 12)


par(mfrow = c(2, 2))
plot(ridership.ts, ylab = "Ridership", xlab = "Time", bty = "l", xlim = c(1991, 2004.25), main = "Ridership")
plot(diff(ridership.ts, lag = 12), ylab = "Lag-12", xlab = "Time", bty = "l", xlim = c(1991, 2004.25), main = "Lag-12 Difference")
plot(diff(ridership.ts, lag = 1), ylab = "Lag-1", xlab = "Time", bty = "l", xlim = c(1991, 2004.25), main = "Lag-1 Difference")
plot(diff(diff(ridership.ts, lag = 12), lag = 1), ylab = "Lag-12, then Lag-1", xlab = "Time", bty = "l", xlim = c(1991, 2004.25), main = "Twice-Differenced (Lag-12, Lag-1)")
# # dev.off()

ridership.deseasonalized <- diff(ridership.ts, lag = 12)
summary(tslm(ridership.deseasonalized ~ trend))

diff.twice.ts <- diff(diff(ridership.ts, lag = 12), lag = 1)
nValid <- 36
nTrain <- length(diff.twice.ts) - nValid
train.ts <- window(diff.twice.ts, start = c(1992, 2), end = c(1992, nTrain + 1))
valid.ts <- window(diff.twice.ts, start = c(1992, nTrain + 2), end = c(1992, nTrain + 1 + nValid))

ses <- ets(train.ts, model = "ANN", alpha = 0.2)
ses.pred <- forecast(ses, h = nValid, level = 0)


plot(ses.pred, ylim = c(-250, 300),  ylab = "Ridership (Twice-Differenced)", xlab = "Time", bty = "l", xaxt = "n", xlim = c(1991,2006.25), main = "", flty = 2)
axis(1, at = seq(1991, 2006, 1), labels = format(seq(1991, 2006, 1)))
lines(ses.pred$fitted, lwd = 2, col = "blue")
lines(valid.ts)
lines(c(2004.25 - 3, 2004.25 - 3), c(-250, 350))
lines(c(2004.25, 2004.25), c(-250, 350))
text(1996.25, 275, "Training")
text(2002.75, 275, "Validation")
text(2005.25, 275, "Future")
arrows(2004 - 3, 245, 1991.5, 245, code = 3, length = 0.1, lwd = 1,angle = 30)
arrows(2004.5 - 3, 245, 2004, 245, code = 3, length = 0.1, lwd = 1,angle = 30)
arrows(2004.5, 245, 2006, 245, code = 3, length = 0.1, lwd = 1, angle = 30)
# # dev.off()
#
#
#
ses.opt <- ets(train.ts, model = "ANN")
ses.opt.pred <- forecast(ses.opt, h = nValid, level = 0)
ses.opt
accuracy(ses.pred, valid.ts)
accuracy(ses.opt.pred, valid.ts)


ar1 <- auto.arima(train.ts)
ar1
arima.pred <- forecast(ar1, h = nValid)

diff.once.ts <- diff(ridership.ts, lag = 12)
diff.df <- data.frame("Time" = as.vector(time(ridership.ts)), "None" = as.vector(ridership.ts), "Once" = c(rep(NA, 12), as.vector(diff.once.ts)), "Twice" = c(rep(NA, 13), as.vector(diff.twice.ts)), "Pred" = c(rep(NA, length(ridership.ts) - nValid), as.vector(ses.pred$mean)))

rts <- window(ridership.ts, start = c(1991, 1), end = c(1991, nTrain))
rets <- ets(rts)
rets
rets.pred <- forecast(rets, h = nValid)
plot(rets.pred)

initial.diff.once <- window(diff.once.ts, start = c(2001, 3), end = c(2001, 3))
once.pred <- as.vector(diffinv(arima.pred$mean, lag = 1, xi = initial.diff.once))
once.pred[2:37]
initial.values <- window(ridership.ts, start = c(2000, 4), end = c(2001, 3))
as.vector(diffinv(once.pred[2:37], lag = 12, xi = initial.values))
final.pred <- diffinv(once.pred[2:37], lag = 12, xi = initial.values)
final.pred[13:48]
accuracy(final.pred[13:48], ridership.ts[124:159])

ets(ridership.ts)$states


nValid <- 36
nTrain <- length(ridership.ts) - nValid
train.ts <- window(ridership.ts, start = c(1991, 1), end = c(1991, nTrain))
valid.ts <- window(ridership.ts, start = c(1991, nTrain + 1), end = c(1991, nTrain + nValid))

hwin <- ets(train.ts, model = "MAA")
hwin.pred <- forecast(hwin, h = nValid, level = c(80, 95))

plot(hwin.pred, ylim = c(1300, 2600),  ylab = "Ridership", xlab = "Time", bty = "l", xaxt = "n", xlim = c(1991,2006.25), main = "", flty = 2)
axis(1, at = seq(1991, 2006, 1), labels = format(seq(1991, 2006, 1)))
lines(hwin.pred$fitted, lwd = 2, col = "blue")
lines(valid.ts)
lines(c(2004.25 - 3, 2004.25 - 3), c(0, 3500))
lines(c(2004.25, 2004.25), c(0, 3500))
text(1996.25, 2500, "Training")
text(2002.75, 2500, "Validation")
text(2005.25, 2500, "Future")
arrows(2004 - 3, 2450, 1991.25, 2450, code = 3, length = 0.1, lwd = 1,angle = 30)
arrows(2004.5 - 3, 2450, 2004, 2450, code = 3, length = 0.1, lwd = 1,angle = 30)
arrows(2004.5, 2450, 2006, 2450, code = 3, length = 0.1, lwd = 1, angle = 30)
#
#
hwin
hwin$states[1, ]  # Initial states
hwin$states[nrow(hwin$states), ]  # Final states
hwin$states


ets.opt <- ets(train.ts, restrict = FALSE, allow.multiplicative.trend = TRUE)

ets.opt.pred <- forecast(ets.opt, h = nValid, level = 0)
plot(ets.opt.pred)
accuracy(hwin.pred, valid.ts)
accuracy(ets.opt.pred, valid.ts)

#########################################


bike.hourly.df <- read.csv("/Users/poseidon_ktk/Desktop/Desktop - Karthik’s MacBook Air/SEM 7/Time series/Group assignment/assignments/sj/lectures/BikeSharingHourly.csv")
nTotal <- length(bike.hourly.df$cnt[13004:13747]) # 31 days * 24 hours/day = 744 hours
bike.hourly.msts <- msts(bike.hourly.df$cnt[13004:13747], seasonal.periods = c(24, 168),
start = c(0, 1))
nTrain <- 21 * 24 # 21 days of hourly data
nValid <- nTotal - nTrain # 10 days of hourly data
yTrain.msts <- window(bike.hourly.msts, start = c(0, 1), end = c(0, nTrain))
yValid.msts <- window(bike.hourly.msts, start = c(0, nTrain + 1), end = c(0, nTotal))
bike.hourly.dshw.pred <- dshw(yTrain.msts, h = nValid)
bike.hourly.dshw.pred.mean <- msts(bike.hourly.dshw.pred$mean, seasonal.periods = c(24, 168),
start = c(0, nTrain + 1))
accuracy(bike.hourly.dshw.pred.mean, yValid.msts)
plot(yTrain.msts, xlim = c(0, 4 + 3/7), xlab = "Week", ylab = "Hourly Bike Rentals")
lines(bike.hourly.dshw.pred.mean, lwd = 2, col = "blue")

bike.daily.df <- read.csv("/Users/poseidon_ktk/Desktop/Desktop - Karthik’s MacBook Air/SEM 7/Time series/Group assignment/assignments/sj/lectures/BikeSharingDaily.csv")
bike.daily.msts <- msts(bike.daily.df$cnt, seasonal.periods = c(7, 365.25))
bike.daily.tbats <- tbats(bike.daily.msts)
bike.daily.tbats.pred <- forecast(bike.daily.tbats, h = 365)
bike.daily.stlm <- stlm(bike.daily.msts, s.window = "periodic", method = "ets")
bike.daily.stlm.pred <- forecast(bike.daily.stlm, h = 365)
par(mfrow = c(1, 2))
plot(bike.daily.tbats.pred, ylim = c(0, 9000), xlab = "Year", ylab = "Daily Bike Rentals",
main = "TBATS")
plot(bike.daily.stlm.pred, ylim = c(0, 9000), xlab = "Year", ylab = "Daily Bike Rentals",
main = "STL + ETS")