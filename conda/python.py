# Minimalistic .py test file
# See python.ipynb for more robust tests.
 
import sys
print(sys.executable)
print(sys.path)

import pandas as pd
df = pd.DataFrame([1,2,4])
print(df)