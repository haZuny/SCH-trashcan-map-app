from __future__ import absolute_import, division, print_function, unicode_literals
import numpy as np
import os
from os.path import join
import pandas as pd
from keras.applications import ResNet50

from keras.applications.resnet import preprocess_input
from keras.utils import load_img, img_to_array
from sklearn.utils import shuffle
from sklearn.model_selection import train_test_split
import re
import time
import pickle
from keras.applications import DenseNet201


def read_and_prep_images(img_paths, img_height=224, img_width=224):
    imgs = [load_img(img_path, target_size=(img_height, img_width)) for img_path in img_paths]
    img_array = np.array([img_to_array(img) for img in imgs])
    output = preprocess_input(img_array)
    return(img_array)

def extract_resnet(X):
    Densenet_model = DenseNet201(input_shape=(224,224 , 3), weights='imagenet', include_top=False)
    features_array = Densenet_model.predict(X)
    return features_array

def model():
    new_val_path2 = "images/test5"
    new_val_path = [join(new_val_path2, filename) for filename in os.listdir(new_val_path2)]
    new_val = read_and_prep_images(new_val_path)

    new_val = extract_resnet(new_val)

    new_val_re = np.reshape(new_val, (1, -1))

    with open("ss.h5", "rb") as fr:
        ss = pickle.load(fr)
    new_val_re = ss.transform(new_val_re)

    with open("pca.h5", "rb") as fr:
        pca = pickle.load(fr)
    new_val_re = pca.transform(new_val_re)

    with open("if_clf.h5", "rb") as fr:
        if_clf = pickle.load(fr)
    if_preds2 = if_clf.predict(new_val_re)
    return if_preds2[0]

model()