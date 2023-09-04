import matplotlib.pyplot as plt
import pandas as pd

data = [153, 189, 221, 215, 302, 223, 201, 173, 121, 106, 86, 87, 108,
        133, 177, 241, 228, 283, 255, 238, 164, 128, 108, 87, 95, 95,
        145, 200, 187, 201, 292, 220, 233, 172, 119, 81, 65, 76, 74,
        111, 170, 243, 178, 248, 202, 163, 139, 120, 96, 95, 53, 94]
date_range = pd.date_range(start='1967-01-01', periods=52, freq='4W')
df = pd.DataFrame({'date': date_range, 'sales': data})
plt.figure(figsize=(10, 7))
plt.plot(df['date'], df['sales'])
plt.xticks(rotation=45)
plt.show()
