# Projects

# **Garbage Detection Application**

### Motivation

Garbage disposal is a very important task in a healthy and green environment. With spreading awareness among the citizens of India regarding the importance of a clean environment to decrease the consumption of natural resources and garbage disposal, the recycling industry is booming.

### Overview

This repository contains a custom-built Android Mobile Application that allows a user to click images and detect whether the images contain Garbage/Trash or not, followed by sending the current geo-location of the device. The application is a Smart City-focused application where users can keep the locality clean by alerting the City Council/Management by updating the locations where trash/garbage hasn’t been picked up.

### Models

The project uses inhouse models trained on a custom dataset built from gathering images of various scenarios where garbage exists or doesn’t exist, making this a simple Binary Classification problem. We use the Convolutional Neural Networks as a base for these models. After several experimentations like data augmentation and avoiding overfitting on the “Non-Garbage Image” class label, we arrive at an accuracy of around 96% - 98%. Although our results seem robust, we observe that the model classifies poorly evaluated images that contain single garbage items on the roads and pavements.

We further build one more model which is Pre-Trained on the famous VGG-16 model. The accuracy of this model on images with single trash objects comes close to 92% - 93%. Thus we propose two models in our application. Each targets a specific scenario. The two models we inculcate in our project are given as follows

- Trash Classifier: Aims at classifying single trash items on roads/pavements.
- Dump Classifier: Aims at classifying dumps of garbage gathered in one place.

| Models | Accuracy (%) |
| --- | --- |
| Trash Classifier | 92.23 |
| Dump Classifier | 98.37 |

The models are trained in TensorFlow and a suitable Python environment. The models are further saved using TensorFlow Lite, a sub-package used for deploying mobile friends models.

### Mobile Application

The application is built using Flutter, which uses the DART programming language. The application contains options to select which scenario is being fed to the camera module. The image is further evaluated using the model loaded on the application source code. 

The result is generated showcasing the image and the classification score on the chosen model. If garbage is detected, we also record the geo-location of the device where the image is taken. This location is further sent on a Cloud DB, which could be updated by the city’s garbage collection department.

The application asks for the following permissions from the user:

1. Camera Access
2. Storage Access
3. Location Access

### Improvements

The project, even with robust accuracy, lacks various state-of-the-art techniques and algorithms that can fine-tune the performance of the model.  Various possible improvements include:

- Fine-Tuning Both Models on more data
- Use methods like XGBoost to combine the results of both models.

### Links

- Link to [APK file](https://drive.google.com/drive/u/1/folders/1QJZVfQ8M1zJhhepzQO92-miBizdgl03t)
- Research Paper [Link](https://ieeexplore.ieee.org/document/9573599)
