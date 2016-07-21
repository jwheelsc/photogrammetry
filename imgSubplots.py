# -*- coding: utf-8 -*-
"""
Created on Thu Feb 18 11:07:02 2016

@author: Jeff
"""


from PIL import Image
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.image as mpimg


from photo_functions import Opener

if __name__ == "__main__":
    
    plt.close('all')
    filename = 'D:/Field_data/2013/Summer/Images/JWC/GL1/Photogrammetry/July17/GL1PG1ST1/imageNums_lower.yaml'
    var = Opener(filename)
    
    var.plotImages()
    



