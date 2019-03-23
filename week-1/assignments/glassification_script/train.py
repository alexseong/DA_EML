
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import azureml
from azureml.core import Workspace, Run
import pandas as pd

url = 'http://archive.ics.uci.edu/ml/machine-learning-databases/glass/glass.data'
col_names = ['id','ri','na','mg','al','si','k','ca','ba','fe','glass_type']
df = pd.read_csv(url, names=col_names, index_col='id')
