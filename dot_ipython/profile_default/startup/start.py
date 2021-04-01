import collections
import json
import os
import sys

import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import sklearn
import torch
from torch import nn
try:
    import tensorflow as tf
except ImportError:
    pass


sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


# Pandas options
pd.options.display.max_columns = 50
pd.options.display.max_rows = 50
