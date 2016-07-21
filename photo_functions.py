# -*- coding: utf-8 -*-
"""
Created on Fri Feb 19 09:57:50 2016

@author: Jeff
"""
import yaml
from collections import namedtuple
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.image as mpimg
import matplotlib.patches as patches

class Opener:
    
    def __init__(self, fileName):
            with open(fileName, 'r') as f:
                init_dict = yaml.load(f)
            self.init_dict = init_dict
            uservars = namedtuple('uservars', init_dict['uservars'].keys())
            self.uservars = uservars(**init_dict['uservars'])
            usernames = namedtuple('usernames', init_dict['usernames'].keys())
            self.usernames = usernames(**init_dict['usernames'])
            userIms = namedtuple('userIms', init_dict['userIms'].keys())
            self.userIms = userIms(**init_dict['userIms'])
            
        
    def plotImages(self):
        out = self.usernames.output        
        
        # the output variable img will be unit8 data dtype, so with 8 bits, and will be a matrix of lists, where every list
        # is a pixel, and will have 3 columns of values, one for each R, G, and B. im not sure what the rows are yet, maybe brigthness?
        imNum = self.userIms.imNums
        
        niv = self.uservars.vert
        nih = self.uservars.horz
        ws = self.uservars.wspace
        hs = self.uservars.hspace
        rs = self.uservars.right
        ls = self.uservars.left
        us = self.uservars.top
        ds = self.uservars.bottom
        st = self.uservars.st
        
        x = np.repeat(np.arange(niv,dtype = 'int32'),nih)
        y = np.tile(np.arange(nih,dtype = 'int32'),niv)
        m = np.matrix([x,y])
        m = np.matrix.transpose(m)    
        
        f, axarr = plt.subplots(niv,nih)
        
        for i in range(niv*nih):
            
            fileLoc = 'D:/Field_data/2013/Summer/Images/JWC/GL1/Photogrammetry/July17/GL1PG1ST1/IMG_'+imNum[i]+'.jpg'
            img = mpimg.imread(fileLoc)   
            ipos = m[i,:]
            imgplot = axarr[ipos[0,0],ipos[0,1]].imshow(img)
            axarr[ipos[0,0],ipos[0,1]].text(0.2, 0.9,imNum[i], ha='center', va='center',transform= axarr[ipos[0,0],ipos[0,1]].transAxes, color = 'white')

        
        f.subplots_adjust(hspace=hs, wspace=ws, right=rs, left=ls, top=us, bottom=ds)
        plt.setp([a.get_xticklabels() for a in f.axes[:]], visible=False)
        plt.setp([a.get_yticklabels() for a in f.axes[:]], visible=False)
#        axarr[0,0].set_title(self.usernames.titl)
        f.suptitle(self.usernames.titl, fontsize=14, fontweight='bold', y=st)
        
        
        f.savefig(out, dpi = 600, orientation= 'landscape')